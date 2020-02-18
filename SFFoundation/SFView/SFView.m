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

- (void)sf_performBatchUpdates:(void (^)(void))updates {
    if (!updates) {
        return;
    }

    if (@available(iOS 11.0, *)) {
        [self performBatchUpdates:updates completion:nil];
    } else {
        [self beginUpdates];
        updates();
        [self endUpdates];
    }
}

- (void)sf_registerReuseableCellClass:(Class)cellClass {
    [self registerClass:cellClass forCellReuseIdentifier:NSStringFromClass(cellClass)];
}

- (void)sf_registerReuseableHeaderFooterViewClass:(Class)viewClass {
    [self registerClass:viewClass forHeaderFooterViewReuseIdentifier:NSStringFromClass(viewClass)];
}

- (__kindof UITableViewCell *)sf_dequeueReusableCellWithClass:(Class)cellClass forIndexPath:(NSIndexPath *)indexPath {
    return [self dequeueReusableCellWithIdentifier:NSStringFromClass(cellClass) forIndexPath:indexPath];
}

- (__kindof UITableViewHeaderFooterView *)sf_dequeueReusableHeaderFooterViewWithClass:(Class)viewClass {
    return [self dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(viewClass)];
}

@end

@implementation UICollectionView (SFExtension)

- (void)sf_registerReuseableCellClass:(Class)cellClass {
    [self registerClass:cellClass forCellWithReuseIdentifier:NSStringFromClass(cellClass)];
}

- (void)sf_registerReuseableHeaderViewClass:(Class)viewClass {
    [self registerClass:viewClass
          forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
          withReuseIdentifier:NSStringFromClass(viewClass)];
}

- (void)sf_registerReuseableFooterViewClass:(Class)viewClass {
    [self registerClass:viewClass
          forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
          withReuseIdentifier:NSStringFromClass(viewClass)];
}

- (__kindof UICollectionViewCell *)sf_dequeueReusableCellWithClass:(Class)cellClass forIndexPath:(NSIndexPath *)indexPath {
    return [self dequeueReusableCellWithReuseIdentifier:NSStringFromClass(cellClass)
                                           forIndexPath:indexPath];
}

- (__kindof UICollectionReusableView *)sf_dequeueReusableHeaderViewWithClass:(Class)viewClass forIndexPath:(NSIndexPath *)indexPath {
    return [self dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                    withReuseIdentifier:NSStringFromClass(viewClass)
                                           forIndexPath:indexPath];
}

- (__kindof UICollectionReusableView *)sf_dequeueReusableFooterViewWithClass:(Class)viewClass forIndexPath:(NSIndexPath *)indexPath {
    return [self dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                    withReuseIdentifier:NSStringFromClass(viewClass)
                                           forIndexPath:indexPath];
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
    BOOL _highlighted;
}

@end

@implementation SFBoxView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _shadowView = [[SFShadowView alloc] initWithFrame:self.bounds];
        _shadowView.userInteractionEnabled = NO;
        [self addSubview:_shadowView];

        _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        _backgroundView.userInteractionEnabled = NO;
        [self addSubview:_backgroundView];

        _selectionView = [[UIView alloc] initWithFrame:self.bounds];
        _selectionView.userInteractionEnabled = NO;
        _selectionView.alpha = 0;
        [self addSubview:_selectionView];

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
    _selectionView.frame = bounds;
    _contentView.frame = bounds;
}

- (void)setBounds:(CGRect)bounds {
    super.bounds = bounds;

    [self updateContentBounds];
}

- (void)setFrame:(CGRect)frame{
    super.frame = frame;

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

    _selectionView.layer.cornerRadius = cornerRadius;
    _selectionView.layer.masksToBounds = YES;

    _shadowView.layer.cornerRadius = cornerRadius;
}

- (void)setBorder:(UIColor *)color width:(CGFloat)width {
    _contentView.layer.borderColor = color.CGColor;
    _contentView.layer.borderWidth = width;
}

- (void)setShadow:(UIColor *)color offset:(CGSize)offset blur:(CGFloat)blur opacity:(CGFloat)opacity {
    [_shadowView setShadow:color offset:offset blur:blur opacity:opacity];
}

- (void)setBackgroundView:(UIView *)backgroundView {
    [_backgroundView removeFromSuperview];
    _backgroundView = backgroundView;

    if (backgroundView) {
        backgroundView.userInteractionEnabled = NO;
        [self insertSubview:backgroundView aboveSubview:_shadowView];
        backgroundView.frame = UIEdgeInsetsInsetRect(self.bounds, _padding);
        backgroundView.layer.cornerRadius = _cornerRadius;
        backgroundView.layer.masksToBounds = YES;
    }
}

- (void)setSelectionView:(UIView *)selectionView {
    [_selectionView removeFromSuperview];
    _selectionView = selectionView;

    if (selectionView) {
        selectionView.userInteractionEnabled = NO;
        selectionView.frame = UIEdgeInsetsInsetRect(self.bounds, _padding);
        selectionView.layer.cornerRadius = _cornerRadius;
        selectionView.layer.masksToBounds = YES;
        selectionView.alpha = 0;
        [self updateSelectionView];
    }
}

- (void)setHighlighted:(BOOL)highlighted {
    _highlighted = highlighted;

    [self updateSelectionView];
}

- (BOOL)isHighlighted {
    return _highlighted;
}

- (void)updateSelectionView {
    if (_backgroundView) {
        [self insertSubview:_selectionView aboveSubview:_backgroundView];
    } else {
        [self insertSubview:_selectionView aboveSubview:_shadowView];
    }

    _selectionView.alpha = self.isHighlighted ? 1 : 0;
}

@end

@implementation SFGradientView

+ (Class)layerClass {
    return CAGradientLayer.class;
}

+ (instancetype)gradientHorizontalWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor {
    return [[self alloc] initWithDirection:SFGradientDirectionHorizontal startColor:startColor endColor:endColor];
}

+ (instancetype)gradientVerticalWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor {
    return [[self alloc] initWithDirection:SFGradientDirectionVertical startColor:startColor endColor:endColor];
}

+ (instancetype)gradientHorizontalWithColors:(NSArray<UIColor *> *)colors locations:(NSArray<NSNumber *> *)locations {
    return [[self alloc] initWithDirection:SFGradientDirectionHorizontal colors:colors locations:locations];
}

+ (instancetype)gradientVerticalWithColors:(NSArray<UIColor *> *)colors locations:(NSArray<NSNumber *> *)locations {
    return [[self alloc] initWithDirection:SFGradientDirectionVertical colors:colors locations:locations];
}

- (instancetype)initWithDirection:(SFGradientDirection)direction startColor:(UIColor *)startColor endColor:(UIColor *)endColor {
    return [self initWithDirection:direction colors:@[startColor, endColor] locations:@[@0, @1]];
}

- (instancetype)initWithDirection:(SFGradientDirection)direction colors:(NSArray<UIColor *> *)colors locations:(NSArray<NSNumber *> *)locations {
    if (self = [super initWithFrame:CGRectZero]) {
        CAGradientLayer *layer = (CAGradientLayer *)self.layer;

        layer.colors = ({
            NSMutableArray *array = NSMutableArray.array;
            for (UIColor *color in colors) {
                [array addObject:(__bridge id)color.CGColor];
            }

            array;
        });

        layer.locations = ({
            NSMutableArray *array = NSMutableArray.array;
            for (NSNumber *location in locations) {
                [array addObject:location];
            }

            array;
        });

        switch (direction) {
            case SFGradientDirectionHorizontal:
                layer.startPoint = CGPointZero;
                layer.endPoint = CGPointMake(1, 0);
                break;

            case SFGradientDirectionVertical:
                layer.startPoint = CGPointZero;
                layer.endPoint = CGPointMake(0, 1);
                break;

            default:
                break;
        }
    }

    return self;
}

@end

#endif
