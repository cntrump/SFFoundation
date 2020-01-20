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

void SFRectSlicing(CGRect r, UIEdgeInsets capInsets, CGRect *slices/*[9]*/) {
    if (CGRectIsEmpty(r)) {
        return;
    }

    CGFloat X0 = CGRectGetMinX(r);
    CGFloat Y0 = CGRectGetMinY(r);
    CGFloat W = CGRectGetWidth(r);
    CGFloat H = CGRectGetHeight(r);

    CGFloat TOP = capInsets.top;
    CGFloat LEFT = capInsets.left;
    CGFloat BOTTOM = capInsets.bottom;
    CGFloat RIGHT = capInsets.right;

    CGFloat x0 = X0;
    CGFloat x1 = X0 + LEFT;
    CGFloat x2 = X0 + W - RIGHT;
    CGFloat x3 = X0 + W;
    CGFloat y0 = Y0;
    CGFloat y1 = Y0 + BOTTOM;
    CGFloat y2 = Y0 + H - TOP;
    CGFloat y3 = Y0 + H;

    slices[0] = CGRectMake(x0, y0, x1-x0, y1-y0);
    slices[1] = CGRectMake(x1, y0, x2-x1, y1-y0);
    slices[2] = CGRectMake(x2, y0, x3-x2, y1-y0);
    slices[3] = CGRectMake(x0, y1, x1-x0, y2-y1);
    slices[4] = CGRectMake(x1, y1, x2-x1, y2-y1);
    slices[5] = CGRectMake(x2, y1, x3-x2, y2-y1);
    slices[6] = CGRectMake(x0, y2, x1-x0, y3-y2);
    slices[7] = CGRectMake(x1, y2, x2-x1, y3-y2);
    slices[8] = CGRectMake(x2, y2, x3-x2, y3-y2);
}

CGSize SFLayoutWrapItems(NSInteger itemCount, CGFloat width, CGSize itemSize, CGFloat interItemSpacing, CGFloat lineSpacing) {
    NSInteger col = (width - interItemSpacing) / (itemSize.width + interItemSpacing);
    NSInteger row = ceil((CGFloat)itemCount / (CGFloat)col);
    CGFloat h = (itemSize.height + lineSpacing) * row - lineSpacing;
    CGFloat w = (itemSize.width + interItemSpacing) * col - interItemSpacing;

    return CGSizeMake(w, h);
}

CGSize SFLayoutWrap(NSInteger itemCount, CGFloat width, CGSize itemSize, CGFloat spacing) {
    return SFLayoutWrapItems(itemCount, width, itemSize, spacing, spacing);
}

SF_EXTERN_C_END
