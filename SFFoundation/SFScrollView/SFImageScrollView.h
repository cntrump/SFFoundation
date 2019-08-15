//
//  SFImageScrollView.h
//  SFFoundation
//
//  Created by vvveiii on 2019/8/10.
//  Copyright © 2019 lvv. All rights reserved.
//

#if SF_IOS
@interface SFImageScrollView : UIScrollView

+ (Class)imageViewClass; // default is UIImageView

@property(nonatomic, readonly) UIImageView *imageView;

@property(nonatomic, strong) UIImage *image;

@property(nonatomic, assign) BOOL doubleTapZoom;    // enable double-tap zoom image, default is YES

@end
#endif
