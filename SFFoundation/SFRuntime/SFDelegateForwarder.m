//
//  SFDelegateForwarder.m
//  SFFoundation
//
//  Created by vvveiii on 2019/7/16.
//  Copyright © 2019 lvv. All rights reserved.
//

#import "SFDelegateForwarder.h"

static BOOL shouldForwardScrollViewDelegateMethodToExternalDelegate(SEL selector) {
    // We cannot forward viewForZoomingInScrollView: to the external delegate, because WebKit
    // owns the content of the scroll view, and depends on viewForZoomingInScrollView being the
    // content view. Any other view returned by the external delegate will break our behavior.
    if (sel_isEqual(selector, NSSelectorFromString(@"viewForZoomingInScrollView:"))) {
        return NO;
    }

    return YES;
}

@implementation SFDelegateForwarder

- (instancetype)initWithInternalDelegate:(id)internalDelegate externalDelegate:(id)externalDelegate {
    if (self = [super init]) {
        _internalDelegate = internalDelegate;

        if (internalDelegate != externalDelegate) {
            _externalDelegate = externalDelegate;
        }
    }

    return self;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    id externalDelegate = _externalDelegate;
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    if (!signature) {
        signature = [(NSObject *)_internalDelegate methodSignatureForSelector:aSelector];
    }

    if (!signature) {
        signature = [(NSObject *)externalDelegate methodSignatureForSelector:aSelector];
    }

    return signature;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    return [super respondsToSelector:aSelector] || [_internalDelegate respondsToSelector:aSelector] || [_externalDelegate respondsToSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    id externalDelegate = _externalDelegate;
    SEL aSelector = [anInvocation selector];
    BOOL internalDelegateWillRespond = [_internalDelegate respondsToSelector:aSelector];
    BOOL externalDelegateWillRespond = shouldForwardScrollViewDelegateMethodToExternalDelegate(aSelector) &&
                                        [externalDelegate respondsToSelector:aSelector];

    if (internalDelegateWillRespond) {
        [anInvocation invokeWithTarget:_internalDelegate];
    }

    if (externalDelegateWillRespond) {
        [anInvocation invokeWithTarget:externalDelegate];
    }

    if (!internalDelegateWillRespond && !externalDelegateWillRespond) {
        [super forwardInvocation:anInvocation];
    }
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    BOOL internalDelegateWillRespond = [_internalDelegate respondsToSelector:aSelector];
    BOOL externalDelegateWillRespond = shouldForwardScrollViewDelegateMethodToExternalDelegate(aSelector) &&
                                        [_externalDelegate respondsToSelector:aSelector];

    if (internalDelegateWillRespond && !externalDelegateWillRespond) {
        return _internalDelegate;
    }

    if (externalDelegateWillRespond && !internalDelegateWillRespond) {
        return _externalDelegate;
    }

    return nil;
}

@end
