//
//  SFOverlayViewController.h
//  SFFoundation
//
//  Created by vvveiii on 2019/6/17.
//  Copyright © 2019 lvv. All rights reserved.
//
#if SF_IOS

@class SFOverlayWindow;

@interface SFOverlayViewController : UIViewController

@property(nonatomic, weak) UIWindow *mainWindow;
@property(nonatomic, weak) SFOverlayWindow *rootWindow;

@end

#endif
