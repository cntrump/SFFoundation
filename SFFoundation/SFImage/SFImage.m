//
//  SFImage.m
//  SFFoundation
//
//  Created by vvveiii on 2019/6/26.
//  Copyright © 2019 lvv. All rights reserved.
//

#import "SFImage.h"
#import "SFGeometry.h"
#import "SFGraphics.h"

@implementation SFImage (SFImageEx)

- (CGImageRef)sf_CGImage {
#if SF_IOS
    return self.CGImage;
#endif
#if SF_MACOS
    return [self CGImageForProposedRect:NULL context:nil hints:nil];
#endif
}

- (CGFloat)sf_scale {
#if SF_IOS
    return self.scale;
#endif
#if SF_MACOS
    return [self recommendedLayerContentsScale:0];
#endif
}

+ (SFImage *)sf_imageWithSize:(CGSize)size
                      flipped:(BOOL)drawingHandlerShouldBeCalledWithFlippedContext
               drawingHandler:(BOOL (^)(CGRect bounds))drawingHandler {
    if (!drawingHandler) {
        return nil;
    }

    SFImage *image = nil;
    SFGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    if (drawingHandlerShouldBeCalledWithFlippedContext) {
        CGContextRef ctx = SFGraphicsGetCurrentContext();
        CGContextTranslateCTM(ctx, 0, size.height);
        CGContextScaleCTM(ctx, 1, -1);
    }

    BOOL result = drawingHandler(CGRectMake(0, 0, size.width, size.height));

    if (result) {
        image = SFGraphicsGetImageFromCurrentImageContext();
    }

    SFGraphicsEndImageContext();

    return image;
}

+ (SFImage *)sf_imageWithColor:(SFColor *)color {
    return [self sf_imageWithSize:CGSizeMake(1, 1) flipped:NO drawingHandler:^BOOL(CGRect bounds) {
        [color setFill];
#if SF_IOS
        UIRectFill(bounds);
#endif
#if SF_MACOS
        NSRectFill(bounds);
#endif
        return YES;
    }];
}

- (SFImage *)sf_cropRect:(CGRect)rect {
#if SF_IOS
    CGFloat scale = self.scale;
#endif

#if SF_MACOS
    CGFloat scale = self.sf_scale;
#endif

    CGRect dstRect = SFRectScale(rect, scale);
    dstRect = CGRectIntegral(dstRect);
    CGSize imageSize = SFSizeScale(self.size, scale);

    dstRect = CGRectIntersection(CGRectMake(0, 0, imageSize.width, imageSize.height), dstRect);

#if SF_IOS
    CGImageRef cgImage = CGImageCreateWithImageInRect(self.CGImage, dstRect);

    return [SFImage imageWithCGImage:cgImage];
#endif

#if SF_MACOS
    CGImageRef cgImage = CGImageCreateWithImageInRect(self.sf_CGImage, dstRect);

    return [[SFImage alloc] initWithCGImage:cgImage size:dstRect.size];
#endif
}

#if SF_MACOS

- (SFImage *)sf_resizableImageWithCapInsets:(NSEdgeInsets)capInsets {
    return [self sf_resizableImageWithCapInsets:capInsets resizingMode:NSImageResizingModeTile];
}

- (SFImage *)sf_resizableImageWithCapInsets:(NSEdgeInsets)capInsets resizingMode:(NSImageResizingMode)resizingMode {
    SFImage *image = self.copy;
    image.capInsets = capInsets;
    image.resizingMode = resizingMode;

    return image;
}

#endif

+ (SFImage *)imageWithAttributedText:(NSAttributedString *)attributedText {
    if (attributedText.length == 0) {
        return nil;
    }

    NSTextContainer *textContainer = [[NSTextContainer alloc] init];
    textContainer.lineFragmentPadding = 0;

    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    layoutManager.usesFontLeading = NO;

    NSTextStorage *textStorage = [[NSTextStorage alloc] init];

    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];
    [textStorage setAttributedString:attributedText];

    NSRange glyphRange = [layoutManager glyphRangeForTextContainer:textContainer];
    CGRect usedRect = [layoutManager usedRectForTextContainer:textContainer];
    usedRect = CGRectIntegral(usedRect);

    SFImage *image = [self sf_imageWithSize:usedRect.size flipped:NO drawingHandler:^BOOL(CGRect bounds) {
        [layoutManager drawBackgroundForGlyphRange:glyphRange atPoint:CGPointZero];
        [layoutManager drawGlyphsForGlyphRange:glyphRange atPoint:CGPointZero];

        return YES;
    }];

    return image;
}

- (void)drawInRect:(CGRect)rect contentsGravity:(CALayerContentsGravity)contentsGravity {
    CGRect bounds = rect;
    CGSize size = self.size;

    if ([contentsGravity isEqualToString:kCAGravityResizeAspectFill]) {
        bounds = SFMakeRectWithAspectRatioInsideRect(size, rect, SFCGContentModeScaleAspectFill);
    } else if ([contentsGravity isEqualToString:kCAGravityResizeAspect]) {
        bounds = SFMakeRectWithAspectRatioInsideRect(size, rect, SFCGContentModeScaleAspectFit);
    } else if ([contentsGravity isEqualToString:kCAGravityTop]) {
        bounds = SFMakeRectWithAspectRatioInsideRect(size, rect, SFCGContentModeTop);
    } else if ([contentsGravity isEqualToString:kCAGravityLeft]) {
        bounds = SFMakeRectWithAspectRatioInsideRect(size, rect, SFCGContentModeLeft);
    } else if ([contentsGravity isEqualToString:kCAGravityBottom]) {
        bounds = SFMakeRectWithAspectRatioInsideRect(size, rect, SFCGContentModeBottom);
    } else if ([contentsGravity isEqualToString:kCAGravityRight]) {
        bounds = SFMakeRectWithAspectRatioInsideRect(size, rect, SFCGContentModeRight);
    } else if ([contentsGravity isEqualToString:kCAGravityTopLeft]) {
        bounds = SFMakeRectWithAspectRatioInsideRect(size, rect, SFCGContentModeTopLeft);
    } else if ([contentsGravity isEqualToString:kCAGravityTopRight]) {
        bounds = SFMakeRectWithAspectRatioInsideRect(size, rect, SFCGContentModeTopRight);
    } else if ([contentsGravity isEqualToString:kCAGravityBottomLeft]) {
        bounds = SFMakeRectWithAspectRatioInsideRect(size, rect, SFCGContentModeBottomLeft);
    } else if ([contentsGravity isEqualToString:kCAGravityBottomRight]) {
        bounds = SFMakeRectWithAspectRatioInsideRect(size, rect, SFCGContentModeBottomRight);
    } else if ([contentsGravity isEqualToString:kCAGravityCenter]) {
        bounds = SFMakeRectWithAspectRatioInsideRect(size, rect, SFCGContentModeCenter);
    }

    bounds = CGRectIntegral(bounds);

    [self drawInRect:bounds];
}

@end

SF_EXTERN_C_BEGIN
UIImageOrientation imageOrientationFromEXIFOrientation(CGImagePropertyOrientation exifOrientation) {
    NSDictionary<NSNumber*,NSNumber*> *table = @{
                                   @(kCGImagePropertyOrientationUp):            @(UIImageOrientationUp),
                                   @(kCGImagePropertyOrientationDown):          @(UIImageOrientationDown),
                                   @(kCGImagePropertyOrientationLeft):          @(UIImageOrientationLeft),
                                   @(kCGImagePropertyOrientationRight):         @(UIImageOrientationRight),
                                   @(kCGImagePropertyOrientationUpMirrored):    @(UIImageOrientationUpMirrored),
                                   @(kCGImagePropertyOrientationDownMirrored):  @(UIImageOrientationDownMirrored),
                                   @(kCGImagePropertyOrientationLeftMirrored):  @(UIImageOrientationLeftMirrored),
                                   @(kCGImagePropertyOrientationRightMirrored): @(UIImageOrientationRightMirrored)
                                   };

    return (UIImageOrientation)(table[@(exifOrientation)] ? : @(UIImageOrientationUp)).integerValue;
}

CGImagePropertyOrientation exifOrientationFromImageOrientation(UIImageOrientation imageOrientation) {
    NSDictionary<NSNumber*,NSNumber*> *table = @{
                                                 @(UIImageOrientationUp):             @(kCGImagePropertyOrientationUp),
                                                 @(UIImageOrientationDown):           @(kCGImagePropertyOrientationDown),
                                                 @(UIImageOrientationLeft):           @(kCGImagePropertyOrientationLeft),
                                                 @(UIImageOrientationRight):          @(kCGImagePropertyOrientationRight),
                                                 @(UIImageOrientationUpMirrored):     @(kCGImagePropertyOrientationUpMirrored),
                                                 @(UIImageOrientationDownMirrored):   @(kCGImagePropertyOrientationDownMirrored),
                                                 @(UIImageOrientationLeftMirrored):   @(kCGImagePropertyOrientationLeftMirrored),
                                                 @(UIImageOrientationRightMirrored):  @(kCGImagePropertyOrientationRightMirrored)
                                                 };

    return (CGImagePropertyOrientation)(table[@(imageOrientation)] ? : @(kCGImagePropertyOrientationUp)).integerValue;
}
SF_EXTERN_C_END
