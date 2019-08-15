//
//  SFMagnifierView.m
//  SFFoundation
//
//  Created by vvveiii on 2019/8/15.
//  Copyright © 2019 lvv. All rights reserved.
//

#import "SFMagnifierView.h"

#if SF_IOS

#define kPreferredFramesPerSecond   4UL

@interface SFMagnifierView () {
    CADisplayLink *_displayLink;
}

@end

@implementation SFMagnifierView

- (void)dealloc {
    [_displayLink invalidate];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _scale = 2;
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(onUpdate:)];

        if (@available(iOS 10.0, *)) {
            _displayLink.preferredFramesPerSecond = kPreferredFramesPerSecond;
        } else {
            _displayLink.frameInterval = kPreferredFramesPerSecond;
        }

        [_displayLink addToRunLoop:NSRunLoop.mainRunLoop forMode:NSRunLoopCommonModes];
        _displayLink.paused = YES;
    }

    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect screenRect = [self.superview convertRect:self.frame toView:nil];
    CGRect targetRect = [_targetView convertRect:screenRect fromView:nil];
    CGContextScaleCTM(ctx, _scale, _scale);
    CGContextTranslateCTM(ctx, -CGRectGetMidX(targetRect), -CGRectGetMidY(targetRect));

    [_targetView.layer renderInContext:ctx];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];

    if (!newSuperview) {
        _displayLink.paused = YES;
    }
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    _displayLink.paused = !self.superview;
}

- (void)onUpdate:(CADisplayLink *)sender {
    if (!_targetView) {
        return;
    }

    if (!self.superview || self.superview.superview) {
        UIView *superview = _targetView.superview;
        while (superview.superview) {
            superview = superview.superview;
        }

        [superview addSubview:self];
    }

    [self.superview bringSubviewToFront:self];
    [self setNeedsDisplay];
}

@end

#endif
