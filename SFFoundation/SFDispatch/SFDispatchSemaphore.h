//
//  SFDispatchSemaphore.h
//  SFFoundation
//
//  Created by vvveiii on 2019/6/26.
//  Copyright © 2019 lvv. All rights reserved.
//

#import "SFDispatchDefine.h"

@interface SFDispatchSemaphore : NSObject

+ (instancetype)semaphoreWithValue:(long)value;

- (instancetype)initWithValue:(long)value;

- (void)wait;
- (void)wait:(dispatch_time_t)timeout;
- (void)signal;

@end
