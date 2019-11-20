//
//  CALayer+SFExtension.m
//  SFFoundation
//
//  Created by v on 2019/11/20.
//  Copyright © 2019 lvv. All rights reserved.
//

#import "CALayer+SFExtension.h"
#import "SFGraphics.h"

@implementation CALayer (SFExtension)

- (void)setSf_shadowSpread:(CGFloat)shadowSpread {
    objc_setAssociatedObject(self, @selector(sf_shadowSpread), @(shadowSpread), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)sf_shadowSpread {
    return (CGFloat)[objc_getAssociatedObject(self, @selector(sf_shadowSpread)) floatValue];
}

- (void)sf_applySketchShadow:(CGColorRef)color
                       alpha:(CGFloat)alpha
                           x:(CGFloat)x y:(CGFloat)y
                        blur:(CGFloat)blur
                      spread:(CGFloat)spread {
    self.shadowColor = color;
    self.shadowOpacity = alpha;
    self.shadowRadius = blur * 0.5;
    self.shadowOffset = CGSizeMake(x, y);
    self.sf_shadowSpread = spread;

    [self sf_updateShadowPath];
}

- (void)sf_updateShadowPath {
    CGFloat spread = self.sf_shadowSpread;
    CGRect bounds = CGRectInset(self.bounds, -spread, -spread);
    CGPathRef path;
#if SF_IOS
    path = [UIBezierPath bezierPathWithRoundedRect:bounds cornerRadius:self.cornerRadius].CGPath;
#endif
#if SF_MACOS
    path = [NSBezierPath bezierPathWithRoundedRect:bounds xRadius:self.cornerRadius yRadius:self.cornerRadius].sf_cgPath;
#endif

    self.shadowPath = path;
}

@end
