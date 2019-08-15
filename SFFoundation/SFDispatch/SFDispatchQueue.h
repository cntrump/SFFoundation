//
//  SFDispatchQueue.h
//  SFFoundation
//
//  Created by vvveiii on 2019/6/24.
//  Copyright © 2019 lvv. All rights reserved.
//

#import "SFDispatchDefine.h"
#import "SFDispatchGroup.h"

@interface SFDispatchQueue : NSObject

@property(nonatomic, readonly) const char *label;
@property(nonatomic, readonly) dispatch_queue_t queue;
@property(nonatomic, strong) SFDispatchQueue *targetQueue;

+ (instancetype)queueWithLabel:(const char *)label attr:(dispatch_queue_attr_t)attr;
+ (instancetype)mainQueue;
+ (instancetype)globalQueueWithPriority:(SFDispatchQueuePriority)priority;

+ (instancetype)queueWithQueue:(dispatch_queue_t)queue;

- (void)async:(dispatch_block_t)block;
- (void)sync:(dispatch_block_t)block;

- (void)barrierAsync:(dispatch_block_t)block;
- (void)barrierSync:(dispatch_block_t)block;

- (void)after:(dispatch_time_t)when block:(dispatch_block_t)block;

- (void)setSpecific:(void *)specific forKey:(const void *)key;
- (void *)specificForKey:(const void *)key;

@end


@interface SFDispatchQueue (SFDispatchQueueEx)

+ (instancetype)serialQueueWithLabel:(const char *)label;
+ (instancetype)concurrentQueueWithLabel:(const char *)label;

+ (instancetype)globalDefaultQueue;
+ (instancetype)globalBackgroundQueue;
+ (instancetype)globalLowQueue;
+ (instancetype)globalHighQueue;

@end
