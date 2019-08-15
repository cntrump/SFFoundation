//
//  SFGeometry.m
//  SFFoundation
//
//  Created by vvveiii on 2019/6/29.
//  Copyright © 2019 lvv. All rights reserved.
//

#import "SFGeometry.h"

SF_EXTERN_C_BEGIN
CGRect SFRectScale(CGRect rect, CGFloat scale) {
    CGRect r = rect;
    r.origin.x -= CGRectGetWidth(rect) * (scale - 1) * 0.5;
    r.origin.y -= CGRectGetHeight(rect) * (scale - 1) * 0.5;
    r.size.width *= scale;
    r.size.height *= scale;

    return r;
}

CGSize SFSizeScale(CGSize size, CGFloat scale) {
    CGSize s = size;
    s.width *= scale;
    s.height *= scale;

    return s;
}

CGRect SFMakeRectWithAspectRatioInsideRect(CGSize aspectRatio, CGRect boundingRect, SFCGContentMode contentMode) {
    CGRect bounds = boundingRect;
    CGFloat scale = 1;

    if (contentMode == SFCGContentModeScaleToFill) {
        return boundingRect;
    }

    CGFloat h = CGRectGetHeight(boundingRect), w = CGRectGetWidth(boundingRect);
    CGFloat y = CGRectGetMinY(boundingRect), x = CGRectGetMinX(boundingRect);

    SFCGContentMode aspectMode = contentMode & 7;
    switch (aspectMode) {
        case SFCGContentModeCenter:
            break;
            
        case SFCGContentModeScaleAspectFit:
            scale = MIN(h / aspectRatio.height, w / aspectRatio.width);
            break;

        case SFCGContentModeScaleAspectFill:
            scale = MAX(h / aspectRatio.height, w / aspectRatio.width);
            break;

        default:
            break;
    }

    CGFloat width = aspectRatio.width * scale, height = aspectRatio.height * scale;
    CGFloat fy = (h - height) * 0.5, fx = (w - width) * 0.5;

    if (BIT_TEST(contentMode, SFCGContentModeTop)) {
        fy = 0;
    }

    if (BIT_TEST(contentMode, SFCGContentModeLeft)) {
        fx = 0;
    }

    if (BIT_TEST(contentMode, SFCGContentModeBottom)) {
        fy *= 2;
    }

    if (BIT_TEST(contentMode, SFCGContentModeRight)) {
        fx *= 2;
    }

    bounds = CGRectMake(x + fx, y + fy, width, height);

    return bounds;
}

SF_EXTERN_C_END
