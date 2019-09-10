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
        sf_swizzleInstance(NSClassFromString(@"__NSPlaceholderArray"), @selector(initWithObjects:count:), @selector(sf_initWithObjects:count:));

        sf_swizzleInstance(NSClassFromString(@"__NSArrayI"), @selector(objectAtIndex:), @selector(sf_objectAtIndex:));
        sf_swizzleInstance(NSClassFromString(@"__NSArrayI"), @selector(objectAtIndexedSubscript:), @selector(sf_objectAtIndexedSubscript:));

        sf_swizzleInstance(NSClassFromString(@"__NSSingleObjectArrayI"), @selector(objectAtIndex:), @selector(sf_S_objectAtIndex:));
        sf_swizzleInstance(NSClassFromString(@"__NSSingleObjectArrayI"), @selector(objectAtIndexedSubscript:), @selector(sf_S_objectAtIndexedSubscript:));

        sf_swizzleInstance(NSClassFromString(@"__NSArrayM"), @selector(objectAtIndex:), @selector(sf_M_objectAtIndex:));
        sf_swizzleInstance(NSClassFromString(@"__NSArrayM"), @selector(objectAtIndexedSubscript:), @selector(sf_M_objectAtIndexedSubscript:));

        sf_swizzleInstance(NSClassFromString(@"__NSFrozenArrayM"), @selector(objectAtIndex:), @selector(sf_FrozenM_objectAtIndex:));
        sf_swizzleInstance(NSClassFromString(@"__NSFrozenArrayM"), @selector(objectAtIndexedSubscript:), @selector(sf_FrozenM_objectAtIndexedSubscript:));
    });
}

- (instancetype)sf_initWithObjects:(id  _Nonnull const [])objects count:(NSUInteger)cnt {
    NSUInteger count = cnt;
    for (NSUInteger i = 0; i < cnt; i++) {
        id obj = objects[i];
        if (!obj) {
            count = i;
            break;
        }
    }

    return [self sf_initWithObjects:objects count:count];
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

- (id)sf_S_objectAtIndex:(NSUInteger)index {
    NSUInteger count = self.count;
    if (index >= count) {
        return nil;
    }

    return [self sf_S_objectAtIndex:index];
}

- (id)sf_S_objectAtIndexedSubscript:(NSUInteger)idx {
    NSUInteger count = self.count;
    if (idx >= count) {
        return nil;
    }

    return [self sf_S_objectAtIndexedSubscript:idx];
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


@implementation NSDictionary (SFSafety)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sf_swizzleInstance(NSClassFromString(@"__NSPlaceholderDictionary"), @selector(initWithObjects:forKeys:count:), @selector(sf_initWithObjects:forKeys:count:));
    });
}

- (instancetype)sf_initWithObjects:(id  _Nonnull const [])objects forKeys:(id<NSCopying>  _Nonnull const [])keys count:(NSUInteger)cnt {
    NSUInteger count = cnt;
    for (NSUInteger i = 0; i < cnt; i++) {
        id obj = objects[i];
        id key = keys[i];
        if (!obj || !key) {
            count = i;
            break;
        }
    }

    return [self sf_initWithObjects:objects forKeys:keys count:count];
}

@end

@implementation NSMutableDictionary (SFSafety)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sf_swizzleInstance(NSClassFromString(@"__NSDictionaryM"), @selector(setObject:forKeyedSubscript:), @selector(sf_setObject:forKeyedSubscript:));
        sf_swizzleInstance(NSClassFromString(@"__NSDictionaryM"), @selector(setObject:forKey:), @selector(sf_setObject:forKey:));
    });
}

- (void)sf_setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key {
    if (!key) {
        return;
    }

    [self sf_setObject:obj forKeyedSubscript:key];
}

- (void)sf_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (!aKey) {
        return;
    }

    [self sf_setObject:anObject forKey:aKey];
}

@end

#if SF_IOS
@implementation UINavigationController (SFSafety)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sf_swizzleInstance(self, @selector(pushViewController:animated:), @selector(sf_fix_pushViewController:animated:));
        sf_swizzleInstance(self, @selector(popViewControllerAnimated:), @selector(sf_fix_popViewControllerAnimated:));
    });
}

- (BOOL)sf_fix_isAnimating {
    return [objc_getAssociatedObject(self, @selector(sf_fix_isAnimating)) boolValue];
}

- (void)setSf_fix_isAnimating:(BOOL)animating {
    objc_setAssociatedObject(self, @selector(sf_fix_isAnimating), @(animating), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)sf_fix_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.sf_fix_isAnimating) {
        return;
    }

    self.sf_fix_isAnimating = YES;
    [self sf_fix_pushViewController:viewController animated:animated];

    dispatch_block_t completionBlock = ^{
        self.sf_fix_isAnimating = NO;
    };

    if (animated) {
        CATransaction.completionBlock = completionBlock;
    } else {
        completionBlock();
    }
}

- (UIViewController *)sf_fix_popViewControllerAnimated:(BOOL)animated {
    if (self.sf_fix_isAnimating) {
        return nil;
    }

    self.sf_fix_isAnimating = YES;
    UIViewController *vc = [self sf_fix_popViewControllerAnimated:animated];

    dispatch_block_t completionBlock = ^{
        self.sf_fix_isAnimating = NO;
    };

    if (animated) {
        CATransaction.completionBlock = completionBlock;
    } else {
        completionBlock();
    }

    return vc;
}

@end
#endif
