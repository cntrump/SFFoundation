//
//  SFDispatchWorkItem.m
//  SFFoundation
//
//  Created by vvveiii on 2019/6/26.
//  Copyright © 2019 lvv. All rights reserved.
//

#import "SFDispatchWorkItem.h"
#import "SFDispatchQueue.h"

@implementation SFDispatchWorkItem

+ (instancetype)workItemWithBlock:(dispatch_block_t)block {
    return [[self alloc] initWithBlock:block];
}

- (instancetype)initWithBlock:(dispatch_block_t)block {
    if (self = [super init]) {
        _block = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, block);
    }

    return self;
}

- (instancetype)init {
    return [self initWithBlock:nil];
}

- (void)wait {
    [self wait:DISPATCH_TIME_FOREVER];
}

- (void)wait:(dispatch_time_t)timeout {
    dispatch_block_wait(_block, timeout);
}

- (void)cancel {
    dispatch_block_cancel(_block);
}

- (BOOL)testCancel {
    return !!dispatch_block_testcancel(_block);
}

- (void)notifyQueue:(SFDispatchQueue *)queue block:(dispatch_block_t)block {
    dispatch_block_notify(_block, queue.queue, block);
}

@end
