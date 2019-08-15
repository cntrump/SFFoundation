//
//  SFImageSource.m
//  SFFoundation
//
//  Created by vvveiii on 2019/7/22.
//  Copyright © 2019 lvv. All rights reserved.
//

#import "SFImageSource.h"

@interface SFImageSource ()

@property(nonatomic, assign) CGImageSourceRef source;

@end

@implementation SFImageSource

- (void)dealloc {
    if (_source) {
        CFRelease(_source);
    }
}

- (instancetype)initWithData:(NSData *)data {
    if (!data) {
        return nil;
    }

    if (self = [super init]) {
        _source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
        if (_source) {
            _count = CGImageSourceGetCount(_source);
        }
    }

    return self;
}

- (instancetype)initWithPath:(NSString *)path {
    if (path.length == 0) {
        return nil;
    }

    NSURL *url = [NSURL fileURLWithPath:path];
    if (!url) {
        return nil;
    }

    if (self = [super init]) {
        _source = CGImageSourceCreateWithURL((__bridge CFURLRef)url, NULL);
        if (_source) {
            _count = CGImageSourceGetCount(_source);
        }
    }

    return self;
}

- (CGImageSourceRef)cgImageSource {
    return _source;
}

- (SFImage *)thumbnailAtIndex:(NSUInteger)index maxPixelSize:(CGFloat)pixelSize {
    if (!_source || index >= _count || pixelSize < 1) {
        return nil;
    }

    SFImage *image = nil;
    NSDictionary *options = @{
                              (NSString *)kCGImageSourceThumbnailMaxPixelSize: @(pixelSize),
                              (NSString *)kCGImageSourceCreateThumbnailFromImageIfAbsent: (NSNumber *)kCFBooleanTrue,
                              (NSString *)kCGImageSourceCreateThumbnailFromImageAlways: (NSNumber *)kCFBooleanTrue,
                              (NSString *)kCGImageSourceCreateThumbnailWithTransform: (NSNumber *)kCFBooleanTrue
                              };
    CGImageRef cgImage = CGImageSourceCreateThumbnailAtIndex(_source, index, (__bridge CFDictionaryRef)options);
    if (cgImage) {
#if SF_IOS
        image = [[SFImage alloc] initWithCGImage:cgImage];
#endif
#if SF_MACOS
        image = [[SFImage alloc] initWithCGImage:cgImage size:NSZeroSize];
#endif
        CGImageRelease(cgImage);
    }

    return image;
}

- (SFImage *)imageAtIndex:(NSUInteger)index {
    if (!_source || index >= _count) {
        return nil;
    }

    SFImage *image = nil;
    NSDictionary *options = @{
                              (NSString *)kCGImageSourceShouldCache: (NSNumber *)kCFBooleanTrue,
                              (NSString *)kCGImageSourceShouldCacheImmediately: (NSNumber *)kCFBooleanTrue
                              };
    CGImageRef cgImage = CGImageSourceCreateImageAtIndex(_source, index, (__bridge CFDictionaryRef)options);
    if (cgImage) {
#if SF_IOS
        image = [[SFImage alloc] initWithCGImage:cgImage];
#endif
#if SF_MACOS
        image = [[SFImage alloc] initWithCGImage:cgImage size:NSZeroSize];
#endif
        CGImageRelease(cgImage);
    }

    return image;
}

- (NSDictionary *)propertiesAtIndex:(NSUInteger)index {
    if (!_source || index >= _count) {
        return nil;
    }

    CFDictionaryRef properties = CGImageSourceCopyPropertiesAtIndex(_source, index, NULL);

    return (__bridge_transfer NSDictionary *)properties;
}

- (NSArray *)metadataAtIndex:(NSUInteger)index {
    if (!_source || index >= _count) {
        return nil;
    }

    NSArray *tags = nil;
    CGImageMetadataRef metadata = CGImageSourceCopyMetadataAtIndex(_source, index, NULL);
    if (metadata) {
        tags = (__bridge_transfer NSArray *)CGImageMetadataCopyTags(metadata);
    }

    return tags;
}

- (NSDictionary *)auxiliaryDataInfoAtIndex:(NSUInteger)index imageDataType:(NSString *)auxiliaryImageDataType {
    if (!_source || index >= _count) {
        return nil;
    }

    CFDictionaryRef auxiliaryDataInfo = CGImageSourceCopyAuxiliaryDataInfoAtIndex(_source, index, (CFStringRef)auxiliaryImageDataType);

    return (__bridge_transfer NSDictionary *)auxiliaryDataInfo;
}

@end
