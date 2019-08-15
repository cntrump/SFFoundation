//
//  SFDispatchQueuePool.m
//  SFFoundation
//
//  Created by vvveiii on 2019/6/26.
//  Copyright © 2019 lvv. All rights reserved.
//

#import "SFDispatchQueuePool.h"
#import "SFDispatchQueue.h"
#import "SFDispatchSemaphore.h"
#import "SFDispatchWorkItem.h"

@interface SFDispatchQueuePool () {
    SFDispatchQueue *_executionQueue;
    SFDispatchQueue *_waitingQueue;
    SFDispatchSemaphore *_maximumQueueSemaphore;
    SFDispatchQueue *_observerQueue;

    SFDispatchSemaphore *_lock;
    NSMutableSet<SFDispatchWorkItem *> *_workItemSet;
}

@end

@implementation SFDispatchQueuePool

- (void)dealloc {
    for (SFDispatchWorkItem *workItem in _workItemSet) {
        [workItem cancel];
    }

    [_workItemSet removeAllObjects];
}

+ (instancetype)pool {
    return [[self alloc] init];
}

- (instancetype)init {
    if (self = [super init]) {
        _executionQueue = [SFDispatchQueue concurrentQueueWithLabel:"queue.exec.SFDispatchQueuePool"];
        _executionQueue.targetQueue = SFDispatchQueue.globalDefaultQueue;

        _waitingQueue = [SFDispatchQueue serialQueueWithLabel:"queue.wait.SFDispatchQueuePool"];
        _maximumQueueSemaphore = [SFDispatchSemaphore semaphoreWithValue:MAX(4, NSProcessInfo.processInfo.processorCount * 2)];
        
        _observerQueue = [SFDispatchQueue concurrentQueueWithLabel:"queue.observer.SFDispatchQueuePool"];
        _observerQueue.targetQueue = SFDispatchQueue.globalDefaultQueue;
        
        _workItemSet = NSMutableSet.set;
        _lock = [SFDispatchSemaphore semaphoreWithValue:1];
    }

    return self;
}

- (void)async:(dispatch_block_t)block {
    __weak typeof(_maximumQueueSemaphore) sema = _maximumQueueSemaphore;
    __weak typeof(_executionQueue) execQueue = _executionQueue;
    __weak typeof(self) wself = self;

    SFDispatchWorkItem *workItem = [SFDispatchWorkItem workItemWithBlock:^{
        [sema wait];


        [execQueue async:^{
            if (block && wself) {
                block();
            }

            [sema signal];
        }];
    }];

    [workItem notifyQueue:_observerQueue block:^{
        [wself didFinishWorkItem:workItem];
    }];

    [self addWorkItem:workItem];

    [_waitingQueue async:workItem.block];
}

- (void)addWorkItem:(SFDispatchWorkItem *)workItem {
    [_lock wait];
    [_workItemSet addObject:workItem];
    [_lock signal];
}

- (void)didFinishWorkItem:(SFDispatchWorkItem *)workItem {
    [_lock wait];
    [_workItemSet removeObject:workItem];
    [_lock signal];
}

@end
