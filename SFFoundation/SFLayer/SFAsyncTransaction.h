//
//  SFAsyncTransaction.h
//  SFFoundation
//
//  Created by vvveiii on 2019/7/17.
//  Copyright © 2019 lvv. All rights reserved.
//

@class SFDispatchQueue;

typedef id (^SFAsyncTransactionBlock)(void);
typedef void (^SFAsyncTransactionCompletionBlock)(id value);

@interface SFAsyncTransaction : NSObject

- (instancetype)init;

- (void)addOperationWithBlock:(SFAsyncTransactionBlock)block
                        queue:(SFDispatchQueue *)queue
                   completion:(SFAsyncTransactionCompletionBlock)completion;

@end
