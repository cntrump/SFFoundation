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

void SFContextDrawImage(CGContextRef c, CGRect rect, CGImageRef image, UIEdgeInsets capInsets, UIImageResizingMode resizingMode) {
    if (!c || !image) {
        return;
    }

    CGFloat x = CGRectGetMinX(rect);
    CGFloat y = CGRectGetMinY(rect);

    size_t width = CGImageGetWidth(image);
    size_t height = CGImageGetHeight(image);

    CGFloat top = capInsets.top;
    CGFloat left = capInsets.left;
    CGFloat bottom = capInsets.bottom;
    CGFloat right = capInsets.right;

    // top-left
    {
        CGRect r = CGRectMake(0, 0, left, top);
        CGImageRef img = CGImageCreateWithImageInRect(image, r);
        if (img) {
            if (!CGRectIsEmpty(r))
                CGContextDrawImage(c, CGRectMake(x, y, CGRectGetWidth(r), CGRectGetHeight(r)), img);
            CGImageRelease(img);
        }
    }
    // top-right
    {
        CGRect r = CGRectMake(width - right, 0, right, top);
        CGImageRef img = CGImageCreateWithImageInRect(image, r);
        if (img) {
            if (!CGRectIsEmpty(r))
                CGContextDrawImage(c,
                                   CGRectMake(x + CGRectGetWidth(rect) - CGRectGetWidth(r), y, CGRectGetWidth(r), CGRectGetHeight(r)),
                                   img);
            CGImageRelease(img);
        }
    }
    // bottom-left
    {
        CGRect r = CGRectMake(0, height - bottom, left, bottom);
        CGImageRef img = CGImageCreateWithImageInRect(image, r);
        if (img) {
            if (!CGRectIsEmpty(r))
                CGContextDrawImage(c,
                                   CGRectMake(x, y + CGRectGetHeight(rect) - CGRectGetHeight(r), CGRectGetWidth(r), CGRectGetHeight(r)),
                                   img);
            CGImageRelease(img);
        }
    }
    // bottom-right
    {
        CGRect r = CGRectMake(width - right, height - bottom, right, bottom);
        CGImageRef img = CGImageCreateWithImageInRect(image, r);
        if (img) {
            if (!CGRectIsEmpty(r))
                CGContextDrawImage(c,
                                   CGRectMake(x + CGRectGetWidth(rect) - CGRectGetWidth(r),
                                              y + CGRectGetHeight(rect) - CGRectGetHeight(r),
                                              CGRectGetWidth(r),
                                              CGRectGetHeight(r)),
                                   img);
            CGImageRelease(img);
        }
    }

    // top-center
    {
        CGRect r = CGRectMake(left, 0, width - left - right, top);
        CGImageRef img = CGImageCreateWithImageInRect(image, r);
        if (img) {
            r = CGRectMake(x + left, y, MAX(0, CGRectGetWidth(rect) - left - right), top);
            if (!CGRectIsEmpty(r))
                resizingMode == UIImageResizingModeTile ? CGContextDrawTiledImage(c, r, img) : CGContextDrawImage(c, r, img);
            CGImageRelease(img);
        }
    }
    // center
    {
        CGRect r = CGRectMake(left, top, width - left - right, height - top - bottom);
        CGImageRef img = CGImageCreateWithImageInRect(image, r);
        if (img) {
            r = CGRectMake(x + left, y + top, MAX(0, CGRectGetWidth(rect) - left - right), MAX(0, CGRectGetHeight(rect) - top - bottom));
            if (!CGRectIsEmpty(r))
                resizingMode == UIImageResizingModeTile ? CGContextDrawTiledImage(c, r, img) : CGContextDrawImage(c, r, img);
            CGImageRelease(img);
        }
    }
    // bottom-center
    {
        CGRect r = CGRectMake(left, height - bottom, width - left - right, bottom);
        CGImageRef img = CGImageCreateWithImageInRect(image, r);
        if (img) {
            r = CGRectMake(x + left, y + CGRectGetHeight(rect) - bottom, MAX(0, CGRectGetWidth(rect) - left - right), bottom);
            if (!CGRectIsEmpty(r))
                resizingMode == UIImageResizingModeTile ? CGContextDrawTiledImage(c, r, img) : CGContextDrawImage(c, r, img);
            CGImageRelease(img);
        }
    }
}

SF_EXTERN_C_END
