//
//  SFAnimatedImage.h
//  SFFoundation
//
//  Created by vvveiii on 2019/7/26.
//  Copyright © 2019 lvv. All rights reserved.
//

@interface SFAnimatedImageDecoder : NSObject

@property(nullable, nonatomic, copy) NSData *imageData;
@property(nullable, nonatomic, copy) void (^updateImageBlock)(SFImage * _Nonnull image);

@property(nonatomic, assign, getter=isPaused) BOOL paused;
@property(nonatomic, readonly) BOOL isPaused;

@end

@protocol SFImageViewProtocol <NSObject>

@optional
@property(nullable, nonatomic, strong) SFImage *image;

@end

@protocol SFLayerProtocol <NSObject>

@optional
@property(nullable, strong) id contents;

@end

@interface NSObject (SFAnimatedImage) <SFImageViewProtocol, SFLayerProtocol>

@property(nullable, nonatomic, copy) NSData *sf_animatedImageData;

@end
