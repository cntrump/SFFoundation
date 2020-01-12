//
//  SFView.m
//  SFFoundation
//
//  Created by vvveiii on 2019/7/20.
//  Copyright © 2019 lvv. All rights reserved.
//

#import "SFView.h"
#import "SFRuntime.h"
#import "SFAsyncLayer.h"

#if SF_MACOS
SF_EXTERN_C_BEGIN
CALayerContentsGravity const sfkCAGravityRedraw = @"sf.CAGravityRedraw";
CALayerContentsGravity CALayerContentsGravityFromSFViewContentMode(SFViewContentMode contentMode) {
    return @{
             @(SFViewContentModeScaleToFill) : kCAGravityResize,
             @(SFViewContentModeScaleAspectFit) : kCAGravityResizeAspect,      // contents scaled to fit with fixed aspect. remainder is transparent
             @(SFViewContentModeScaleAspectFill) : kCAGravityResizeAspectFill,     // contents scaled to fill with fixed aspect. some portion of content may be clipped.
             @(SFViewContentModeRedraw) : sfkCAGravityRedraw,              // redraw on bounds change (calls -setNeedsDisplay)
             @(SFViewContentModeCenter) : kCAGravityCenter,              // contents remain same size. positioned adjusted.
             @(SFViewContentModeTop) : kCAGravityTop,
             @(SFViewContentModeBottom) : kCAGravityBottom,
             @(SFViewContentModeLeft) : kCAGravityLeft,
             @(SFViewContentModeRight) : kCAGravityRight,
             @(SFViewContentModeTopLeft) : kCAGravityTopLeft,
             @(SFViewContentModeTopRight) : kCAGravityTopRight,
             @(SFViewContentModeBottomLeft) : kCAGravityBottomLeft,
             @(SFViewContentModeBottomRight) : kCAGravityBottomRight
             }[@(contentMode)];
}
SF_EXTERN_C_END
#else

#endif

@implementation SFView

+ (Class)layerClass {
    return CALayer.class;
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
#if SF_IOS
        self.contentScaleFactor = kScreenScaleFactor;
#endif
#if SF_MACOS
        self.layer = [[self.class.layerClass alloc] init];
        self.layer.contentsScale = kScreenScaleFactor;
        self.layer.delegate = (id<CALayerDelegate>)self;
        self.wantsLayer = YES;
#endif
    }

    return self;
}

#if SF_MACOS
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

@implementation SFAsyncView

+ (Class)layerClass {
    return SFAsyncLayer.class;
}

- (id _Nullable)drawParametersInAsyncLayer:(SFAsyncLayer * _Nonnull)layer {
    return [self drawParameters];
}

- (void)asyncLayer:(SFAsyncLayer * _Nonnull)layer drawInContext:(CGContextRef _Nonnull)context bounds:(CGRect)bounds
        parameters:(id _Nullable)parameters renderSynchronously:(BOOL)renderSynchronously {
    [self drawInContext:context bounds:bounds parameters:parameters renderSynchronously:renderSynchronously];
}

- (SFImage * _Nullable)asyncLayer:(SFAsyncLayer * _Nonnull)layer willDisplayAsynchronouslyWithDrawParameters:(id _Nullable)drawParameters {
    return [self willDisplayAsynchronouslyWithDrawParameters:drawParameters];
}

- (void)asyncLayer:(SFAsyncLayer * _Nonnull)layer didDisplayAsynchronously:(SFImage * _Nullable)newContents withDrawParameters:(id _Nullable)drawParameters {
    [self didDisplayAsynchronously:newContents withDrawParameters:drawParameters];
}

- (id _Nullable)drawParameters {
    return nil;
}

- (void)drawInContext:(CGContextRef _Nonnull)context bounds:(CGRect)bounds parameters:(id _Nullable)parameters renderSynchronously:(BOOL)renderSynchronously {
}

- (SFImage * _Nullable)willDisplayAsynchronouslyWithDrawParameters:(id _Nullable)drawParameters {
    return nil;
}

- (void)didDisplayAsynchronously:(SFImage * _Nullable)newContents withDrawParameters:(id _Nullable)drawParameters {
}

@end

#if SF_IOS
@implementation UIView (SFExtension)

- (void)setSf_frameOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)sf_frameOrigin {
    return self.frame.origin;
}

- (void)setSf_frameSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)sf_frameSize {
    return self.frame.size;
}

- (void)setSf_boundsOrigin:(CGPoint)origin {
    CGRect bounds = self.bounds;
    bounds.origin = origin;
    self.bounds = bounds;
}

- (CGPoint)sf_boundsOrigin {
    return self.bounds.origin;
}

- (void)setSf_boundsSize:(CGSize)size {
    CGRect bounds = self.bounds;
    bounds.size = size;
    self.bounds = bounds;
}

- (CGSize)sf_boundsSize {
    return self.bounds.size;
}

- (void)setSf_centerX:(CGFloat)x {
    CGPoint center = self.center;
    center.x = x;
    self.center = center;
}

- (CGFloat)sf_centerX {
    return self.center.x;
}

- (void)setSf_centerY:(CGFloat)y {
    CGPoint center = self.center;
    center.y = y;
    self.center = center;
}

- (CGFloat)sf_centerY {
    return self.center.y;
}

@end

@implementation UITableView (SFExtension)

#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
+ (instancetype)sf_insetGroupedStyleWithFrame:(CGRect)frame {
    if (@available(iOS 13.0, *)) {
        return [[self alloc] initWithFrame:frame style:UITableViewStyleInsetGrouped];
    } else {
        return [self sf_groupedStyleWithFrame:frame];
    }
}
#endif

+ (instancetype)sf_groupedStyleWithFrame:(CGRect)frame {
    return [[self alloc] initWithFrame:frame style:UITableViewStyleGrouped];
}

+ (instancetype)sf_plainStyleWithFrame:(CGRect)frame {
    return [[self alloc] initWithFrame:frame style:UITableViewStylePlain];
}

@end

@interface SFShadowView() {
    UIColor *_color;
    CGFloat _opacity;
    CGFloat _blur;
    CGSize _offset;
}

@end

@implementation SFShadowView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _blur = 6;
        _offset = CGSizeMake(0, 3);
        _opacity = 0.2;
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self updateShadow];
}

- (void)setShadow:(UIColor *)color offset:(CGSize)offset blur:(CGFloat)blur opacity:(CGFloat)opacity {
    _color = color;
    _offset = offset;
    _blur = blur;
    _opacity = opacity;

    [self updateShadow];
}

- (void)updateShadow {
    self.layer.shadowColor = _color.CGColor;
    self.layer.shadowOpacity = _opacity;
    self.layer.shadowOffset = _offset;
    self.layer.shadowRadius = _blur * 0.5;

    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                    cornerRadius:self.layer.cornerRadius];
    self.layer.shadowPath = _color ? path.CGPath : nil;
}

@end

@interface SFBoxView () {
    SFShadowView *_shadowView;
}

@end

@implementation SFBoxView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _shadowView = [[SFShadowView alloc] initWithFrame:self.bounds];
        [self addSubview:_shadowView];

        _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:_backgroundView];

        _contentView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:_contentView];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self updateContentBounds];
}

- (void)updateContentBounds {
    CGRect bounds = UIEdgeInsetsInsetRect(self.bounds, _padding);
    _shadowView.frame = bounds;
    _backgroundView.frame = bounds;
    _contentView.frame = bounds;
}

- (void)setBounds:(CGRect)bounds {
    super.bounds = bounds;

    [self updateContentBounds];
}

- (void)setPadding:(UIEdgeInsets)padding {
    _padding = padding;
    [self updateContentBounds];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    _contentView.layer.cornerRadius = cornerRadius;
    _contentView.layer.masksToBounds = YES;

    _backgroundView.layer.cornerRadius = cornerRadius;
    _backgroundView.layer.masksToBounds = YES;

    _shadowView.layer.cornerRadius = cornerRadius;
}

- (void)setBorder:(UIColor *)color width:(CGFloat)width {
    _contentView.layer.borderColor = color.CGColor;
    _contentView.layer.borderWidth = width;
}

- (void)setShadow:(UIColor *)color offset:(CGSize)offset blur:(CGFloat)blur opacity:(CGFloat)opacity {
    [_shadowView setShadow:color offset:offset blur:blur opacity:opacity];
}

@end

#endif
