//
//  SFView.h
//  SFFoundation
//
//  Created by vvveiii on 2019/7/20.
//  Copyright © 2019 lvv. All rights reserved.
//

#if SF_MACOS
typedef NS_ENUM(NSInteger, SFViewContentMode) {
    SFViewContentModeScaleToFill = 0,
    SFViewContentModeScaleAspectFit,      // contents scaled to fit with fixed aspect. remainder is transparent
    SFViewContentModeScaleAspectFill,     // contents scaled to fill with fixed aspect. some portion of content may be clipped.
    SFViewContentModeRedraw,              // redraw on bounds change (calls -setNeedsDisplay)
    SFViewContentModeCenter,              // contents remain same size. positioned adjusted.
    SFViewContentModeTop,
    SFViewContentModeBottom,
    SFViewContentModeLeft,
    SFViewContentModeRight,
    SFViewContentModeTopLeft,
    SFViewContentModeTopRight,
    SFViewContentModeBottomLeft,
    SFViewContentModeBottomRight
};

SF_EXTERN CALayerContentsGravity const sfkCAGravityRedraw;
SF_EXTERN CALayerContentsGravity CALayerContentsGravityFromSFViewContentMode(SFViewContentMode contentMode);

#endif

#if SF_IOS
@interface SFView : UIView
#endif
#if SF_MACOS
@interface SFView : NSView
#endif

+ (Class)layerClass;

#if SF_MACOS
@property(nonatomic, assign) SFViewContentMode contentMode;
#endif

@end

@interface SFAsyncView : SFView

@property (nonatomic, strong, readonly) id drawParameters;

- (void)drawInContext:(CGContextRef)context bounds:(CGRect)bounds parameters:(id)parameters renderSynchronously:(BOOL)renderSynchronously;
- (SFImage *)willDisplayAsynchronouslyWithDrawParameters:(id)drawParameters;
- (void)didDisplayAsynchronously:(SFImage *)newContents withDrawParameters:(id)drawParameters;

@end

#if SF_IOS
@interface UIView (SFExtension)

@property(nonatomic, assign) CGPoint sf_frameOrigin;
@property(nonatomic, assign) CGSize sf_frameSize;

@property(nonatomic, assign) CGPoint sf_boundsOrigin;
@property(nonatomic, assign) CGSize sf_boundsSize;

@property(nonatomic, assign) CGFloat sf_centerX;
@property(nonatomic, assign) CGFloat sf_centerY;

@end

@interface UITableView (SFExtension)

#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
+ (instancetype)sf_insetGroupedStyleWithFrame:(CGRect)frame;
#endif

+ (instancetype)sf_groupedStyleWithFrame:(CGRect)frame;

+ (instancetype)sf_plainStyleWithFrame:(CGRect)frame;

- (void)sf_performBatchUpdates:(void (^)(void))updates;

- (void)sf_registerReuseableCellClass:(Class)cellClass;

- (void)sf_registerReuseableHeaderFooterViewClass:(Class)viewClass;

- (__kindof UITableViewCell *)sf_dequeueReusableCellWithClass:(Class)cellClass forIndexPath:(NSIndexPath *)indexPath;

- (__kindof UITableViewHeaderFooterView *)sf_dequeueReusableHeaderFooterViewWithClass:(Class)viewClass;

@end

@interface UICollectionView (SFExtension)

- (void)sf_registerReuseableCellClass:(Class)cellClass;

- (void)sf_registerReuseableHeaderViewClass:(Class)viewClass;

- (void)sf_registerReuseableFooterViewClass:(Class)viewClass;

- (__kindof UICollectionViewCell *)sf_dequeueReusableCellWithClass:(Class)cellClass forIndexPath:(NSIndexPath *)indexPath;

- (__kindof UICollectionReusableView *)sf_dequeueReusableHeaderViewWithClass:(Class)viewClass forIndexPath:(NSIndexPath *)indexPath;

- (__kindof UICollectionReusableView *)sf_dequeueReusableFooterViewWithClass:(Class)viewClass forIndexPath:(NSIndexPath *)indexPath;

@end

@interface SFShadowView : UIView
@end

@interface SFBoxView : UIView

@property(nonatomic, strong) UIView *selectionView;
@property(nonatomic, strong) UIView *backgroundView;
@property(nonatomic, readonly) UIView *contentView;

@property(nonatomic, assign) UIEdgeInsets padding;
@property(nonatomic, assign) CGFloat cornerRadius;

@property(nonatomic, assign, getter=isHighlighted) BOOL highlighted;

@property(nonatomic, readonly) BOOL isHighlighted;

- (void)setBorder:(UIColor *)color width:(CGFloat)width;
- (void)setShadow:(UIColor *)color offset:(CGSize)offset blur:(CGFloat)blur opacity:(CGFloat)opacity;

@end

typedef NS_ENUM(NSInteger, SFGradientDirection) {
    SFGradientDirectionHorizontal,
    SFGradientDirectionVertical
};

@interface SFGradientView : UIView

+ (instancetype)gradientHorizontalWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor;

+ (instancetype)gradientVerticalWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor;

+ (instancetype)gradientHorizontalWithColors:(NSArray<UIColor *> *)colors locations:(NSArray<NSNumber *> *)locations;

+ (instancetype)gradientVerticalWithColors:(NSArray<UIColor *> *)colors locations:(NSArray<NSNumber *> *)locations;

- (instancetype)initWithDirection:(SFGradientDirection)direction startColor:(UIColor *)startColor endColor:(UIColor *)endColor;

- (instancetype)initWithDirection:(SFGradientDirection)direction colors:(NSArray<UIColor *> *)colors locations:(NSArray<NSNumber *> *)locations;

@end


#endif
