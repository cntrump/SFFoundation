//
//  SFColor.m
//  SFFoundation
//
//  Created by vvveiii on 2019/6/26.
//  Copyright © 2019 lvv. All rights reserved.
//

#import "SFColor.h"

@implementation SFColor (SFColorEx)

+ (instancetype)sf_colorWithRGB:(NSUInteger)rgb {
    return [self sf_colorWithRGB:rgb alpha:1.0];
}

+ (instancetype)sf_colorWithRGB:(NSUInteger)rgb alpha:(CGFloat)alpha {
    alpha = MIN(1, MAX(0, alpha));

    return [SFColor colorWithRed:((rgb & 0xff0000) >> 16) / 255.0
                           green:((rgb & 0xff00) >> 8) / 255.0
                            blue:(rgb & 0xff) / 255.0
                           alpha:alpha];
}

@end
