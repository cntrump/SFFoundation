//
//  UIViewController+SFOverlayWindow.m
//  SFFoundation
//
//  Created by vvveiii on 2019/6/17.
//  Copyright © 2019 lvv. All rights reserved.
//
#if SF_IOS

#import "UIViewController+SFOverlayWindow.h"

@implementation UIViewController (SFOverlayWindow)

- (UIStatusBarStyle)sf_topPreferredStatusBarStyle {
    return self.sf_topViewController.preferredStatusBarStyle;
}

- (UIViewController *)sf_topViewController {
    if ([self isKindOfClass:UINavigationController.class]) {
        UINavigationController *nav = (UINavigationController *)self;
        if (nav.childViewControllers.count > 0) {
            return nav.topViewController.sf_topViewController;
        }
    }

    if ([self isKindOfClass:UITabBarController.class]) {
        UITabBarController *tab = (UITabBarController *)self;
        if (tab.childViewControllers.count > 0) {
            return tab.selectedViewController.sf_topViewController;
        }
    }

    UIViewController *presentedViewController = self;
    while (presentedViewController.presentedViewController) {
        presentedViewController = presentedViewController.presentedViewController;
    }

    if (presentedViewController != self && ([presentedViewController isKindOfClass:UINavigationController.class] ||
                                            [presentedViewController isKindOfClass:UITabBarController.class])) {
        return presentedViewController.sf_topViewController;
    }

    return presentedViewController;
}

- (void)sf_dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    [self.presentingViewController ? : self dismissViewControllerAnimated:flag completion:completion];
}

@end

@implementation UIAlertController (SFExtension)

+ (instancetype)sf_alertStyleWithTitle:(NSString *)title message:(NSString *)message {
    return [self alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
}

+ (instancetype)sf_actionSheetStyleWithTitle:(NSString *)title message:(NSString *)message {
    return [self alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
}

- (void)sf_addDefaultActionWithTitle:(NSString *)title handler:(void (^ __nullable)(UIAlertAction *action))handler {
    UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:handler];
    [self addAction:action];
}

- (void)sf_addCancelActionWithTitle:(NSString *)title handler:(void (^ __nullable)(UIAlertAction *action))handler {
    UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleCancel handler:handler];
    [self addAction:action];
}

- (void)sf_addDestructiveActionWithTitle:(NSString *)title handler:(void (^ __nullable)(UIAlertAction *action))handler {
    UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDestructive handler:handler];
    [self addAction:action];
}

#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0)
- (void)sf_addPreferredActionWithTitle:(NSString *)title handler:(void (^ __nullable)(UIAlertAction *action))handler {
    if (@available(iOS 9.0, *)) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:handler];
        self.preferredAction = action;
    }
}
#endif

@end

#endif
