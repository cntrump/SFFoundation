//
//  SFColor.h
//  SFFoundation
//
//  Created by vvveiii on 2019/6/26.
//  Copyright © 2019 lvv. All rights reserved.
//

@interface SFColor (SFColorEx)

+ (instancetype)sf_colorWithRGB:(NSUInteger)rgb;
+ (instancetype)sf_colorWithRGB:(NSUInteger)rgb alpha:(CGFloat)alpha;

@end
