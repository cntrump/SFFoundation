//
//  SFRunLoopObserver.h
//  SFFoundation
//
//  Created by vvveiii on 2019/7/16.
//  Copyright © 2019 lvv. All rights reserved.
//

@protocol SFRunLoopTransaction <NSObject>

- (void)commit;

@end

@interface SFRunLoopObserver : NSObject

+ (instancetype)mainObserver;

- (void)addTransaction:(id<SFRunLoopTransaction>)transaction;

@end
