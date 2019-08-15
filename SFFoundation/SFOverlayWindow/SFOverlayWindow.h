//
//  SFOverlayWindow.h
//  SFFoundation
//
//  Created by vvveiii on 2019/6/17.
//  Copyright © 2019 lvv. All rights reserved.
//
#if SF_IOS

@interface SFOverlayWindow : UIWindow

+ (instancetype)window;

@property(class, nonatomic, readonly) UIWindow *mainWindow;

- (void)show;

- (void)destory;

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion;

@end


@interface UIWindow (SFOverlayWindow)

- (void)sf_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion;

@end

#endif
