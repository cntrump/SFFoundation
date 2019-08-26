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
    sf_swizzle(self, originalSelector, self, swizzledSelector);
}

+ (void)sf_swizzleMethod:(SEL)originalSelector originalClass:(Class)cls with:(SEL)swizzledSelector {
    sf_swizzle(cls, originalSelector, self, swizzledSelector);
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

SF_EXTERN_C_BEGIN

void sf_swizzle(Class cls, SEL originalSel, Class newClass, SEL newSel) {
    if (!originalSel || !newSel) {
        return;
    }

    Method originalMethod = class_getInstanceMethod(cls, originalSel);
    Method swizzledMethod = class_getInstanceMethod(newClass, newSel);

    if (class_addMethod(cls, originalSel, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
        class_replaceMethod(cls, newSel, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

SF_EXTERN_C_END
