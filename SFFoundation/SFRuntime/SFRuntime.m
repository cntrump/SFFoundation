//
//  SFRuntime.m
//  SFFoundation
//
//  Created by vvveiii on 2019/6/27.
//  Copyright © 2019 lvv. All rights reserved.
//

#import "SFRuntime.h"

@implementation NSObject (SFRuntime)

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

void sf_swizzleClass(Class cls, SEL originalSelector, SEL swizzledSelector) {
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

void sf_swizzleInstance(Class cls, SEL originalSelector, SEL swizzledSelector) {
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

SF_EXTERN_C_END


@implementation NSArray (SFSafety)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sf_swizzleInstance(NSClassFromString(@"__NSArrayI"), @selector(objectAtIndex:), @selector(sf_objectAtIndex:));
        sf_swizzleInstance(NSClassFromString(@"__NSArrayI"), @selector(objectAtIndexedSubscript:), @selector(sf_objectAtIndexedSubscript:));

        sf_swizzleInstance(NSClassFromString(@"__NSArrayM"), @selector(objectAtIndex:), @selector(sf_M_objectAtIndex:));
        sf_swizzleInstance(NSClassFromString(@"__NSArrayM"), @selector(objectAtIndexedSubscript:), @selector(sf_M_objectAtIndexedSubscript:));

        sf_swizzleInstance(NSClassFromString(@"__NSFrozenArrayM"), @selector(objectAtIndex:), @selector(sf_FrozenM_objectAtIndex:));
        sf_swizzleInstance(NSClassFromString(@"__NSFrozenArrayM"), @selector(objectAtIndexedSubscript:), @selector(sf_FrozenM_objectAtIndexedSubscript:));
    });
}

- (id)sf_objectAtIndex:(NSUInteger)index {
    NSUInteger count = self.count;
    if (index >= count) {
        return nil;
    }

    return [self sf_objectAtIndex:index];
}

- (id)sf_objectAtIndexedSubscript:(NSUInteger)idx {
    NSUInteger count = self.count;
    if (idx >= count) {
        return nil;
    }

    return [self sf_objectAtIndexedSubscript:idx];
}

- (id)sf_M_objectAtIndex:(NSUInteger)index {
    NSUInteger count = self.count;
    if (index >= count) {
        return nil;
    }

    return [self sf_M_objectAtIndex:index];
}

- (id)sf_M_objectAtIndexedSubscript:(NSUInteger)idx {
    NSUInteger count = self.count;
    if (idx >= count) {
        return nil;
    }
    
    return [self sf_M_objectAtIndexedSubscript:idx];
}

- (id)sf_FrozenM_objectAtIndex:(NSUInteger)index {
    NSUInteger count = self.count;
    if (index >= count) {
        return nil;
    }

    return [self sf_FrozenM_objectAtIndex:index];
}

- (id)sf_FrozenM_objectAtIndexedSubscript:(NSUInteger)idx {
    NSUInteger count = self.count;
    if (idx >= count) {
        return nil;
    }

    return [self sf_FrozenM_objectAtIndexedSubscript:idx];
}

@end


@implementation NSMutableArray (SFSafety)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sf_swizzleInstance(NSClassFromString(@"__NSArrayM"), @selector(insertObject:atIndex:), @selector(sf_M_insertObject:atIndex:));
        sf_swizzleInstance(NSClassFromString(@"__NSArrayM"), @selector(setObject:atIndexedSubscript:), @selector(sf_M_setObject:atIndexedSubscript:));

        sf_swizzleInstance(NSClassFromString(@"__NSFrozenArrayM"), @selector(insertObject:atIndex:), @selector(sf_FrozenM_insertObject:atIndex:));
        sf_swizzleInstance(NSClassFromString(@"__NSFrozenArrayM"), @selector(setObject:atIndexedSubscript:), @selector(sf_FrozenM_setObject:atIndexedSubscript:));
    });
}

- (void)sf_M_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (!anObject) {
        return;
    }

    NSUInteger count = self.count;
    if (index > count) {
        index = count;
    }

    [self sf_M_insertObject:anObject atIndex:index];
}

- (void)sf_M_setObject:(id)obj atIndexedSubscript:(NSUInteger)idx {
    if (!obj) {
        return;
    }

    NSUInteger count = self.count;
    if (idx >= count) {
        return;
    }

    [self sf_M_setObject:obj atIndexedSubscript:idx];
}

- (void)sf_FrozenM_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (!anObject) {
        return;
    }

    NSUInteger count = self.count;
    if (index > count) {
        index = count;
    }

    [self sf_FrozenM_insertObject:anObject atIndex:index];
}

- (void)sf_FrozenM_setObject:(id)obj atIndexedSubscript:(NSUInteger)idx {
    if (!obj) {
        return;
    }

    NSUInteger count = self.count;
    if (idx >= count) {
        return;
    }

    [self sf_FrozenM_setObject:obj atIndexedSubscript:idx];
}

@end


@implementation NSNumber (SFSafety)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sf_swizzleInstance(NSClassFromString(@"__NSCFNumber"), @selector(isEqualToNumber:), @selector(sf_N_isEqualToNumber:));

        sf_swizzleInstance(NSClassFromString(@"__NSCFBoolean"), @selector(isEqualToNumber:), @selector(sf_B_isEqualToNumber:));
    });
}

- (BOOL)sf_N_isEqualToNumber:(NSNumber *)number {
    if (!number) {
        return NO;
    }

    return [self sf_N_isEqualToNumber:number];
}

- (BOOL)sf_B_isEqualToNumber:(NSNumber *)number {
    if (!number) {
        return NO;
    }

    return [self sf_B_isEqualToNumber:number];
}

@end
