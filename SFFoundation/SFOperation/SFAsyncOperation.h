//
//  SFAsyncOperation.h
//  SFFoundation
//
//  Created by vvveiii on 2019/9/3.
//  Copyright © 2019 lvv. All rights reserved.
//

@interface SFAsyncOperation : NSOperation

@property (getter=isExecuting) BOOL executing;
@property (getter=isFinished) BOOL finished;

+ (instancetype)operation;

- (instancetype)initWithPriority:(NSOperationQueuePriority)priority NS_DESIGNATED_INITIALIZER;

- (void)main;

@end
