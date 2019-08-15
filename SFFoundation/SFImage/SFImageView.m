//
//  SFImageView.m
//  SFFoundation
//
//  Created by vvveiii on 2019/6/29.
//  Copyright © 2019 lvv. All rights reserved.
//

#import "SFImageView.h"
#import "SFImage.h"

@interface SFImageView () {
    CAShapeLayer *_maskLayer;
    CAShapeLayer *_borderLayer;
    SFImage *_innerImage;
}

@end

@implementation SFImageView

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"<%@:%p contentMode:%ld image:<%@> layer:<%@:%p contentsGravity:%@> super:<%@>>",
            NSStringFromClass(self.class), self, (long)self.contentMode, self.image,
            NSStringFromClass(self.layer.class), self.layer, self.layer.contentsGravity,
            NSStringFromClass(self.superclass)];
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithCornerRadius:(CGFloat)cornerRadius {
    if (self = [self initWithFrame:CGRectZero]) {
        _cornerRadius = MAX(0, cornerRadius);
    }

    return self;
}
#if SF_IOS
- (instancetype)initWithImage:(UIImage *)image {
    CGRect frame = CGRectZero;
    frame.size = image.size;

    if (self = [self initWithFrame:frame]) {
        self.image = image;
    }

    return self;
}

- (instancetype)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage {
    if (self = [self initWithImage:image]) {
        self.highlightedImage = highlightedImage;
    }

    return self;
}
#endif
- (instancetype)initWithFrame:(CGRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
#if SF_MACOS
        self.layer = CALayer.layer;
        self.layer.contentsScale = kScreenScaleFactor;
        self.layer.delegate = (id<CALayerDelegate>)self;
        self.wantsLayer = YES;
#endif
        _borderLayer = CAShapeLayer.layer;
        _borderLayer.contentsScale = kScreenScaleFactor;
        _borderLayer.fillColor = SFColor.clearColor.CGColor;
        [self.layer addSublayer:_borderLayer];

        _maskLayer = CAShapeLayer.layer;
        _maskLayer.contentsScale = kScreenScaleFactor;
        self.layer.mask = _maskLayer;
    }

    return self;
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    if (layer == self.layer) {
        CGRect bounds = self.bounds;
        CGFloat cornerWidth = MIN(CGRectGetWidth(bounds) * 0.5, _cornerRadius), cornerHeight = MIN(CGRectGetHeight(bounds) * 0.5, _cornerRadius);
        CGFloat corner = MIN(cornerWidth, cornerHeight);

        CGPathRef path = CGPathCreateWithRoundedRect(bounds, corner, corner, nil);
        _maskLayer.path = path;
        _borderLayer.path = _borderWidth > 0 && _borderColor ? path : nil;
        CGPathRelease(path);
    }
}

- (void)setBorderColor:(SFColor *)borderColor {
    if (_borderColor == borderColor) {
        return;
    }

    _borderColor = borderColor;
    _borderLayer.strokeColor = borderColor.CGColor;
    [self.layer setNeedsLayout];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    if (_borderWidth == borderWidth) {
        return;
    }

    _borderWidth = borderWidth;
    _borderLayer.lineWidth = borderWidth;
    [self.layer setNeedsLayout];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    if (_cornerRadius == MAX(0, cornerRadius)) {
        return;
    }

    _cornerRadius = MAX(0, cornerRadius);
    [self.layer setNeedsLayout];
}

#if SF_MACOS

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    if (layer == self.layer) {
        CGContextDrawImage(ctx, self.bounds, _innerImage.sf_CGImage);
    }
}

- (void)setImage:(SFImage *)image {
    if (_innerImage == image) {
        return;
    }
    
    super.image = nil;

    _innerImage = image;
    self.layer.contents = image;
    self.needsDisplay = YES;
}

- (SFImage *)image {
    return _innerImage;
}

- (void)setContentMode:(SFViewContentMode)contentMode {
    if (_contentMode == contentMode) {
        return;
    }

    CALayerContentsGravity contentsGravity = CALayerContentsGravityFromSFViewContentMode(contentMode);
    if (contentsGravity) {
        _contentMode = contentMode;
        
        if ([contentsGravity isEqualToString:sfkCAGravityRedraw]) {
            self.layer.contentsGravity = kCAGravityResize;
            self.layer.needsDisplayOnBoundsChange = YES;
        } else {
            self.layer.contentsGravity = contentsGravity;
            self.layer.needsDisplayOnBoundsChange = NO;
        }

        [self.layer setNeedsDisplay];
    }
}
#endif

@end
