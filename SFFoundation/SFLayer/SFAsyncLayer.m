//
//  SFAsyncLayer.m
//  SFFoundation
//
//  Created by vvveiii on 2019/7/16.
//  Copyright © 2019 lvv. All rights reserved.
//

#import "SFAsyncLayer.h"
#import "SFGraphics.h"
#import "SFDispatchQueue.h"
#import "SFAsyncTransaction.h"
#import "SFRunLoopObserver.h"
#import <stdatomic.h>

@interface SFAsyncLayer () {
    atomic_ullong _displaySentinel;
    SFDispatchQueue *_displayQueue;
}

@property(nonatomic, assign, readonly) ULONGLONG displaySentinel;

@end

@implementation SFAsyncLayer

+ (id)defaultValueForKey:(NSString *)key {
    if ([key isEqualToString:@"displayMode"]) {
        return @(SFAsyncLayerDisplayModeAsync);
    }

    if ([key isEqualToString:@"contentsScale"]) {
        return @(kScreenScaleFactor);
    }

    if ([key isEqualToString:@"contentsGravity"]) {
        return kCAGravityResize;
    }

    if ([key isEqualToString:@"needsDisplayOnBoundsChange"]) {
        return (__bridge id)kCFBooleanTrue;
    }
    
    return [super defaultValueForKey:key];
}

+ (SFDispatchQueue *)displayQueue {
    static SFDispatchQueue *queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = [SFDispatchQueue concurrentQueueWithLabel:"SFAsyncLayer.display"];
        queue.targetQueue = SFDispatchQueue.globalHighQueue;
    });

    return queue;
}

- (instancetype)init {
    if (self = [super init]) {
        atomic_init(&_displaySentinel, 0);
        _displayQueue = [self.class displayQueue];
    }

    return self;
}

- (void)setNeedsDisplay {
    [self cancelAsyncDisplay];
    [super setNeedsDisplay];
}

- (void)display {
    if (_displayMode == SFAsyncLayerDisplayModeSync) {
        [super display];
        return;
    }

    CGRect bounds = self.bounds;
    if (CGRectIsEmpty(bounds)) {
        return;
    }

    ULONGLONG displaySentinel = atomic_inc_return(&_displaySentinel);

    id parameters = self.drawParameters;

    if ([self.delegate respondsToSelector:@selector(asyncLayer:willDisplayAsynchronouslyWithDrawParameters:)]) {
        SFImage *image = [self.delegate asyncLayer:self willDisplayAsynchronouslyWithDrawParameters:parameters];
        if (image) {
#if SF_IOS
            self.contents = (__bridge id)image.CGImage;
#endif
#if SF_MACOS
            self.contents = image;
#endif
            return;
        }
    }

    __weak typeof(self) wself = self;
    SFAsyncTransactionBlock block = [self transactionBlockWithBounds:bounds
                                                   displaySentinel:displaySentinel
                                                    drawParameters:parameters
                                                     contentsScale:self.contentsScale];

    [self.asyncTransaction addOperationWithBlock:block queue:[self.class displayQueue] completion:^(SFImage *value) {
        if (!wself || wself.displaySentinel != displaySentinel) {
            return;
        }

        if ([wself.delegate respondsToSelector:@selector(asyncLayer:didDisplayAsynchronously:withDrawParameters:)]) {
            [wself.delegate asyncLayer:self didDisplayAsynchronously:value withDrawParameters:parameters];
        }

#if SF_IOS
        wself.contents = (__bridge id)value.CGImage;
#endif
#if SF_MACOS
        wself.contents = value;
#endif
    }];
}

- (void)drawInContext:(CGContextRef)ctx {
    SFGraphicsPushContext(ctx);
    CGRect bounds = self.bounds;
#if SF_MACOS
    CGContextTranslateCTM(ctx, 0, CGRectGetHeight(bounds));
    CGContextScaleCTM(ctx, 1, -1);
#endif

    if ([self.delegate respondsToSelector:@selector(asyncLayer:drawInContext:bounds:parameters:renderSynchronously:)]) {
        [self.delegate asyncLayer:self drawInContext:ctx bounds:bounds parameters:self.drawParameters renderSynchronously:YES];
    }

    SFGraphicsPopContext();
}

- (void)setDelegate:(id<SFAsyncLayerDelegate>)delegate {
    super.delegate = delegate;
}

- (id<SFAsyncLayerDelegate>)delegate {
    return (id<SFAsyncLayerDelegate>)super.delegate;
}

#pragma mark -

- (ULONGLONG)displaySentinel {
    return _displaySentinel;
}

- (void)cancelAsyncDisplay {
    atomic_inc_return(&_displaySentinel);
}

- (id)drawParameters {
    id parameters = nil;
    if ([self.delegate respondsToSelector:@selector(drawParametersInAsyncLayer:)]) {
        parameters = [self.delegate drawParametersInAsyncLayer:self];
    }

    return parameters;
}

- (SFAsyncTransactionBlock)transactionBlockWithBounds:(CGRect)bounds
                                    displaySentinel:(ULONGLONG)displaySentinel
                                     drawParameters:(id)parameters
                                      contentsScale:(CGFloat)scale {
    bounds.size = CGSizeMake(ceil(CGRectGetWidth(bounds) * scale) / scale, ceil(CGRectGetHeight(bounds) * scale) / scale);
    __weak typeof(self) wself = self;

    return ^SFImage * {
        if (!wself || wself.displaySentinel != displaySentinel) {
            return nil;
        }

        SFGraphicsBeginImageContextWithOptions(bounds.size, NO, scale);
        CGContextRef ctx = SFGraphicsGetCurrentContext();

        [wself drawAsyncLayerInContext:ctx bounds:bounds parameters:parameters];

        SFImage *image = SFGraphicsGetImageFromCurrentImageContext();
        SFGraphicsEndImageContext();

        return image;
    };
}

- (SFAsyncTransaction *)asyncTransaction {
    CALayer *layer = self;
    SFAsyncTransaction *transaction = layer.sf_asyncTransaction;

    while (!transaction && layer) {
        layer = layer.superlayer;
        transaction = layer.sf_asyncTransaction;
    }

    if (!transaction) {
        transaction = [[SFAsyncTransaction alloc] init];
        self.sf_asyncTransaction = transaction;
    }

    return transaction;
}

- (void)drawAsyncLayerInContext:(CGContextRef)context bounds:(CGRect)bounds parameters:(NSObject *)parameters {
    if ([self.delegate respondsToSelector:@selector(asyncLayer:drawInContext:bounds:parameters:renderSynchronously:)]) {
        [self.delegate asyncLayer:self drawInContext:context bounds:bounds parameters:parameters renderSynchronously:NO];
    }
}

@end

@implementation CALayer (SFAsyncTransaction)

- (void)setSf_asyncTransaction:(SFAsyncTransaction *)asyncTransaction {
    if (self.sf_asyncTransaction == asyncTransaction) {
        return;
    }

    objc_setAssociatedObject(self, @selector(sf_asyncTransaction), asyncTransaction, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SFAsyncTransaction *)sf_asyncTransaction {
    return objc_getAssociatedObject(self, @selector(sf_asyncTransaction));
}

@end
