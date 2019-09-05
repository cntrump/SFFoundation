//
//  SFImage.h
//  SFFoundation
//
//  Created by vvveiii on 2019/6/26.
//  Copyright © 2019 lvv. All rights reserved.
//

@interface SFImage (SFImageEx)

@property(nonatomic, readonly) CGImageRef sf_CGImage;
@property(nonatomic, readonly) CGFloat sf_scale;

+ (SFImage *)sf_imageWithSize:(CGSize)size flipped:(BOOL)drawingHandlerShouldBeCalledWithFlippedContext drawingHandler:(BOOL (^)(CGRect bounds))drawingHandler;

+ (SFImage *)sf_imageWithColor:(SFColor *)color;

- (SFImage *)sf_cropRect:(CGRect)rect;

#if SF_MACOS

- (SFImage *)sf_resizableImageWithCapInsets:(NSEdgeInsets)capInsets;

- (SFImage *)sf_resizableImageWithCapInsets:(NSEdgeInsets)capInsets resizingMode:(NSImageResizingMode)resizingMode;

#endif

+ (SFImage *)imageWithAttributedText:(NSAttributedString *)attributedText;

- (void)drawInRect:(CGRect)rect contentsGravity:(CALayerContentsGravity)contentsGravity;

@end

SF_EXTERN_C_BEGIN

#if SF_IOS
UIImageOrientation imageOrientationFromEXIFOrientation(CGImagePropertyOrientation exifOrientation);
CGImagePropertyOrientation exifOrientationFromImageOrientation(UIImageOrientation imageOrientation);
#endif

SF_EXTERN_C_END
