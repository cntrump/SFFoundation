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

@implementation NSAttributedString (SFSafety)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sf_swizzleInstance(self, @selector(attribute:atIndex:longestEffectiveRange:inRange:), @selector(sf_attribute:atIndex:longestEffectiveRange:inRange:));
        sf_swizzleInstance(NSClassFromString(@"NSConcreteMutableAttributedString"), @selector(attribute:atIndex:longestEffectiveRange:inRange:), @selector(sf_CM_attribute:atIndex:longestEffectiveRange:inRange:));
        sf_swizzleInstance(NSClassFromString(@"NSConcreteTextStorage"), @selector(attribute:atIndex:longestEffectiveRange:inRange:), @selector(sf_C_attribute:atIndex:longestEffectiveRange:inRange:));
    });
}

- (id)sf_attribute:(NSAttributedStringKey)attrName atIndex:(NSUInteger)location longestEffectiveRange:(NSRangePointer)range inRange:(NSRange)rangeLimit {
    NSUInteger length = self.length;
    if (length == 0 || location > (length - 1) || length < NSMaxRange(rangeLimit)) {
        return nil;
    }

    return [self sf_attribute:attrName atIndex:location longestEffectiveRange:range inRange:rangeLimit];
}

- (id)sf_CM_attribute:(NSAttributedStringKey)attrName atIndex:(NSUInteger)location longestEffectiveRange:(NSRangePointer)range inRange:(NSRange)rangeLimit {
    NSUInteger length = self.length;
    if (length == 0 || location > (length - 1) || length < NSMaxRange(rangeLimit)) {
        return nil;
    }

    return [self sf_CM_attribute:attrName atIndex:location longestEffectiveRange:range inRange:rangeLimit];
}

- (id)sf_C_attribute:(NSAttributedStringKey)attrName atIndex:(NSUInteger)location longestEffectiveRange:(NSRangePointer)range inRange:(NSRange)rangeLimit {
    NSUInteger length = self.length;
    if (length == 0 || location > (length - 1) || length < NSMaxRange(rangeLimit)) {
        return nil;
    }

    return [self sf_C_attribute:attrName atIndex:location longestEffectiveRange:range inRange:rangeLimit];
}

@end

@implementation NSMutableAttributedString (SFSafety)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sf_swizzleInstance(NSClassFromString(@"NSConcreteMutableAttributedString"), @selector(addAttribute:value:range:), @selector(sf_addAttribute:value:range:));
        sf_swizzleInstance(NSClassFromString(@"NSConcreteMutableAttributedString"), @selector(addAttributes:range:), @selector(sf_addAttributes:range:));
        sf_swizzleInstance(NSClassFromString(@"NSConcreteMutableAttributedString"), @selector(removeAttribute:range:), @selector(sf_removeAttribute:range:));

        sf_swizzleInstance(NSClassFromString(@"NSConcreteTextStorage"), @selector(addAttribute:value:range:), @selector(sf_C_addAttribute:value:range:));
        sf_swizzleInstance(NSClassFromString(@"NSConcreteTextStorage"), @selector(addAttributes:range:), @selector(sf_C_addAttributes:range:));
        sf_swizzleInstance(NSClassFromString(@"NSConcreteTextStorage"), @selector(removeAttribute:range:), @selector(sf_C_removeAttribute:range:));
    });
}

- (void)sf_addAttribute:(NSAttributedStringKey)name value:(id)value range:(NSRange)range {
    NSUInteger length = self.length;
    if (!name || length < NSMaxRange(range)) {
        return;
    }

    [self sf_addAttribute:name value:value range:range];
}

- (void)sf_addAttributes:(NSDictionary<NSAttributedStringKey,id> *)attrs range:(NSRange)range {
    NSUInteger length = self.length;
    if (!attrs || length < NSMaxRange(range)) {
        return;
    }

    [self sf_addAttributes:attrs range:range];
}

- (void)sf_removeAttribute:(NSAttributedStringKey)name range:(NSRange)range {
    NSUInteger length = self.length;
    if (!name || length < NSMaxRange(range)) {
        return;
    }

    [self sf_removeAttribute:name range:range];
}

- (void)sf_C_addAttribute:(NSAttributedStringKey)name value:(id)value range:(NSRange)range {
    NSUInteger length = self.length;
    if (!name || length < NSMaxRange(range)) {
        return;
    }

    [self sf_C_addAttribute:name value:value range:range];
}

- (void)sf_C_addAttributes:(NSDictionary<NSAttributedStringKey,id> *)attrs range:(NSRange)range {
    NSUInteger length = self.length;
    if (!attrs || length < NSMaxRange(range)) {
        return;
    }

    [self sf_C_addAttributes:attrs range:range];
}

- (void)sf_C_removeAttribute:(NSAttributedStringKey)name range:(NSRange)range {
    NSUInteger length = self.length;
    if (!name || length < NSMaxRange(range)) {
        return;
    }
    
    [self sf_C_removeAttribute:name range:range];
}

@end

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
        SFAssert(obj, @"object must not be nil.");
        if (!obj) {
            count = i;
            break;
        }
    }

    return [self sf_initWithObjects:objects count:count];
}

- (id)sf_objectAtIndex:(NSUInteger)index {
    NSUInteger count = self.count;
    SFAssert2(index < count, @"index %lu beyond bounds [0 .. %lu].", index, count);
    if (index >= count) {
        return nil;
    }

    return [self sf_objectAtIndex:index];
}

- (id)sf_objectAtIndexedSubscript:(NSUInteger)idx {
    NSUInteger count = self.count;
    SFAssert2(idx < count, @"index %lu beyond bounds [0 .. %lu].", idx, count);
    if (idx >= count) {
        return nil;
    }

    return [self sf_objectAtIndexedSubscript:idx];
}

- (id)sf_S_objectAtIndex:(NSUInteger)index {
    NSUInteger count = self.count;
    SFAssert2(index < count, @"index %lu beyond bounds [0 .. %lu].", index, count);
    if (index >= count) {
        return nil;
    }

    return [self sf_S_objectAtIndex:index];
}

- (id)sf_S_objectAtIndexedSubscript:(NSUInteger)idx {
    NSUInteger count = self.count;
    SFAssert2(idx < count, @"index %lu beyond bounds [0 .. %lu].", idx, count);
    if (idx >= count) {
        return nil;
    }

    return [self sf_S_objectAtIndexedSubscript:idx];
}

- (id)sf_M_objectAtIndex:(NSUInteger)index {
    NSUInteger count = self.count;
    SFAssert2(index < count, @"index %lu beyond bounds [0 .. %lu].", index, count);
    if (index >= count) {
        return nil;
    }

    return [self sf_M_objectAtIndex:index];
}

- (id)sf_M_objectAtIndexedSubscript:(NSUInteger)idx {
    NSUInteger count = self.count;
    SFAssert2(idx < count, @"index %lu beyond bounds [0 .. %lu].", idx, count);
    if (idx >= count) {
        return nil;
    }
    
    return [self sf_M_objectAtIndexedSubscript:idx];
}

- (id)sf_FrozenM_objectAtIndex:(NSUInteger)index {
    NSUInteger count = self.count;
    SFAssert2(index < count, @"index %lu beyond bounds [0 .. %lu].", index, count);
    if (index >= count) {
        return nil;
    }

    return [self sf_FrozenM_objectAtIndex:index];
}

- (id)sf_FrozenM_objectAtIndexedSubscript:(NSUInteger)idx {
    NSUInteger count = self.count;
    SFAssert2(idx < count, @"index %lu beyond bounds [0 .. %lu].", idx, count);
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
        sf_swizzleInstance(NSClassFromString(@"__NSArrayM"), @selector(removeObjectAtIndex:), @selector(sf_M_removeObjectAtIndex:));

        sf_swizzleInstance(NSClassFromString(@"__NSFrozenArrayM"), @selector(insertObject:atIndex:), @selector(sf_FrozenM_insertObject:atIndex:));
        sf_swizzleInstance(NSClassFromString(@"__NSFrozenArrayM"), @selector(setObject:atIndexedSubscript:), @selector(sf_FrozenM_setObject:atIndexedSubscript:));
        sf_swizzleInstance(NSClassFromString(@"__NSFrozenArrayM"), @selector(removeObjectAtIndex:), @selector(sf_FrozenM_removeObjectAtIndex:));
    });
}

- (void)sf_M_insertObject:(id)anObject atIndex:(NSUInteger)index {
    SFAssert(anObject, @"object must not be nil.");
    if (!anObject) {
        return;
    }

    NSUInteger count = self.count;
    SFAssert2(index <= count, @"index %lu beyond bounds [0 .. %lu].", index, count);
    if (index > count) {
        return;
    }

    [self sf_M_insertObject:anObject atIndex:index];
}

- (void)sf_M_setObject:(id)obj atIndexedSubscript:(NSUInteger)idx {
    SFAssert(obj, @"object must not be nil.");
    if (!obj) {
        return;
    }

    NSUInteger count = self.count;
    SFAssert2(idx <= count, @"index %lu beyond bounds [0 .. %lu].", idx, count);
    if (idx > count) {
        return;
    }

    [self sf_M_setObject:obj atIndexedSubscript:idx];
}

- (void)sf_M_removeObjectAtIndex:(NSUInteger)index {
    NSUInteger count = self.count;
    SFAssert2(index < count, @"index %lu beyond bounds [0 .. %lu].", index, count);
    if (index >= count) {
        return;
    }

    [self sf_M_removeObjectAtIndex:index];
}

- (void)sf_FrozenM_insertObject:(id)anObject atIndex:(NSUInteger)index {
    SFAssert(anObject, @"object must not be nil.");
    if (!anObject) {
        return;
    }

    NSUInteger count = self.count;
    SFAssert2(index <= count, @"index %lu beyond bounds [0 .. %lu].", index, count);
    if (index > count) {
        return;
    }

    [self sf_FrozenM_insertObject:anObject atIndex:index];
}

- (void)sf_FrozenM_setObject:(id)obj atIndexedSubscript:(NSUInteger)idx {
    SFAssert(obj, @"object must not be nil.");
    if (!obj) {
        return;
    }

    NSUInteger count = self.count;
    SFAssert2(idx <= count, @"index %lu beyond bounds [0 .. %lu].", idx, count);
    if (idx > count) {
        return;
    }

    [self sf_FrozenM_setObject:obj atIndexedSubscript:idx];
}

- (void)sf_FrozenM_removeObjectAtIndex:(NSUInteger)index {
    NSUInteger count = self.count;
    SFAssert2(index < count, @"index %lu beyond bounds [0 .. %lu].", index, count);
    if (index >= count) {
        return;
    }

    [self sf_FrozenM_removeObjectAtIndex:index];
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
        SFAssert(key && obj, @"key and obj must be paired.");
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
        sf_swizzleInstance(NSClassFromString(@"__NSDictionaryM"), @selector(removeObjectForKey:), @selector(sf_removeObjectForKey:));
    });
}

- (void)sf_setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key {
    SFAssert(key, @"key must not be nil.");
    if (!key) {
        return;
    }

    [self sf_setObject:obj forKeyedSubscript:key];
}

- (void)sf_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    SFAssert(aKey, @"key must not be nil.");
    if (!aKey) {
        return;
    }

    [self sf_setObject:anObject forKey:aKey];
}

- (void)sf_removeObjectForKey:(id)aKey {
    SFAssert(aKey, @"key must not be nil.");
    if (!aKey) {
        return;
    }

    [self sf_removeObjectForKey:aKey];
}

@end

#if SF_IOS
@implementation UIViewController (SFRuntime)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sf_swizzleInstance(self, @selector(viewWillLayoutSubviews), @selector(sf_viewWillLayoutSubviews));
        sf_swizzleInstance(self, @selector(viewDidLayoutSubviews), @selector(sf_viewDidLayoutSubviews));
        sf_swizzleInstance(self, @selector(traitCollectionDidChange:), @selector(sf_traitCollectionDidChange:));
    });
}

- (void)setSf_viewWillLayoutSubviewsBlock:(void (^)())block {
    objc_setAssociatedObject(self, @selector(sf_viewWillLayoutSubviewsBlock), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)())sf_viewWillLayoutSubviewsBlock {
    return objc_getAssociatedObject(self, @selector(sf_viewWillLayoutSubviewsBlock));
}

- (void)setSf_viewDidLayoutSubviewsBlock:(void (^)())block {
    objc_setAssociatedObject(self, @selector(sf_viewDidLayoutSubviewsBlock), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)())sf_viewDidLayoutSubviewsBlock {
    return objc_getAssociatedObject(self, @selector(sf_viewDidLayoutSubviewsBlock));
}

- (void)sf_viewWillLayoutSubviews {
    [self sf_viewWillLayoutSubviews];

    if (self.sf_viewWillLayoutSubviewsBlock) {
        self.sf_viewWillLayoutSubviewsBlock();
    }
}

- (void)sf_viewDidLayoutSubviews {
    [self sf_viewDidLayoutSubviews];

    if (self.sf_viewDidLayoutSubviewsBlock) {
        self.sf_viewDidLayoutSubviewsBlock();
    }
}

- (void)sf_traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [self sf_traitCollectionDidChange:previousTraitCollection];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0
    if (@available(iOS 13.0, *)) {
        if ([self.traitCollection hasDifferentColorAppearanceComparedToTraitCollection:previousTraitCollection]) {

        }
    }
#endif
}

@end

@implementation UIPresentationController (SFRuntime)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sf_swizzleInstance(self, @selector(containerViewWillLayoutSubviews), @selector(sf_containerViewWillLayoutSubviews));
        sf_swizzleInstance(self, @selector(containerViewDidLayoutSubviews), @selector(sf_containerViewDidLayoutSubviews));
        sf_swizzleInstance(self, @selector(traitCollectionDidChange:), @selector(sf_traitCollectionDidChange:));
    });
}

- (void)setSf_containerViewWillLayoutSubviewsBlock:(void (^)())block {
    objc_setAssociatedObject(self, @selector(sf_containerViewWillLayoutSubviewsBlock), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)())sf_containerViewWillLayoutSubviewsBlock {
    return objc_getAssociatedObject(self, @selector(sf_containerViewWillLayoutSubviewsBlock));
}

- (void)setSf_containerViewDidLayoutSubviewsBlock:(void (^)())block {
    objc_setAssociatedObject(self, @selector(sf_containerViewDidLayoutSubviewsBlock), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)())sf_containerViewDidLayoutSubviewsBlock {
    return objc_getAssociatedObject(self, @selector(sf_containerViewDidLayoutSubviewsBlock));
}

- (void)sf_containerViewWillLayoutSubviews {
    [self sf_containerViewWillLayoutSubviews];

    if (self.sf_containerViewWillLayoutSubviewsBlock) {
        self.sf_containerViewWillLayoutSubviewsBlock();
    }
}

- (void)sf_containerViewDidLayoutSubviews {
    [self sf_containerViewDidLayoutSubviews];

    if (self.sf_containerViewDidLayoutSubviewsBlock) {
        self.sf_containerViewDidLayoutSubviewsBlock();
    }
}

- (void)sf_traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [self sf_traitCollectionDidChange:previousTraitCollection];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0
    if (@available(iOS 13.0, *)) {
        if ([self.traitCollection hasDifferentColorAppearanceComparedToTraitCollection:previousTraitCollection]) {

        }
    }
#endif
}

@end

@implementation UIView (SFRuntime)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sf_swizzleInstance(self, @selector(drawRect:), @selector(sf_drawRect:));
        sf_swizzleInstance(self, @selector(layoutSubviews), @selector(sf_layoutSubviews));
        sf_swizzleInstance(self, @selector(traitCollectionDidChange:), @selector(sf_traitCollectionDidChange:));
        sf_swizzleInstance(self, @selector(tintColorDidChange), @selector(sf_tintColorDidChange));
    });
}

- (void)setSf_drawRectBlock:(void (^)(CGRect))block {
    objc_setAssociatedObject(self, @selector(sf_drawRectBlock), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(CGRect))sf_drawRectBlock {
    return objc_getAssociatedObject(self, @selector(sf_drawRectBlock));
}

- (void)setSf_layoutSubviewsBlock:(void (^)())block {
    objc_setAssociatedObject(self, @selector(sf_layoutSubviewsBlock), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)())sf_layoutSubviewsBlock {
    return objc_getAssociatedObject(self, @selector(sf_layoutSubviewsBlock));
}

- (void)setSf_tintColorDidChangeBlock:(void (^)())block {
    objc_setAssociatedObject(self, @selector(sf_tintColorDidChangeBlock), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)())sf_tintColorDidChangeBlock {
    return objc_getAssociatedObject(self, @selector(sf_tintColorDidChangeBlock));
}

- (void)sf_drawRect:(CGRect)rect {
    [self sf_drawRect:rect];

    if (self.sf_drawRectBlock) {
        self.sf_drawRectBlock(rect);
    }
}

- (void)sf_layoutSubviews {
    [self sf_layoutSubviews];

    if (self.sf_layoutSubviewsBlock) {
        self.sf_layoutSubviewsBlock();
    }
}

- (void)sf_traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [self sf_traitCollectionDidChange:previousTraitCollection];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0
    if (@available(iOS 13.0, *)) {
        if ([self.traitCollection hasDifferentColorAppearanceComparedToTraitCollection:previousTraitCollection]) {

        }
    }
#endif
}

- (void)sf_tintColorDidChange {
    [self sf_tintColorDidChange];

    if (self.sf_tintColorDidChangeBlock) {
        self.sf_tintColorDidChangeBlock();
    }
}

@end
#endif
