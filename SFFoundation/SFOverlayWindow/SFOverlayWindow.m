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

@interface SFOverlayWindow () {
    UIWindowLevel _innerWindowLevel;
}

@property(nonatomic, weak) UIWindow *baseKeyWindow;

@end

@implementation SFOverlayWindow

+ (Class)rootViewControllerClass {
    return SFOverlayViewController.class;
}

+ (instancetype)window {
    return [[self alloc] initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    UIWindow *basedWindow = nil;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0
    if (@available(iOS 13.0, *)) {
        UIWindowScene *windowScene = nil;
        for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
            if ([scene isKindOfClass:UIWindowScene.class]) {
                if (scene.activationState == UISceneActivationStateForegroundActive) {
                    windowScene = (UIWindowScene *)scene;

                    for (UIWindow *window in windowScene.windows) {
                        if (window.isKeyWindow) {
                            basedWindow = window;
                            break;
                        }
                    }

                    break;
                }
            }
        }

        self = [super initWithWindowScene:windowScene];
    } else {
#endif
        for (UIWindow *window in UIApplication.sharedApplication.windows) {
            if (window.isKeyWindow) {
                basedWindow = window;
                break;
            }
        }

        self = [super initWithFrame:frame];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0
    }
#endif
    if (self) {
        _baseKeyWindow = basedWindow;
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

- (void)destory {
    if (self.hidden) {
        return;
    }

    self.hidden = YES;
    ((SFOverlayViewController *)self.rootViewController).rootWindow = nil;
    [self.baseKeyWindow makeKeyWindow];
}

- (void)show {
    [self showWithLevel:self.windowLevel];
}

- (void)showWithLevel:(UIWindowLevel)level {
    if (!self.isHidden || !self.baseKeyWindow) {
        return;
    }

    SFOverlayViewController *rootVC = (SFOverlayViewController *)self.rootViewController;
    rootVC.mainWindow = self.baseKeyWindow;
    rootVC.rootWindow = self;
    rootVC.view.backgroundColor = UIColor.clearColor;

    self.backgroundColor = UIColor.clearColor;
    self.frame = self.baseKeyWindow.frame;
    self.windowLevel = level;
    [self makeKeyAndVisible];
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    if (!self.hidden || !self.baseKeyWindow || self.rootViewController.presentedViewController) {
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
