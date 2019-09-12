//
//  SFOverlayWindow.m
//  SFFoundation
//
//  Created by vvveiii on 2019/6/17.
//  Copyright © 2019 lvv. All rights reserved.
//
#if SF_IOS

#import "SFOverlayWindow.h"
#import "SFOverlayViewController.h"
#import "UIViewController+SFOverlayWindow.h"
#import <stdatomic.h>

static atomic_long windowCount = 0;

@interface SFOverlayWindow () {
    UIWindowLevel _innerWindowLevel;
}

@end

@implementation SFOverlayWindow

+ (Class)rootViewControllerClass {
    return SFOverlayViewController.class;
}

+ (instancetype)window {
    return [[self alloc] initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0
    if (@available(iOS 13.0, *)) {
        UIWindowScene *windowScene = nil;
        for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
            if ([scene isKindOfClass:UIWindowScene.class]) {
                if (scene.activationState == UISceneActivationStateForegroundActive) {
                    windowScene = (UIWindowScene *)scene;
                    break;
                }
            }
        }

        self = [super initWithWindowScene:windowScene];
    } else {
#endif
        self = [super initWithFrame:frame];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0
    }
#endif
    if (self) {
        _innerWindowLevel = UIWindowLevelNormal;
        self.rootViewController = [[self.class.rootViewControllerClass alloc] init];
    }

    return self;
}

- (UIWindowLevel)windowLevel {
    return _innerWindowLevel;
}

- (void)setWindowLevel:(UIWindowLevel)windowLevel {
    _innerWindowLevel = windowLevel;
    super.windowLevel = windowLevel;
}

+ (UIWindow *)mainWindow {
    return UIApplication.sharedApplication.delegate.window;
}

- (void)destory {
    if (self.hidden) {
        return;
    }

    long remainWindowCount = atomic_dec_return(&windowCount);

    self.hidden = YES;
    ((SFOverlayViewController *)self.rootViewController).rootWindow = nil;

    if (remainWindowCount <= 0) {
        [self.class.mainWindow makeKeyWindow];
    }
}

- (void)show {
    [self showWithLevel:self.windowLevel];
}

- (void)showWithLevel:(UIWindowLevel)level {
    if (!self.isHidden || !self.class.mainWindow) {
        return;
    }

    atomic_inc_return(&windowCount);

    SFOverlayViewController *rootVC = (SFOverlayViewController *)self.rootViewController;
    rootVC.mainWindow = self.class.mainWindow;
    rootVC.rootWindow = self;
    rootVC.view.backgroundColor = UIColor.clearColor;

    self.backgroundColor = UIColor.clearColor;
    self.frame = self.class.mainWindow.frame;
    self.windowLevel = level;
    [self makeKeyAndVisible];
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    if (!self.hidden || !self.class.mainWindow || self.rootViewController.presentedViewController) {
        return;
    }

    if (@available(iOS 9.0, *)) {

    }

    [self show];

    viewControllerToPresent.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.rootViewController presentViewController:viewControllerToPresent animated:flag completion:completion];
}

@end


@implementation UIWindow (SFOverlayWindow)

- (void)sf_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    [self.rootViewController.sf_topViewController presentViewController:viewControllerToPresent animated:YES completion:nil];
}

@end

#endif
