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
    @autoreleasepool {
        NSUInteger length = self.length;
        if (length == 0 || location > (length - 1) || length < NSMaxRange(rangeLimit)) {
            return nil;
        }

        return [self sf_attribute:attrName atIndex:location longestEffectiveRange:range inRange:rangeLimit];
    }
}

- (id)sf_CM_attribute:(NSAttributedStringKey)attrName atIndex:(NSUInteger)location longestEffectiveRange:(NSRangePointer)range inRange:(NSRange)rangeLimit {
    @autoreleasepool {
        NSUInteger length = self.length;
        if (length == 0 || location > (length - 1) || length < NSMaxRange(rangeLimit)) {
            return nil;
        }

        return [self sf_CM_attribute:attrName atIndex:location longestEffectiveRange:range inRange:rangeLimit];
    }
}

- (id)sf_C_attribute:(NSAttributedStringKey)attrName atIndex:(NSUInteger)location longestEffectiveRange:(NSRangePointer)range inRange:(NSRange)rangeLimit {
    @autoreleasepool {
        NSUInteger length = self.length;
        if (length == 0 || location > (length - 1) || length < NSMaxRange(rangeLimit)) {
            return nil;
        }

        return [self sf_C_attribute:attrName atIndex:location longestEffectiveRange:range inRange:rangeLimit];
    }
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
    @autoreleasepool {
        NSUInteger length = self.length;
        if (!name || length < NSMaxRange(range)) {
            return;
        }

        [self sf_addAttribute:name value:value range:range];
    }
}

- (void)sf_addAttributes:(NSDictionary<NSAttributedStringKey,id> *)attrs range:(NSRange)range {
    @autoreleasepool {
        NSUInteger length = self.length;
        if (!attrs || length < NSMaxRange(range)) {
            return;
        }

        [self sf_addAttributes:attrs range:range];
    }
}

- (void)sf_removeAttribute:(NSAttributedStringKey)name range:(NSRange)range {
    @autoreleasepool {
        NSUInteger length = self.length;
        if (!name || length < NSMaxRange(range)) {
            return;
        }

        [self sf_removeAttribute:name range:range];
    }
}

- (void)sf_C_addAttribute:(NSAttributedStringKey)name value:(id)value range:(NSRange)range {
    @autoreleasepool {
        NSUInteger length = self.length;
        if (!name || length < NSMaxRange(range)) {
            return;
        }

        [self sf_C_addAttribute:name value:value range:range];
    }
}

- (void)sf_C_addAttributes:(NSDictionary<NSAttributedStringKey,id> *)attrs range:(NSRange)range {
    @autoreleasepool {
        NSUInteger length = self.length;
        if (!attrs || length < NSMaxRange(range)) {
            return;
        }

        [self sf_C_addAttributes:attrs range:range];
    }
}

- (void)sf_C_removeAttribute:(NSAttributedStringKey)name range:(NSRange)range {
    @autoreleasepool {
        NSUInteger length = self.length;
        if (!name || length < NSMaxRange(range)) {
            return;
        }

        [self sf_C_removeAttribute:name range:range];
    }
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
    @autoreleasepool {
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
}

- (id)sf_objectAtIndex:(NSUInteger)index {
    @autoreleasepool {
        NSUInteger count = self.count;
        SFAssert2(index < count, @"index %lu beyond bounds [0 .. %lu].", index, count);
        if (index >= count) {
            return nil;
        }

        return [self sf_objectAtIndex:index];
    }
}

- (id)sf_objectAtIndexedSubscript:(NSUInteger)idx {
    @autoreleasepool {
        NSUInteger count = self.count;
        SFAssert2(idx < count, @"index %lu beyond bounds [0 .. %lu].", idx, count);
        if (idx >= count) {
            return nil;
        }

        return [self sf_objectAtIndexedSubscript:idx];
    }
}

- (id)sf_S_objectAtIndex:(NSUInteger)index {
    @autoreleasepool {
        NSUInteger count = self.count;
        SFAssert2(index < count, @"index %lu beyond bounds [0 .. %lu].", index, count);
        if (index >= count) {
            return nil;
        }

        return [self sf_S_objectAtIndex:index];
    }
}

- (id)sf_S_objectAtIndexedSubscript:(NSUInteger)idx {
    @autoreleasepool {
        NSUInteger count = self.count;
        SFAssert2(idx < count, @"index %lu beyond bounds [0 .. %lu].", idx, count);
        if (idx >= count) {
            return nil;
        }

        return [self sf_S_objectAtIndexedSubscript:idx];
    }
}

- (id)sf_M_objectAtIndex:(NSUInteger)index {
    @autoreleasepool {
        NSUInteger count = self.count;
        SFAssert2(index < count, @"index %lu beyond bounds [0 .. %lu].", index, count);
        if (index >= count) {
            return nil;
        }

        return [self sf_M_objectAtIndex:index];
    }
}

- (id)sf_M_objectAtIndexedSubscript:(NSUInteger)idx {
    @autoreleasepool {
        NSUInteger count = self.count;
        SFAssert2(idx < count, @"index %lu beyond bounds [0 .. %lu].", idx, count);
        if (idx >= count) {
            return nil;
        }

        return [self sf_M_objectAtIndexedSubscript:idx];
    }
}

- (id)sf_FrozenM_objectAtIndex:(NSUInteger)index {
    @autoreleasepool {
        NSUInteger count = self.count;
        SFAssert2(index < count, @"index %lu beyond bounds [0 .. %lu].", index, count);
        if (index >= count) {
            return nil;
        }

        return [self sf_FrozenM_objectAtIndex:index];
    }
}

- (id)sf_FrozenM_objectAtIndexedSubscript:(NSUInteger)idx {
    @autoreleasepool {
        NSUInteger count = self.count;
        SFAssert2(idx < count, @"index %lu beyond bounds [0 .. %lu].", idx, count);
        if (idx >= count) {
            return nil;
        }

        return [self sf_FrozenM_objectAtIndexedSubscript:idx];
    }
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
    @autoreleasepool {
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
}

- (void)sf_M_setObject:(id)obj atIndexedSubscript:(NSUInteger)idx {
    @autoreleasepool {
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
}

- (void)sf_M_removeObjectAtIndex:(NSUInteger)index {
    @autoreleasepool {
        NSUInteger count = self.count;
        SFAssert2(index < count, @"index %lu beyond bounds [0 .. %lu].", index, count);
        if (index >= count) {
            return;
        }

        [self sf_M_removeObjectAtIndex:index];
    }
}

- (void)sf_FrozenM_insertObject:(id)anObject atIndex:(NSUInteger)index {
    @autoreleasepool {
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
}

- (void)sf_FrozenM_setObject:(id)obj atIndexedSubscript:(NSUInteger)idx {
    @autoreleasepool {
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
}

- (void)sf_FrozenM_removeObjectAtIndex:(NSUInteger)index {
    @autoreleasepool {
        NSUInteger count = self.count;
        SFAssert2(index < count, @"index %lu beyond bounds [0 .. %lu].", index, count);
        if (index >= count) {
            return;
        }

        [self sf_FrozenM_removeObjectAtIndex:index];
    }
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
    @autoreleasepool {
        if (!number) {
            return NO;
        }

        return [self sf_N_isEqualToNumber:number];
    }
}

- (BOOL)sf_B_isEqualToNumber:(NSNumber *)number {
    @autoreleasepool {
        if (!number) {
            return NO;
        }

        return [self sf_B_isEqualToNumber:number];
    }
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
    @autoreleasepool {
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
    @autoreleasepool {
        SFAssert(key, @"key must not be nil.");
        if (!key) {
            return;
        }

        [self sf_setObject:obj forKeyedSubscript:key];
    }
}

- (void)sf_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    @autoreleasepool {
        SFAssert(aKey, @"key must not be nil.");
        if (!aKey) {
            return;
        }

        [self sf_setObject:anObject forKey:aKey];
    }
}

- (void)sf_removeObjectForKey:(id)aKey {
    @autoreleasepool {
        SFAssert(aKey, @"key must not be nil.");
        if (!aKey) {
            return;
        }

        [self sf_removeObjectForKey:aKey];
    }
}

@end
