//
//  CALayer+SFExtension.h
//  SFFoundation
//
//  Created by v on 2019/11/20.
//  Copyright © 2019 lvv. All rights reserved.
//

@interface CALayer (SFExtension)

@property(nonatomic, assign) CGFloat sf_shadowSpread; // default is 0

- (void)sf_updateShadowPath; // if spread or bounds changed, you need call it.

- (void)sf_applySketchShadow:(CGColorRef)color
                       alpha:(CGFloat)alpha
                           x:(CGFloat)x y:(CGFloat)y
                        blur:(CGFloat)blur
                      spread:(CGFloat)spread;

@end
