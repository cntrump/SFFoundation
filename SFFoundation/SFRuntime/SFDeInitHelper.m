//
//  SFDeInitHelper.m
//  SFFoundation
//
//  Created by vvveiii on 2019/9/18.
//  Copyright © 2019 lvv. All rights reserved.
//

#import "SFDeInitHelper.h"

@interface SFDeInitHelper : NSObject

@property(nonatomic, copy) void (^deInitBlock)(void);

@end

@implementation SFDeInitHelper

- (void)dealloc {
    if (_deInitBlock) {
        _deInitBlock();
        _deInitBlock = nil;
    }
}

- (instancetype)initWithBlock:(void (^)(void))block {
    if (self = [super init]) {
        _deInitBlock = [block copy];
    }

    return self;
}

@end


@implementation NSObject (SFDeInitHelper)

- (void)sf_addDeInitBlock:(void (^)(void))block {
    SFDeInitHelper *helper = [[SFDeInitHelper alloc] initWithBlock:block];
    NSMutableArray<SFDeInitHelper *> *array = self.sf_deInitArray;
    if (!array) {
        array = NSMutableArray.array;
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
