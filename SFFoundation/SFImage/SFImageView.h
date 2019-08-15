//
//  SFImageView.h
//  SFFoundation
//
//  Created by vvveiii on 2019/6/29.
//  Copyright © 2019 lvv. All rights reserved.
//

#import "SFView.h"

#if SF_IOS
@interface SFImageView : UIImageView
#endif
#if SF_MACOS
@interface SFImageView : NSImageView
#endif

@property(nullable, nonatomic, strong) SFColor *borderColor;
@property(nonatomic, assign) CGFloat borderWidth;
@property(nonatomic, assign) CGFloat cornerRadius;

#if SF_MACOS
@property(nonatomic, assign) SFViewContentMode contentMode;
#endif

- (instancetype _Nullable)initWithCornerRadius:(CGFloat)cornerRadius;

@end

