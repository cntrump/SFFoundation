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

SF_EXTERN CALayerContentsGravity _Nonnull const sfkCAGravityRedraw;
SF_EXTERN CALayerContentsGravity _Nonnull CALayerContentsGravityFromSFViewContentMode(SFViewContentMode contentMode);

#endif

#if SF_IOS
@interface SFView : UIView
#endif
#if SF_MACOS
@interface SFView : NSView
#endif

+ (Class _Nonnull)layerClass;

#if SF_MACOS
@property(nonatomic, assign) SFViewContentMode contentMode;
#endif

@end

@interface SFAsyncView : SFView

@property (nonatomic, nullable, strong, readonly) id drawParameters;

- (void)drawInContext:(CGContextRef _Nonnull)context bounds:(CGRect)bounds parameters:(id _Nullable)parameters renderSynchronously:(BOOL)renderSynchronously;
- (SFImage * _Nullable)willDisplayAsynchronouslyWithDrawParameters:(id _Nullable)drawParameters;
- (void)didDisplayAsynchronously:(SFImage * _Nullable)newContents withDrawParameters:(id _Nullable)drawParameters;

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

@end

#endif
