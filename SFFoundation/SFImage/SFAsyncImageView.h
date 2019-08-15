//
//  SFAsyncImageView.h
//  SFFoundation
//
//  Created by vvveiii on 2019/7/22.
//  Copyright © 2019 lvv. All rights reserved.
//

#import "SFView.h"

@interface SFAsyncImageView : SFAsyncView

@property(nonatomic, strong) SFImage *image;

- (instancetype)initWithImage:(SFImage *)image;

@end
