//
//  SFGraphics.m
//  SFFoundation
//
//  Created by vvveiii on 2019/7/15.
//  Copyright © 2019 lvv. All rights reserved.
//

#import "SFGraphics.h"

SF_EXTERN_C_BEGIN

CGContextRef SFGraphicsGetCurrentContext(void) {
#if SF_IOS
    return UIGraphicsGetCurrentContext();
#endif
#if SF_MACOS
    return NSGraphicsContext.currentContext.CGContext;
#endif
}

void SFGraphicsPushContext(CGContextRef context) {
#if SF_IOS
    UIGraphicsPushContext(context);
#endif
#if SF_MACOS
    NSGraphicsContext *c = [NSGraphicsContext graphicsContextWithCGContext:context flipped:YES];
    [NSGraphicsContext saveGraphicsState];
    NSGraphicsContext.currentContext = c;
#endif
}

void SFGraphicsPopContext(void) {
#if SF_IOS
    UIGraphicsPopContext();
#endif
#if SF_MACOS
    [NSGraphicsContext restoreGraphicsState];
#endif
}

void SFGraphicsBeginImageContext(CGSize size) {
#if SF_IOS
    UIGraphicsBeginImageContext(size);
#endif
#if SF_MACOS
    SFGraphicsBeginImageContextWithOptions(size, NO, 1);
#endif
}

void SFGraphicsBeginImageContextWithOptions(CGSize size, BOOL opaque, CGFloat scale) {
#if SF_IOS
    UIGraphicsBeginImageContextWithOptions(size, opaque, scale);
#endif
#if SF_MACOS
    scale = fabs(scale) ? : NSScreen.mainScreen.backingScaleFactor;
    size_t width = ceil(size.width * scale);
    size_t height = ceil(size.height * scale);
    size_t bitsPerComponent = 8;
    size_t bytesPerRow = 4 * width;

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Host | (opaque ? kCGImageAlphaNoneSkipFirst : kCGImageAlphaPremultipliedFirst);
    CGContextRef ctx = CGBitmapContextCreate(NULL, width, height, bitsPerComponent, bytesPerRow, colorSpace, bitmapInfo);
    CGColorSpaceRelease(colorSpace);

    CGContextTranslateCTM(ctx, 0, height);
    CGContextScaleCTM(ctx, scale, -scale);

    SFGraphicsPushContext(ctx);
    CGContextRelease(ctx);
#endif
}

SFImage* SFGraphicsGetImageFromCurrentImageContext(void) {
#if SF_IOS
    return UIGraphicsGetImageFromCurrentImageContext();
#endif
#if SF_MACOS
    SFImage *image = nil;
    CGImageRef cgImage = CGBitmapContextCreateImage(SFGraphicsGetCurrentContext());
    if (cgImage) {
        image = [[SFImage alloc] initWithCGImage:cgImage size:NSZeroSize];
        CGImageRelease(cgImage);
    }

    return image;
#endif
}

void SFGraphicsEndImageContext(void) {
#if SF_IOS
    UIGraphicsEndImageContext();
#endif
#if SF_MACOS
    SFGraphicsPopContext();
#endif
}

SF_EXTERN_C_END
