//
//  SFAsyncLayer.h
//  SFFoundation
//
//  Created by vvveiii on 2019/7/16.
//  Copyright © 2019 lvv. All rights reserved.
//

typedef NS_ENUM(NSUInteger, SFAsyncLayerDisplayMode) {
    SFAsyncLayerDisplayModeAsync = 0,
    SFAsyncLayerDisplayModeSync,
};

@class SFAsyncLayer;

@protocol SFAsyncLayerDelegate <CALayerDelegate>

- (id _Nullable)drawParametersInAsyncLayer:(SFAsyncLayer * _Nonnull)layer;

- (void)asyncLayer:(SFAsyncLayer * _Nonnull)layer
     drawInContext:(CGContextRef _Nonnull)context
            bounds:(CGRect)bounds
        parameters:(id _Nullable)parameters
renderSynchronously:(BOOL)renderSynchronously;

- (SFImage * _Nullable)asyncLayer:(SFAsyncLayer * _Nonnull)layer willDisplayAsynchronouslyWithDrawParameters:(id _Nullable)drawParameters;

- (void)asyncLayer:(SFAsyncLayer * _Nonnull)layer didDisplayAsynchronously:(SFImage * _Nullable)newContents withDrawParameters:(id _Nullable)drawParameters;

@end

@interface SFAsyncLayer : CALayer

@property(nonatomic, assign) SFAsyncLayerDisplayMode displayMode;

@property(nullable, weak) id <SFAsyncLayerDelegate> delegate;

@end

@class SFAsyncTransaction;

@interface CALayer (SFAsyncTransaction)

@property(nonatomic, nullable, strong) SFAsyncTransaction *sf_asyncTransaction;

@end
