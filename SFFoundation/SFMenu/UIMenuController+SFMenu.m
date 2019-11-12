//
//  UIMenuController+SFMenu.m
//  SFFoundation
//
//  Created by v on 2019/11/12.
//  Copyright © 2019 lvv. All rights reserved.
//

#import "UIMenuController+SFMenu.h"

#if SF_IOS

@implementation UIMenuController (SFMenu)

- (void)sf_showMenuFromView:(UIView *)targetView rect:(CGRect)targetRect {
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
    if (@available(iOS 13.0, *)) {
        [self showMenuFromView:targetView rect:targetRect];
    } else {
#endif
        [self setTargetRect:targetRect inView:targetView];
        [self setMenuVisible:YES animated:NO];
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
    }
#endif
}

- (void)sf_hideMenu {
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
    if (@available(iOS 13.0, *)) {
        [self hideMenu];
    } else {
#endif
        [self setMenuVisible:NO animated:NO];
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
    }
#endif
}

@end

#endif
