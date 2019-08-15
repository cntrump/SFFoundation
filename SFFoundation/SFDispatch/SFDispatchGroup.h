//
//  SFDispatchGroup.h
//  SFFoundation
//
//  Created by vvveiii on 2019/6/24.
//  Copyright © 2019 lvv. All rights reserved.
//

#import "SFDispatchDefine.h"

@interface SFDispatchGroup : NSObject

+ (instancetype)group;

- (void)enter;
- (void)leave;

- (void)wait;
- (void)wait:(dispatch_time_t)timeout;

- (void)asyncQueue:(SFDispatchQueue *)queue block:(dispatch_block_t)block;
- (void)notifyQueue:(SFDispatchQueue *)queue block:(dispatch_block_t)block;

@end
