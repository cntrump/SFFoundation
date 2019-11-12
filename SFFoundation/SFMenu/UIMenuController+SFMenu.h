//
//  UIMenuController+SFMenu.h
//  SFFoundation
//
//  Created by v on 2019/11/12.
//  Copyright © 2019 lvv. All rights reserved.
//

#if SF_IOS

@interface UIMenuController (SFMenu)

- (void)sf_showMenuFromView:(UIView *)targetView rect:(CGRect)targetRect;
- (void)sf_hideMenu;

@end

#endif
