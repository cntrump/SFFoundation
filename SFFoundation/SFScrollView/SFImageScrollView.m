//
//  SFScrollImageView.m
//  SFFoundation
//
//  Created by vvveiii on 2019/8/10.
//  Copyright © 2019 lvv. All rights reserved.
//

#import "SFImageScrollView.h"
#import "SFDelegateForwarder.h"

#if SF_IOS

@interface SFImageScrollView () <UIScrollViewDelegate> {
    SFDelegateForwarder *_delegateForwarder;
    CGFloat _widthScale, _heightScale;
    CGSize _imageSize;
    CGSize _boundsSize;
    UITapGestureRecognizer *_doubleTap;
}

@end

@implementation SFImageScrollView

+ (Class)imageViewClass {
    return UIImageView.class;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _imageView = [[self.class.imageViewClass alloc] initWithFrame:CGRectZero];
        [self addSubview:_imageView];

        self.delegate = self;
        self.doubleTapZoom = YES;
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect bounds = self.bounds;
    if (!CGSizeEqualToSize(_boundsSize, bounds.size)) {
        _boundsSize = bounds.size;
        [self zoomImageView];
    }
}

- (id<UIScrollViewDelegate>)delegate {
    return _delegateForwarder.externalDelegate;
}

- (void)setDelegate:(id<UIScrollViewDelegate>)delegate {
    if (!delegate) {
        _delegateForwarder = nil;
    } else {
        _delegateForwarder = [[SFDelegateForwarder alloc] initWithInternalDelegate:self externalDelegate:delegate];
    }

    super.delegate = (id<UIScrollViewDelegate>)_delegateForwarder;
}

- (void)setContentInset:(UIEdgeInsets)contentInset {
    super.contentInset = contentInset;

    [self centerImageView];
}

- (void)adjustedContentInsetDidChange {
    [super adjustedContentInsetDidChange];

    [self centerImageView];
}

- (void)setDoubleTapZoom:(BOOL)doubleTapZoom {
    _doubleTapZoom = doubleTapZoom;

    if (!_doubleTap) {
        _doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
        _doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:_doubleTap];
        [self.panGestureRecognizer requireGestureRecognizerToFail:_doubleTap];
    }

    _doubleTap.enabled = doubleTapZoom;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    _imageSize = image.size;
    _imageView.image = image;
    _imageView.bounds = CGRectMake(0, 0, _imageSize.width, _imageSize.height);

    [self zoomImageView];
    [self centerImageView];
}

- (void)centerImageView {
    CGRect bounds = self.bounds;
    CGSize contentSize = self.contentSize;

    UIEdgeInsets inset;
    if (@available(iOS 11.0, *)) {
        inset = self.adjustedContentInset;
    } else {
        inset = self.contentInset;
    }

    CGFloat w = CGRectGetWidth(bounds) - (inset.left + inset.right), h = CGRectGetHeight(bounds) - (inset.top + inset.bottom);
    CGFloat fx = w > contentSize.width ? (w - contentSize.width) * 0.5 : 0;
    CGFloat fy = h > contentSize.height ? (h - contentSize.height) * 0.5 : 0;

    CGFloat centerX = contentSize.width * 0.5 + fx;
    CGFloat centerY = contentSize.height * 0.5 + fy;
    _imageView.center = CGPointMake(centerX, centerY);
}

- (void)zoomImageView {
    CGRect bounds = self.bounds;

    CGFloat w = CGRectGetWidth(bounds), h = CGRectGetHeight(bounds);

    _widthScale = _imageSize.width > 0 ? w / _imageSize.width : 1;
    _heightScale = _imageSize.height > 0 ? h / _imageSize.height : 1;

    CGFloat minScale = MIN(_widthScale, _heightScale);
    CGFloat maxScale = MAX(_widthScale, _heightScale);

    self.minimumZoomScale = minScale * 0.5;
    self.maximumZoomScale = maxScale * 5;
    self.zoomScale = _widthScale;
}

#pragma mark - delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self centerImageView];
}

#pragma mark -

- (void)doubleTapAction:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded && !self.isZooming) {
        CGFloat scale = self.zoomScale;
        if (scale == _widthScale) {
            CGFloat maxScale = MAX(_widthScale, _heightScale) * 2;
            CGPoint p = [sender locationInView:_imageView];
            CGRect rect = [self zoomRectAtCenter:p scale:maxScale];
            [self zoomToRect:rect animated:YES];
        } else {
            [self setZoomScale:_widthScale animated:YES];
        }
    }
}

- (CGRect)zoomRectAtCenter:(CGPoint)center scale:(CGFloat)scale {
    CGRect bounds = self.bounds;
    CGFloat w = CGRectGetWidth(bounds) / scale, h = CGRectGetHeight(bounds) / scale;
    CGFloat x = center.x - w * 0.5, y = center.y - h * 0.5;
    CGRect rect = CGRectMake(x, y, w, h);

    return rect;
}

@end
#endif
