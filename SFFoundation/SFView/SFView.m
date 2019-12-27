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
        return [self sf_groupedTableViewWithFrame:frame];
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

#endif
