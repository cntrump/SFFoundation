//
//  SFImageSource.h
//  SFFoundation
//
//  Created by vvveiii on 2019/7/22.
//  Copyright © 2019 lvv. All rights reserved.
//

@interface SFImageSource : NSObject

@property(nonatomic, readonly) CGImageSourceRef cgImageSource;
@property(nonatomic, assign, readonly) NSUInteger count;

- (instancetype)initWithData:(NSData *)data;
- (instancetype)initWithPath:(NSString *)path;

- (SFImage *)thumbnailAtIndex:(NSUInteger)index maxPixelSize:(CGFloat)pixelSize;
- (SFImage *)imageAtIndex:(NSUInteger)index;
- (NSDictionary *)propertiesAtIndex:(NSUInteger)index;
- (NSArray *)metadataAtIndex:(NSUInteger)index;
- (NSDictionary *)auxiliaryDataInfoAtIndex:(NSUInteger)index imageDataType:(NSString *)auxiliaryImageDataType IMAGEIO_AVAILABLE_STARTING(10.13, 11.0);

@end
