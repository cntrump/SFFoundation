//
//  SFGraphics.m
//  SFFoundation
//
//  Created by vvveiii on 2019/7/15.
//  Copyright © 2019 lvv. All rights reserved.
//

#import "SFGraphics.h"
#import "SFGeometry.h"

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

/*

x0     x1      x2      x3
+-------+-------+-------+ y3
|       |       |       |
|   6   |   7   |   8   |
|       |       |       |
+-------+-------+-------+ y2
|       |       |       |
|   3   |   4   |   5   |
|       |       |       |
+-------+-------+-------+ y1
|       |       |       |
|   0   |   1   |   2   |
|       |       |       |
+-------+-------+-------+ y0
 
*/
#if SF_IOS
void SFContextDrawImage(CGContextRef c, CGRect rect, CGImageRef image,
                        UIEdgeInsets capInsets, UIImageResizingMode resizingMode, CGFloat scale) {
    if (!c || !image) {
        return;
    }

    CGRect imageRect = CGRectMake(0, 0, CGImageGetWidth(image), CGImageGetHeight(image));
    CGRect r[9], s[9];
    SFRectSlicing(rect, capInsets, r);
    SFRectSlicing(imageRect,
                  UIEdgeInsetsMake(capInsets.top * scale,
                                   capInsets.left * scale,
                                   capInsets.bottom * scale,
                                   capInsets.right * scale),
                  s);

    CGImageRef image0 = CGImageCreateWithImageInRect(image, s[0]);
    if (image0) {
        CGContextSaveGState(c);
        CGContextTranslateCTM(c, r[0].origin.x, r[0].origin.y);
        CGContextTranslateCTM(c, 0, r[0].size.height);
        CGContextScaleCTM(c, 1.0, -1.0);
        CGContextTranslateCTM(c, -r[0].origin.x, -r[0].origin.y);
        CGContextDrawImage(c, r[0], image0);
        CGContextRestoreGState(c);
        CGImageRelease(image0);
    }

    CGImageRef image1 = CGImageCreateWithImageInRect(image, s[1]);
    if (image1) {
        CGContextDrawImage(c, r[1], image1);
        CGImageRelease(image1);
    }

    CGImageRef image2 = CGImageCreateWithImageInRect(image, s[2]);
    if (image2) {
        CGContextSaveGState(c);
        CGContextTranslateCTM(c, r[2].origin.x, r[2].origin.y);
        CGContextTranslateCTM(c, 0, r[2].size.height);
        CGContextScaleCTM(c, 1.0, -1.0);
        CGContextTranslateCTM(c, -r[2].origin.x, -r[2].origin.y);
        CGContextDrawImage(c, r[2], image2);
        CGContextRestoreGState(c);
        CGImageRelease(image2);
    }

    CGImageRef image3 = CGImageCreateWithImageInRect(image, s[3]);
    if (image3) {
        CGContextDrawImage(c, r[3], image3);
        CGImageRelease(image3);
    }

    CGImageRef image4 = CGImageCreateWithImageInRect(image, s[4]);
    if (image4) {
        CGContextDrawImage(c, r[4], image4);
        CGImageRelease(image4);
    }

    CGImageRef image5 = CGImageCreateWithImageInRect(image, s[5]);
    if (image5) {
        CGContextDrawImage(c, r[5], image5);
        CGImageRelease(image5);
    }

    CGImageRef image6 = CGImageCreateWithImageInRect(image, s[6]);
    if (image6) {
        CGContextSaveGState(c);
        CGContextTranslateCTM(c, r[6].origin.x, r[6].origin.y);
        CGContextTranslateCTM(c, 0, r[6].size.height);
        CGContextScaleCTM(c, 1.0, -1.0);
        CGContextTranslateCTM(c, -r[6].origin.x, -r[6].origin.y);
        CGContextDrawImage(c, r[6], image6);
        CGContextRestoreGState(c);
        CGImageRelease(image6);
    }

    CGImageRef image7 = CGImageCreateWithImageInRect(image, s[7]);
    if (image7) {
        CGContextDrawImage(c, r[7], image7);
        CGImageRelease(image7);
    }

    CGImageRef image8 = CGImageCreateWithImageInRect(image, s[8]);
    if (image8) {
        CGContextSaveGState(c);
        CGContextTranslateCTM(c, r[8].origin.x, r[8].origin.y);
        CGContextTranslateCTM(c, 0, r[8].size.height);
        CGContextScaleCTM(c, 1.0, -1.0);
        CGContextTranslateCTM(c, -r[8].origin.x, -r[8].origin.y);
        CGContextDrawImage(c, r[8], image8);
        CGContextRestoreGState(c);
        CGImageRelease(image8);
    }
}
#endif
SF_EXTERN_C_END
