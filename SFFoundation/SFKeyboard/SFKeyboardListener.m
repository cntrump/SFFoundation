//
//  SFKeyboardListener.m
//  SFFoundation
//
//  Created by vvveiii on 2019/8/29.
//  Copyright © 2019 lvv. All rights reserved.
//

#import "SFKeyboardListener.h"

#if SF_IOS

@interface SFKeyboardListener () {
    SFKeyboardListenerBlock _block;
}

@end

@implementation SFKeyboardListener

+ (instancetype)listenerWithBlock:(SFKeyboardListenerBlock)block {
    return [[self alloc] initWithBlock:block];
}

- (void)dealloc {
    [self removeKeyboardListener];
}

- (instancetype)initWithBlock:(SFKeyboardListenerBlock)block {
    if (self = [super init]) {
        _block = [block copy];
        [self addKeyboardListener];
    }

    return self;
}

- (void)addKeyboardListener {
    if (_isObserving) {
        return;
    }

    _isObserving = YES;
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)removeKeyboardListener {
    if (!_isObserving) {
        return;
    }

    _isObserving = NO;
    [NSNotificationCenter.defaultCenter removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)keyboardFrameWillChange:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;

    BOOL isLocal = (BOOL)[userInfo[UIKeyboardIsLocalUserInfoKey] boolValue];

    NSTimeInterval duration = (NSTimeInterval)[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = (UIViewAnimationCurve)[userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];

    CGRect frameBegin = (CGRect)[userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect frameEnd = (CGRect)[userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];

    if (_block) {
        _block(isLocal, duration, curve, frameBegin, frameEnd);
    }
}

@end

#endif
