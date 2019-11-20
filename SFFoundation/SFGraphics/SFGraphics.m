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
#define __SF_FLIP_RECT__(f)    CGContextTranslateCTM(c, (f).origin.x, (f).origin.y); \
                                CGContextTranslateCTM(c, 0, (f).size.height); \
                                CGContextScaleCTM(c, 1.0, -1.0); \
                                CGContextTranslateCTM(c, -(f).origin.x, -(f).origin.y);

#define __SF_DRAW_RECT__(d, img)   CGContextSaveGState(c); \
                                    __SF_FLIP_RECT__(d); \
                                    CGContextDrawImage(c, (d), img); \
                                    CGContextRestoreGState(c); \
                                    CGImageRelease(img)
    CGImageRef image0 = CGImageCreateWithImageInRect(image, s[0]);
    if (image0) {
        __SF_DRAW_RECT__(r[0], image0);
    }

    CGImageRef image1 = CGImageCreateWithImageInRect(image, s[1]);
    if (image1) {
        __SF_DRAW_RECT__(r[1], image1);
    }

    CGImageRef image2 = CGImageCreateWithImageInRect(image, s[2]);
    if (image2) {
        __SF_DRAW_RECT__(r[2], image2);
    }

    CGImageRef image3 = CGImageCreateWithImageInRect(image, s[3]);
    if (image3) {
        __SF_DRAW_RECT__(r[3], image3);
    }

    CGImageRef image4 = CGImageCreateWithImageInRect(image, s[4]);
    if (image4) {
        __SF_DRAW_RECT__(r[4], image4);
    }

    CGImageRef image5 = CGImageCreateWithImageInRect(image, s[5]);
    if (image5) {
        __SF_DRAW_RECT__(r[5], image5);
    }

    CGImageRef image6 = CGImageCreateWithImageInRect(image, s[6]);
    if (image6) {
        __SF_DRAW_RECT__(r[6], image6);
    }

    CGImageRef image7 = CGImageCreateWithImageInRect(image, s[7]);
    if (image7) {
        __SF_DRAW_RECT__(r[7], image7);
    }

    CGImageRef image8 = CGImageCreateWithImageInRect(image, s[8]);
    if (image8) {
        __SF_DRAW_RECT__(r[8], image8);
    }

#undef __SF_FLIP_RECT__
#undef __SF_DRAW_RECT__
}
#endif
SF_EXTERN_C_END

#if SF_MACOS
@implementation NSBezierPath (SFExtension)

- (CGPathRef)sf_cgPath {
    NSInteger i, numElements;

    // Need to begin a path here.
    CGPathRef           immutablePath = NULL;

    // Then draw the path elements.
    numElements = [self elementCount];

    if (numElements > 0) {
        CGMutablePathRef    path = CGPathCreateMutable();
        NSPoint             points[3];
        BOOL                didClosePath = YES;

        for (i = 0; i < numElements; i++) {
            switch ([self elementAtIndex:i associatedPoints:points]) {

                case NSMoveToBezierPathElement:
                    CGPathMoveToPoint(path, NULL, points[0].x, points[0].y);

                    break;

                case NSLineToBezierPathElement:
                    CGPathAddLineToPoint(path, NULL, points[0].x, points[0].y);
                    didClosePath = NO;

                    break;

                case NSCurveToBezierPathElement:
                    CGPathAddCurveToPoint(path, NULL, points[0].x, points[0].y,
                                          points[1].x, points[1].y,
                                          points[2].x, points[2].y);

                    didClosePath = NO;

                    break;

                case NSClosePathBezierPathElement:
                    CGPathCloseSubpath(path);
                    didClosePath = YES;

                    break;

            }
        }

        // Be sure the path is closed or Quartz may not do valid hit detection.

        if (!didClosePath)
            CGPathCloseSubpath(path);

        immutablePath = CGPathCreateCopy(path);
        CGPathRelease(path);
    }

    return immutablePath;
}

@end
#endif
