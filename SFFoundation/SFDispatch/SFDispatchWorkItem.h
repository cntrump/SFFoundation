//
//  SFDispatchWorkItem.h
//  SFFoundation
//
//  Created by vvveiii on 2019/6/26.
//  Copyright © 2019 lvv. All rights reserved.
//

#import "SFDispatchDefine.h"

@interface SFDispatchWorkItem : NSObject

@property(nonatomic, readonly) dispatch_block_t block;

+ (instancetype)workItemWithBlock:(dispatch_block_t)block;

- (instancetype)initWithBlock:(dispatch_block_t)block;

- (void)wait;
- (void)wait:(dispatch_time_t)timeout;

- (void)cancel;
- (BOOL)testCancel;

- (void)notifyQueue:(SFDispatchQueue *)queue block:(dispatch_block_t)block;

@end
