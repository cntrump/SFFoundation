//
//  SFNotificationObserver.h
//  SFFoundation
//
//  Created by vvveiii on 2019/6/25.
//  Copyright © 2019 lvv. All rights reserved.
//

typedef void (^SFNotificationObserverBlock)(NSNotification *notification);

@interface SFNotificationObserver : NSObject

+ (instancetype)observer;

- (instancetype)init;

- (void)addNotificationWithName:(NSString *)name block:(SFNotificationObserverBlock)block;
- (void)removeNotificationWithName:(NSString *)name;

@end
