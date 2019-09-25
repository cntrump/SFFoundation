//
//  SFGeometry.h
//  SFFoundation
//
//  Created by vvveiii on 2019/6/29.
//  Copyright © 2019 lvv. All rights reserved.
//

SF_EXTERN_C_BEGIN

typedef NS_OPTIONS(NSInteger, SFCGContentMode) {
    SFCGContentModeScaleToFill = 0,
    SFCGContentModeScaleAspectFit = 1,
    SFCGContentModeScaleAspectFill = 3,
    SFCGContentModeCenter = 7,
    SFCGContentModeTop = BIT(3),
    SFCGContentModeLeft = BIT(4),
    SFCGContentModeBottom = BIT(5),
    SFCGContentModeRight = BIT(6),
    SFCGContentModeTopLeft = SFCGContentModeTop | SFCGContentModeLeft,
    SFCGContentModeTopRight = SFCGContentModeTop | SFCGContentModeRight,
    SFCGContentModeBottomLeft = SFCGContentModeBottom | SFCGContentModeLeft,
    SFCGContentModeBottomRight = SFCGContentModeBottom | SFCGContentModeRight
};

CGRect SFRectScale(CGRect rect, CGFloat scale);

CGSize SFSizeScale(CGSize size, CGFloat scale);

CGRect SFMakeRectWithAspectRatioInsideRect(CGSize aspectRatio, CGRect boundingRect, SFCGContentMode contentMode);

void SFRectSlicing(CGRect r, UIEdgeInsets capInsets, CGRect *slices/*[9]*/);

SF_EXTERN_C_END
