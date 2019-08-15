//
//  SFImageDestination.h
//  SFFoundation
//
//  Created by vvveiii on 2019/7/26.
//  Copyright © 2019 lvv. All rights reserved.
//

@interface SFImageDestination : NSObject

@property(nonatomic, readonly) CGImageDestinationRef cgImageDestination;
@property(nonatomic, copy) NSDictionary *properties;

- (instancetype)initWithData:(NSMutableData *)data ofType:(NSString *)uti count:(NSUInteger)count;
- (instancetype)initWithPath:(NSString *)path ofType:(NSString *)uti count:(NSUInteger)count;

- (void)addImage:(CGImageRef)cgImage properties:(NSDictionary *)properties;
- (void)addImageFromSource:(CGImageSourceRef)cgImageSource index:(NSUInteger)index properties:(NSDictionary *)properties;
- (void)addImage:(CGImageRef)cgImage metaData:(CGImageMetadataRef)cgMetaData options:(NSDictionary *)options;

- (void)addAuxiliaryDataWithType:(NSString *)type info:(NSDictionary *)info IMAGEIO_AVAILABLE_STARTING(10.13, 11.0);

- (BOOL)finalizeImage;

@end
