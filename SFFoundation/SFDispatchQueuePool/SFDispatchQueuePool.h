//
//  SFDispatchQueuePool.h
//  SFFoundation
//
//  Created by vvveiii on 2019/6/26.
//  Copyright © 2019 lvv. All rights reserved.
//

#import "SFDispatchDefine.h"

@interface SFDispatchQueuePool : NSObject

+ (instancetype)pool;

- (void)async:(dispatch_block_t)block;

@end
