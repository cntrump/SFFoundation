//
//  SFAsyncTransaction.m
//  SFFoundation
//
//  Created by vvveiii on 2019/7/17.
//  Copyright © 2019 lvv. All rights reserved.
//

#import "SFAsyncTransaction.h"
#import "SFRunLoopObserver.h"
#import "SFDispatchQueue.h"

@interface SFAsyncTransactionOperation : NSObject {
    SFAsyncTransactionCompletionBlock _completion;
}

@property(nonatomic, strong) id value;

@end

@implementation SFAsyncTransactionOperation

- (instancetype)initWithCompletion:(SFAsyncTransactionCompletionBlock)completion {
    if (self = [super init]) {
        _completion = [completion copy];
    }

    return self;
}

- (void)finish {
    _completion(self.value);
    _completion = nil;
}

@end

#pragma mark - SFAsyncTransaction

@interface SFAsyncTransaction () <SFRunLoopTransaction> {
    SFDispatchGroup *_group;
    NSMutableArray<SFAsyncTransactionOperation *> *_operations;
}

@end

@implementation SFAsyncTransaction

- (instancetype)init {
    if (self = [super init]) {
        _group = SFDispatchGroup.group;
        _operations = NSMutableArray.array;
    }

    return self;
}

- (void)addOperationWithBlock:(SFAsyncTransactionBlock)block
                        queue:(SFDispatchQueue *)queue
                   completion:(SFAsyncTransactionCompletionBlock)completion {
    if (!block || !queue || !completion) {
        return;
    }

    SFAsyncTransactionOperation *operation = [[SFAsyncTransactionOperation alloc] initWithCompletion:completion];
    [_operations addObject:operation];

    [_group enter];
    [_group asyncQueue:queue block:^{
        operation.value = block();
        [self->_group leave];
    }];

    [SFRunLoopObserver.mainObserver addTransaction:self];
}

- (void)commit {
    if (_operations.count == 0) {
        return;
    }

    NSArray<SFAsyncTransactionOperation *> *operations = _operations.copy;
    [_operations removeAllObjects];

    [_group notifyQueue:SFDispatchQueue.mainQueue block:^{
        for (SFAsyncTransactionOperation *operation in operations) {
            [operation finish];
        }
    }];
}

@end
