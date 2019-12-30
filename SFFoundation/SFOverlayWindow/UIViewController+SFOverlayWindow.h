//
//  UIViewController+SFOverlayWindow.h
//  SFFoundation
//
//  Created by vvveiii on 2019/6/17.
//  Copyright © 2019 lvv. All rights reserved.
//
#if SF_IOS

@interface UIViewController (SFOverlayWindow)

@property(nonatomic, assign, readonly) UIStatusBarStyle sf_topPreferredStatusBarStyle;

@property(nonatomic, strong, readonly) UIViewController *sf_topViewController;


- (void)sf_dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion;

@end

@interface UIAlertController (SFExtension)

+ (instancetype)sf_alertStyleWithTitle:(NSString *)title message:(NSString *)message;
+ (instancetype)sf_actionSheetStyleWithTitle:(NSString *)title message:(NSString *)message;

- (void)sf_addDefaultActionWithTitle:(NSString *)title handler:(void (^)(UIAlertAction *action))handler;

- (void)sf_addCancelActionWithTitle:(NSString *)title handler:(void (^)(UIAlertAction *action))handler;

- (void)sf_addDestructiveActionWithTitle:(NSString *)title handler:(void (^)(UIAlertAction *action))handler;

#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0)
- (void)sf_addPreferredActionWithTitle:(NSString *)title handler:(void (^)(UIAlertAction *action))handler;
#endif

@end

#endif
