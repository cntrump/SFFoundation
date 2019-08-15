//
//  SFDispatchSemaphore.m
//  SFFoundation
//
//  Created by vvveiii on 2019/6/26.
//  Copyright © 2019 lvv. All rights reserved.
//

#import "SFDispatchSemaphore.h"

@interface SFDispatchSemaphore () {
    dispatch_semaphore_t _dsema;
}

@end

@implementation SFDispatchSemaphore

+ (instancetype)semaphoreWithValue:(long)value {
    return [[self alloc] initWithValue:value];
}

- (instancetype)initWithValue:(long)value {
    if (self = [super init]) {
        _dsema = dispatch_semaphore_create(value);
    }

    return self;
}

- (instancetype)init {
    return [self initWithValue:0];
}

- (void)wait {
    [self wait:DISPATCH_TIME_FOREVER];
}

- (void)signal {
    dispatch_semaphore_signal(_dsema);
}

- (void)wait:(dispatch_time_t)timeout {
    dispatch_semaphore_wait(_dsema, timeout);
}

@end
