//
//  SFRuntime.m
//  SFFoundation
//
//  Created by vvveiii on 2019/6/27.
//  Copyright © 2019 lvv. All rights reserved.
//

#import "SFRuntime.h"

@implementation NSObject (SFRuntime)

+ (void)sf_swizzleMethod:(SEL)originalSelector with:(SEL)swizzledSelector {
    sf_swizzleClass(object_getClass(self), originalSelector, swizzledSelector);
}

- (id)sf_getIvarValueWithName:(NSString *)name {
    if (name.length == 0) {
        return nil;
    }

    Ivar ivar = class_getInstanceVariable(object_getClass(self), name.UTF8String);
    if (!ivar) {
        return nil;
    }

    return object_getIvar(self, ivar);
}

@end

SF_EXTERN_C_BEGIN

void sf_swizzleClass(Class class, SEL originalSelector, SEL swizzledSelector) {
    if (!class || !originalSelector || !swizzledSelector) {
        return;
    }

    Method originalMethod = class_getClassMethod(class, originalSelector);
    Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
    if (!originalMethod || !swizzledMethod) {
        return;
    }

    BOOL didAddMethod = class_addMethod(class,
                                        originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));

    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

SF_EXTERN_C_END
