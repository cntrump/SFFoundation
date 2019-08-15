//
//  SFAsyncImageView.m
//  SFFoundation
//
//  Created by vvveiii on 2019/7/22.
//  Copyright © 2019 lvv. All rights reserved.
//

#import "SFAsyncImageView.h"
#import "SFImage.h"
#import "SFAsyncLayer.h"

@interface SFAsyncImageContext : NSObject

@property(nonatomic, strong) SFImage *image;
@property(nonatomic, strong) CALayerContentsGravity contentsGravity;

@end

@implementation SFAsyncImageContext

@end

@implementation SFAsyncImageView

- (instancetype)initWithImage:(SFImage *)image {
    CGSize size = image.size;
    return [self initWithFrame:CGRectMake(0, 0, size.width, size.height)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
#if SF_IOS
        self.userInteractionEnabled = NO;
#endif
    }

    return self;
}

- (SFAsyncImageContext *)drawParameters {
    SFAsyncImageContext *context = [[SFAsyncImageContext alloc] init];
    context.image = self.image;
    context.contentsGravity = self.layer.contentsGravity;

    return context;
}

- (void)drawInContext:(CGContextRef _Nonnull)context bounds:(CGRect)bounds parameters:(SFAsyncImageContext *)parameters renderSynchronously:(BOOL)renderSynchronously {
    SFImage *image = parameters.image;
    [image drawInRect:bounds contentsGravity:parameters.contentsGravity];
}

- (void)setImage:(SFImage *)image {
    if (_image == image) {
        return;
    }

    _image = image;
    [self.layer setNeedsDisplay];
}

@end

