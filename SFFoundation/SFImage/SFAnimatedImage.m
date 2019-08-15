//
//  SFAnimatedImage.m
//  SFFoundation
//
//  Created by vvveiii on 2019/7/26.
//  Copyright © 2019 lvv. All rights reserved.
//

#import "SFAnimatedImage.h"
#import "SFImageSource.h"
#import "SFDisplayLink.h"

#define kGIFSignature    "GIF8"
#define kGIFSignatureLength 4

#define kAPNGSignature  "\x89\x50\x4E\x47\x0D\x0A\x1A\x0A"
#define kAPNGSignatureLength 8

@interface SFAnimatedImageDecoder () {
    SFImageSource *_source;
#if SF_MACOS
    SFDisplayLink *_displayLink;
#endif
#if SF_IOS
    CADisplayLink *_displayLink;
#endif
    NSUInteger _frameCount;
    NSUInteger _frameIndex;
    NSTimeInterval _duration;
    NSTimeInterval _delayTime;
    NSCache<NSString *, SFImage *> *_caches;
}

@end

@implementation SFAnimatedImageDecoder

+ (NSCache *)decoderCache {
    static NSCache *cache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [[NSCache alloc] init];
    });

    return cache;
}

- (void)dealloc {
    [_displayLink invalidate];
}

- (instancetype)init {
    if (self = [super init]) {
#if SF_MACOS
        _displayLink = [SFDisplayLink displayLinkWithTarget:self selector:@selector(updateImageFrame:)];
#endif
#if SF_IOS
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateImageFrame:)];
        [_displayLink addToRunLoop:NSRunLoop.mainRunLoop forMode:NSDefaultRunLoopMode];
#endif
        self.paused = YES;
        _caches = [self.class decoderCache];
    }

    return self;
}

- (void)setPaused:(BOOL)paused {
    if (_displayLink.paused == paused) {
        return;
    }

    _displayLink.paused = paused;
}

- (BOOL)isPaused {
    return _displayLink.isPaused;
}

- (void)updateImageFrame:(id)displayLink {
    if (_frameCount <= 1) {
        return;
    }
#if SF_IOS
    _duration += ((CADisplayLink *)displayLink).duration;
#endif
#if SF_MACOS
    _duration += ((SFDisplayLink *)displayLink).duration;
#endif
    if (_duration < _delayTime) {
        return;
    }

    _duration = 0;

    if (_frameIndex >= _frameCount) {
        _frameIndex = 0;
    }

    SFImage *image = [self imageAtIndex:_frameIndex++];

    if (_updateImageBlock) {
        _updateImageBlock(image);
    }
}

- (SFImage *)imageAtIndex:(NSUInteger)index {
    if (!_imageData) {
        return nil;
    }

    NSString *key = [NSString stringWithFormat:@"%lu-%lu", (unsigned long)_imageData.hash, (unsigned long)index];
    SFImage *image = [_caches objectForKey:key];
    if (!image) {
        image = [_source imageAtIndex:index];
        [_caches setObject:image forKey:key];
    }

    return image;
}

- (void)setImageData:(NSData *)imageData {
    if (_imageData == imageData) {
        return;
    }

    if (!self.isPaused) {
        self.paused = YES;
    }

    _imageData = imageData.copy;
    _source = [[SFImageSource alloc] initWithData:imageData];

    _frameCount = _source.count;
    _frameIndex = 0;
    _duration = 0;
    SFImage *image = [self imageAtIndex:_frameIndex++];

    if (_updateImageBlock) {
        _updateImageBlock(image);
    }

    if (_frameCount > 1) {
        NSDictionary *frameProperty = [_source propertiesAtIndex:0];
        const BytePtr bytes = (const BytePtr)imageData.bytes;

        if (memcmp(bytes, kGIFSignature, kGIFSignatureLength) == 0) {
            NSDictionary *gifDic = frameProperty[(NSString *)kCGImagePropertyGIFDictionary];
            _delayTime = [gifDic[(NSString *)kCGImagePropertyGIFUnclampedDelayTime] floatValue];
            if (_delayTime == 0) _delayTime = [gifDic[(NSString *)kCGImagePropertyGIFDelayTime] floatValue];
        }

        if (memcmp(bytes, kAPNGSignature, kAPNGSignatureLength) == 0) {
            NSDictionary *pngDic = frameProperty[(NSString *)kCGImagePropertyPNGDictionary];
            _delayTime = [pngDic[(NSString *)kCGImagePropertyAPNGUnclampedDelayTime] floatValue];
            if (_delayTime == 0) _delayTime = [pngDic[(NSString *)kCGImagePropertyAPNGDelayTime] floatValue];
        }

        if (_delayTime == 0) _delayTime = 0.04;

        self.paused = NO;
    }
}

@end

@implementation NSObject (SFAnimatedImage)

- (void)setSf_animatedImageData:(NSData *)imageData {
    if (self.sf_animatedImageData == imageData) {
        return;
    }

    __weak typeof(self) wself = self;
    SFAnimatedImageDecoder *decoder = [[SFAnimatedImageDecoder alloc] init];
    decoder.updateImageBlock = ^(SFImage *image) {
        if ([wself respondsToSelector:@selector(setImage:)]) {
            wself.image = image;
        } else if ([wself respondsToSelector:@selector(setContents:)]) {
#if SF_IOS
            wself.contents = (__bridge id)image.CGImage;
#endif
#if SF_MACOS
            wself.contents = image;
#endif
        } else {
#if SF_IOS
            if ([self isKindOfClass:UIView.class]) {
                ((UIView *)self).layer.contents = (__bridge id)image.CGImage;
            }
#endif
#if SF_MACOS
            if ([self isKindOfClass:NSView.class]) {
                ((NSView *)self).layer.contents = image;
            }
#endif
        }
    };
    objc_setAssociatedObject(self, @selector(sf_animatedImageData), decoder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    decoder.imageData = imageData;
}

- (NSData *)sf_animatedImageData {
    SFAnimatedImageDecoder *decoder = objc_getAssociatedObject(self, @selector(sf_animatedImageData));

    return decoder.imageData;
}

@end
