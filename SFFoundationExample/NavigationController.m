//
//  NavigationController.m
//  SFFoundationExample
//
//  Created by vvveiii on 2019/7/2.
//  Copyright © 2019 lvv. All rights reserved.
//

#import "NavigationController.h"

@interface NavigationController ()

@end

@implementation NavigationController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.topViewController.preferredStatusBarStyle;
}

@end
