//
//  SFRuntime.m
//  SFFoundation
//
//  Created by vvveiii on 2019/6/27.
//  Copyright © 2019 lvv. All rights reserved.
//

#import "SFRuntime.h"

SF_EXTERN_C_BEGIN

void sf_swizzleClass(Class cls, SEL originalSelector, SEL swizzledSelector) {
    @autoreleasepool {
        if (!cls || !originalSelector || !swizzledSelector) {
            return;
        }

        Method originalMethod = class_getClassMethod(cls, originalSelector);
        Method swizzledMethod = class_getClassMethod(cls, swizzledSelector);
        if (!originalMethod || !swizzledMethod) {
            return;
        }

        BOOL didAddMethod = class_addMethod(cls,
                                            originalSelector,
                                            method_getImplementation(swizzledMethod),
                                            method_getTypeEncoding(swizzledMethod));

        if (didAddMethod) {
            class_replaceMethod(cls,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    }
}

void sf_swizzleInstance(Class cls, SEL originalSelector, SEL swizzledSelector) {
    @autoreleasepool {
        if (!cls || !originalSelector || !swizzledSelector) {
            return;
        }

        Method originalMethod = class_getInstanceMethod(cls, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(cls, swizzledSelector);
        if (!originalMethod || !swizzledMethod) {
            return;
        }

        BOOL didAddMethod = class_addMethod(cls,
                                            originalSelector,
                                            method_getImplementation(swizzledMethod),
                                            method_getTypeEncoding(swizzledMethod));

        if (didAddMethod) {
            class_replaceMethod(cls,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    }
}

SF_EXTERN_C_END
