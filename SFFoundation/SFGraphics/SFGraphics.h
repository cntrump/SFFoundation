//
//  SFGraphics.h
//  SFFoundation
//
//  Created by vvveiii on 2019/7/15.
//  Copyright © 2019 lvv. All rights reserved.
//

SF_EXTERN_C_BEGIN

#if SF_MACOS
#   define UIEdgeInsets NSEdgeInsets
#   define UIImageResizingMode NSImageResizingMode
#   define UIImageResizingModeStretch NSImageResizingModeStretch
#   define UIImageResizingModeTile NSImageResizingModeTile
#endif

CGContextRef SFGraphicsGetCurrentContext(void);
void SFGraphicsPushContext(CGContextRef context);
void SFGraphicsPopContext(void);

void     SFGraphicsBeginImageContext(CGSize size);
void     SFGraphicsBeginImageContextWithOptions(CGSize size, BOOL opaque, CGFloat scale);
SFImage* SFGraphicsGetImageFromCurrentImageContext(void);
void     SFGraphicsEndImageContext(void);

void SFContextDrawImage(CGContextRef c, CGRect rect, CGImageRef image, UIEdgeInsets capInsets, UIImageResizingMode resizingMode);

SF_EXTERN_C_END
