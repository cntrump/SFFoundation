//
//  SFDisplayLink.m
//  SFFoundation
//
//  Created by vvveiii on 2019/7/23.
//  Copyright © 2019 lvv. All rights reserved.
//

#import "SFDisplayLink.h"

#if SF_MACOS

@interface SFDisplayLink () {
    CVDisplayLinkRef _displayLink;
    __weak id _target;
    SEL _sel;
    CFAbsoluteTime _time;
    BOOL _invalidated;
}

@end

@implementation SFDisplayLink

- (void)dealloc {
    [self invalidate];
}

+ (instancetype)displayLinkWithTarget:(id)target selector:(SEL)sel {
    return [[self alloc] initWithTarget:target selector:sel];
}

- (instancetype)initWithTarget:(id)target selector:(SEL)sel {
    if (self = [super init]) {
        _target = target;
        _sel = sel;
        __weak typeof(self) wself = self;
        CVDisplayLinkCreateWithActiveCGDisplays(&_displayLink);
        CVDisplayLinkSetOutputHandler(_displayLink, ^CVReturn(CVDisplayLinkRef  _Nonnull displayLink, const CVTimeStamp * _Nonnull inNow, const CVTimeStamp * _Nonnull inOutputTime, CVOptionFlags flagsIn, CVOptionFlags * _Nonnull flagsOut) {
            [wself _displayLinkCallback];

            return kCVReturnSuccess;
        });
        CVDisplayLinkSetCurrentCGDisplay(_displayLink, kCGDirectMainDisplay);
        _time = CFAbsoluteTimeGetCurrent();
        self.paused = NO;
    }

    return self;
}

- (BOOL)isPaused {
    if (_invalidated) {
        return YES;
    }

    return !CVDisplayLinkIsRunning(_displayLink);
}

- (void)setPaused:(BOOL)paused {
    if (_invalidated) {
        return;
    }

    if (self.isPaused == paused) {
        return;
    }
    
    paused ? CVDisplayLinkStop(_displayLink) : CVDisplayLinkStart(_displayLink);
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
- (void)_displayLinkCallback {
    if ([_target respondsToSelector:_sel]) {
        CFAbsoluteTime now = CFAbsoluteTimeGetCurrent();
        _duration = now - _time;
        _time = now;
        [_target performSelectorOnMainThread:_sel withObject:self waitUntilDone:NO];
    }
}
#pragma clang diagnostic pop

- (void)invalidate {
    if (_displayLink) {
        CVDisplayLinkRelease(_displayLink);
        _target = nil;
        _sel = NULL;
        _displayLink = NULL;
        _invalidated = YES;
    }
}

@end

#endif
