//
//  SFGraphics.h
//  SFFoundation
//
//  Created by vvveiii on 2019/7/15.
//  Copyright © 2019 lvv. All rights reserved.
//

SF_EXTERN_C_BEGIN

CGContextRef SFGraphicsGetCurrentContext(void);
void SFGraphicsPushContext(CGContextRef context);
void SFGraphicsPopContext(void);

void     SFGraphicsBeginImageContext(CGSize size);
void     SFGraphicsBeginImageContextWithOptions(CGSize size, BOOL opaque, CGFloat scale);
SFImage* SFGraphicsGetImageFromCurrentImageContext(void);
void     SFGraphicsEndImageContext(void);

#if SF_IOS
void SFContextDrawImage(CGContextRef c, CGRect rect, CGImageRef image,
                        UIEdgeInsets capInsets, UIImageResizingMode resizingMode, CGFloat scale);
#endif

SF_EXTERN_C_END
