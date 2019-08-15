//
//  SFImageDestination.m
//  SFFoundation
//
//  Created by vvveiii on 2019/7/26.
//  Copyright © 2019 lvv. All rights reserved.
//

#import "SFImageDestination.h"

@interface SFImageDestination () {
    CGImageDestinationRef _destination;
}

@end

@implementation SFImageDestination

- (void)dealloc {
    if (_destination) {
        CFRelease(_destination);
    }
}

- (instancetype)initWithData:(NSMutableData *)data ofType:(NSString *)uti count:(NSUInteger)count {
    if (!data || uti.length == 0 || count == 0) {
        return nil;
    }

    if (self = [super init]) {
        data = data ? : NSMutableData.data;
        _destination = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)data, (__bridge CFStringRef)uti, count, NULL);
    }

    return self;
}

- (instancetype)initWithPath:(NSString *)path ofType:(NSString *)uti count:(NSUInteger)count {
    if (path.length == 0 || uti.length == 0 || count == 0) {
        return nil;
    }

    NSURL *url = [NSURL fileURLWithPath:path];
    if (!url) {
        return nil;
    }

    if (self = [super init]) {
        _destination = CGImageDestinationCreateWithURL((__bridge CFURLRef)url, (__bridge CFStringRef)uti, count, NULL);
    }

    return self;
}

- (CGImageDestinationRef)cgImageDestination {
    return _destination;
}

- (void)addImage:(CGImageRef)cgImage properties:(NSDictionary *)properties {
    if (!_destination || !cgImage) {
        return;
    }

    CGImageDestinationAddImage(_destination, cgImage, (__bridge CFDictionaryRef)properties);
}

- (void)addImageFromSource:(CGImageSourceRef)cgImageSource index:(NSUInteger)index properties:(NSDictionary *)properties {
    if (!_destination || !cgImageSource) {
        return;
    }

    CGImageDestinationAddImageFromSource(_destination, cgImageSource, index, (__bridge CFDictionaryRef)properties);
}

- (void)addImage:(CGImageRef)cgImage metaData:(CGImageMetadataRef)cgMetaData options:(NSDictionary *)options {
    if (!_destination || !cgImage) {
        return;
    }

    CGImageDestinationAddImageAndMetadata(_destination, cgImage, cgMetaData, (__bridge CFDictionaryRef)options);
}

- (void)addAuxiliaryDataWithType:(NSString *)type info:(NSDictionary *)info {
    if (!_destination || type.length == 0 || info.count == 0) {
        return;
    }

    CGImageDestinationAddAuxiliaryDataInfo(_destination, (__bridge CFStringRef)type, (__bridge CFDictionaryRef)info);
}

- (BOOL)finalizeImage {
    if (!_destination) {
        return NO;
    }

    if (_properties.count > 0) {
        CGImageDestinationSetProperties(_destination, (__bridge CFDictionaryRef)_properties);
    }

    return (BOOL)CGImageDestinationFinalize(_destination);
}

@end
