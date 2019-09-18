//
//  SFDeInitHelper.m
//  SFFoundation
//
//  Created by vvveiii on 2019/9/18.
//  Copyright © 2019 lvv. All rights reserved.
//

#import "SFDeInitHelper.h"
#import "SFRuntime.h"

@interface SFDeInitHelper : NSObject

@property(nonatomic, copy) void (^deInitBlock)(void);

@end

@implementation SFDeInitHelper

- (void)dealloc {
    [self finishBlock];
}

- (instancetype)initWithBlock:(void (^)(void))block {
    if (self = [super init]) {
        _deInitBlock = [block copy];
    }

    return self;
}

- (void)finishBlock {
    if (_deInitBlock) {
        _deInitBlock();
        _deInitBlock = nil;
    }
}

@end


@implementation NSObject (SFDeInitHelper)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sf_swizzleInstance(self, NSSelectorFromString(@"dealloc"), @selector(sf_dealloc));
    });
}

- (void)sf_dealloc {
    if (self.sf_deInitArray) {
        for (SFDeInitHelper *helper in self.sf_deInitArray) {
            [helper finishBlock];
        }

        self.sf_deInitArray = nil;
    }

    [self sf_dealloc];
}

- (void)sf_addDeInitBlock:(void (^)(void))block {    
    SFDeInitHelper *helper = [[SFDeInitHelper alloc] initWithBlock:block];
    NSMutableArray<SFDeInitHelper *> *array = self.sf_deInitArray;
    if (!array) {
        array = NSMutableArray.array;
        self.sf_deInitArray = array;
    }

    [array addObject:helper];
}

- (void)setSf_deInitArray:(NSMutableArray<SFDeInitHelper *> *)array {
    objc_setAssociatedObject(self, @selector(sf_deInitArray), array, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray<SFDeInitHelper *> *)sf_deInitArray {
    NSMutableArray<SFDeInitHelper *> *array = objc_getAssociatedObject(self, @selector(sf_deInitArray));

    return array;
}

@end
