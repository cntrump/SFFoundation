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

#endif
