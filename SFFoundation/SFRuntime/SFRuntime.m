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
    if (!originalSelector || !swizzledSelector) {
        return;
    }

    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);

    if (class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
        class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (id)sf_getIvarValueWithName:(NSString *)name {
    if (name.length == 0) {
        return nil;
    }

    Ivar ivar = class_getInstanceVariable(self.class, name.UTF8String);
    if (!ivar) {
        return nil;
    }

    return object_getIvar(self, ivar);
}

@end
