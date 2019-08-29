//
//  SFKeyboardListener.h
//  SFFoundation
//
//  Created by vvveiii on 2019/8/29.
//  Copyright © 2019 lvv. All rights reserved.
//

#if SF_IOS

typedef void (^SFKeyboardListenerBlock)(BOOL isLocal, NSTimeInterval duration, UIViewAnimationCurve curve, CGRect frameBegin, CGRect frameEnd);

@interface SFKeyboardListener : NSObject

@property(nonatomic, readonly) BOOL isObserving;

+ (instancetype)listenerWithBlock:(SFKeyboardListenerBlock)block;

- (void)addKeyboardListener;
- (void)removeKeyboardListener;

@end

#endif
