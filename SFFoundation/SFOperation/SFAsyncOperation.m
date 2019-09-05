//
//  SFAsyncOperation.m
//  SFFoundation
//
//  Created by vvveiii on 2019/9/3.
//  Copyright © 2019 lvv. All rights reserved.
//

#import "SFAsyncOperation.h"
#import <mutex>

@interface SFAsyncOperation () {
    BOOL _executing;
    BOOL _finished;
    BOOL _asynchronous;
    std::mutex _mutex;
    std::mutex _statusMutex;
}

@property (getter=isAsynchronous) BOOL asynchronous API_AVAILABLE(macos(10.8), ios(7.0), watchos(2.0), tvos(9.0));

@end

@implementation SFAsyncOperation

+ (instancetype)operation {
    return [[self alloc] init];
}

- (instancetype)initWithPriority:(NSOperationQueuePriority)priority {
    if (self = [super init]) {
        self.queuePriority = priority;
        self.asynchronous = YES;
    }

    return self;
}

- (instancetype)init {
    return [self initWithPriority:NSOperationQueuePriorityNormal];
}

- (void)start {
    _mutex.lock();

    if (self.isExecuting || self.isCancelled || self.isFinished) {
        _mutex.unlock();
        return;
    }

    self.executing = YES;
    [self main];

    _mutex.unlock();
}

- (void)main {
}

- (void)setAsynchronous:(BOOL)asynchronous {
    _statusMutex.lock();

    [self willChangeValueForKey:@"isAsynchronous"];
    _asynchronous = asynchronous;
    [self didChangeValueForKey:@"isAsynchronous"];

    _statusMutex.unlock();
}

- (void)setExecuting:(BOOL)executing {
    _statusMutex.lock();

    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];

    _statusMutex.unlock();
}

- (void)setFinished:(BOOL)finished {
    _statusMutex.lock();

    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];

    _statusMutex.unlock();
}

- (BOOL)isExecuting {
    return _executing;
}

- (BOOL)isFinished {
    return _finished;
}

- (BOOL)isAsynchronous {
    return _asynchronous;
}

@end
