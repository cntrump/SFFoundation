//
//  SFButton.m
//  SFFoundation
//
//  Created by vvveiii on 2019/6/27.
//  Copyright © 2019 lvv. All rights reserved.
//

#import "SFButton.h"
#import "SFColor.h"

#if SF_IOS

@interface SFButtonAttributes : NSObject

@property(nonatomic, strong) UIImage *image;
@property(nonatomic, strong) UIImage *backgroundImage;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, strong) UIColor *titleColor;
@property(nonatomic, copy) NSAttributedString *attributedTitle;

@end

@implementation SFButtonAttributes

@end

#pragma mark -

@interface SFButton () {
    NSMutableDictionary<NSNumber*, SFButtonAttributes*> *_map;
    NSMutableArray<UIAccessibilityElement *> *_accessibleElements;
}

@end

@implementation SFButton

+ (instancetype)button {
    return [[self alloc] init];
}

+ (Class)imageViewClass {
    return UIImageView.class;
}

+ (Class)backgroundImageViewClass {
    return UIImageView.class;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _map = NSMutableDictionary.dictionary;

        _backgroundImageView = [[self.class.backgroundImageViewClass alloc] initWithFrame:self.bounds];
        [self addSubview:_backgroundImageView];

        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor sf_colorWithRGB:0 alpha:0.85];
        [self addSubview:_titleLabel];

        _imageView = [[self.class.imageViewClass alloc] init];
        [self addSubview:_imageView];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    _backgroundImageView.frame = self.bounds;

    CGRect titleLabelFrame = CGRectZero;
    CGRect imageViewFrame = CGRectZero;
    BOOL hasImage = NO, hasTitle = NO;

    if (self.currentImage) {
        [_imageView sizeToFit];
        imageViewFrame = (_imageSize.width > 0 && _imageSize.height > 0) ? CGRectMake(0, 0, _imageSize.width, _imageSize.height) : _imageView.frame;
        hasImage = YES;
    }

    if (self.currentTitle || self.currentAttributedTitle) {
        CGFloat maxWidth = CGRectGetWidth(self.bounds) - (_contentInset.left + _contentInset.right) - (hasImage ? CGRectGetWidth(imageViewFrame) + _spacing : 0);
        CGSize titleSize = [_titleLabel sizeThatFits:CGSizeMake(maxWidth, INFINITY)];
        titleLabelFrame = CGRectMake(0, 0, titleSize.width, titleSize.height);
        hasTitle = YES;
    }

    CGFloat offset = (hasImage && hasTitle ? _spacing : 0);

    CGFloat w = 0, h = 0;

    switch (_direction) {
    case SFButtonDirectionRow:
            w = CGRectGetWidth(titleLabelFrame) + CGRectGetWidth(imageViewFrame) + offset;
            imageViewFrame.origin.x = CGRectGetMidX(self.bounds) - w * 0.5 - (_contentInset.right - _contentInset.left) * 0.5;
            titleLabelFrame.origin.x = CGRectGetMaxX(imageViewFrame) + offset;
            imageViewFrame.origin.y = CGRectGetMidY(self.bounds) - CGRectGetHeight(imageViewFrame) * 0.5 - (_contentInset.bottom - _contentInset.top) * 0.5;
            titleLabelFrame.origin.y = CGRectGetMidY(self.bounds) - CGRectGetHeight(titleLabelFrame) * 0.5 - (_contentInset.bottom - _contentInset.top) * 0.5;
            break;

    case SFButtonDirectionRowReverse:
            w = CGRectGetWidth(titleLabelFrame) + CGRectGetWidth(imageViewFrame) + offset;
            titleLabelFrame.origin.x = CGRectGetMidX(self.bounds) - w * 0.5 - (_contentInset.right - _contentInset.left) * 0.5;
            imageViewFrame.origin.x = CGRectGetMaxX(titleLabelFrame) + offset;
            titleLabelFrame.origin.y = CGRectGetMidY(self.bounds) - CGRectGetHeight(titleLabelFrame) * 0.5 - (_contentInset.bottom - _contentInset.top) * 0.5;
            imageViewFrame.origin.y = CGRectGetMidY(self.bounds) - CGRectGetHeight(imageViewFrame) * 0.5 - (_contentInset.bottom - _contentInset.top) * 0.5;
            break;

    case SFButtonDirectionColumn:
            h = CGRectGetHeight(titleLabelFrame) + CGRectGetHeight(imageViewFrame) + offset;
            imageViewFrame.origin.y = CGRectGetMidY(self.bounds) - h * 0.5 - (_contentInset.bottom - _contentInset.top) * 0.5;
            titleLabelFrame.origin.y = CGRectGetMaxY(imageViewFrame) + offset;
            imageViewFrame.origin.x = CGRectGetMidX(self.bounds) - CGRectGetWidth(imageViewFrame) * 0.5 - (_contentInset.right - _contentInset.left) * 0.5;
            titleLabelFrame.origin.x = CGRectGetMidX(self.bounds) - CGRectGetWidth(titleLabelFrame) * 0.5 - (_contentInset.right - _contentInset.left) * 0.5;
            break;

    case SFButtonDirectionColumnReverse:
            h = CGRectGetHeight(titleLabelFrame) + CGRectGetHeight(imageViewFrame) + offset;
            titleLabelFrame.origin.y = CGRectGetMidY(self.bounds) - h * 0.5 - (_contentInset.bottom - _contentInset.top) * 0.5;
            imageViewFrame.origin.y = CGRectGetMaxY(titleLabelFrame) + offset;
            titleLabelFrame.origin.x = CGRectGetMidX(self.bounds) - CGRectGetWidth(titleLabelFrame) * 0.5 - (_contentInset.right - _contentInset.left) * 0.5;
            imageViewFrame.origin.x = CGRectGetMidX(self.bounds) - CGRectGetWidth(imageViewFrame) * 0.5 - (_contentInset.right - _contentInset.left) * 0.5;
            break;

    default:
            return;
    }

    _titleLabel.frame = titleLabelFrame;
    _imageView.frame = imageViewFrame;
}

- (CGSize)intrinsicContentSize {
    BOOL hasImage = NO, hasTitle = NO;
    CGRect imageViewFrame = CGRectZero, titleLabelFrame = CGRectZero;

    if (self.currentImage) {
        CGSize size = (_imageSize.width > 0 && _imageSize.height > 0) ? _imageSize : [_imageView sizeThatFits:CGSizeMake(INFINITY, INFINITY)];
        imageViewFrame = CGRectMake(0, 0, size.width, size.height);
        hasImage = YES;
    }

    if (self.currentTitle || self.currentAttributedTitle) {
        CGSize size = [_titleLabel sizeThatFits:CGSizeMake(INFINITY, INFINITY)];
        titleLabelFrame = CGRectMake(0, 0, size.width, size.height);
        hasTitle = YES;
    }

    CGFloat offset = (hasImage && hasTitle ? _spacing : 0);
    CGFloat w = 0, h = 0;

    switch (_direction) {
    case SFButtonDirectionRow:
    case SFButtonDirectionRowReverse:
            w = CGRectGetWidth(titleLabelFrame) + CGRectGetWidth(imageViewFrame) + offset;
            h = MAX(CGRectGetHeight(titleLabelFrame), CGRectGetHeight(imageViewFrame));
            break;

    case SFButtonDirectionColumn:
    case SFButtonDirectionColumnReverse:
            h = CGRectGetHeight(titleLabelFrame) + CGRectGetHeight(imageViewFrame) + offset;
            w = MAX(CGRectGetWidth(titleLabelFrame), CGRectGetWidth(imageViewFrame));
            break;

    default:
            return CGSizeZero;
    }

    return CGSizeMake(w + _contentInset.left + _contentInset.right,
                      h + _contentInset.top + _contentInset.bottom);
}

- (CGSize)sizeThatFits:(CGSize)size {
    return self.intrinsicContentSize;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint pt = [touch locationInView:self];
    if (CGRectContainsPoint(self.bounds, pt)) {
        return YES;
    }

    [self cancelTrackingWithEvent:event];

    return NO;
}

- (void)setEnabled:(BOOL)enabled {
    super.enabled = enabled;
    [self updateCurrentState];

    if (_onStateBlock) {
        _onStateBlock(self);
    }
}

- (void)setSelected:(BOOL)selected {
    super.selected = selected;
    [self updateCurrentState];

    if (_onStateBlock) {
        _onStateBlock(self);
    }
}

- (void)setHighlighted:(BOOL)highlighted {
    super.highlighted = highlighted;
    [self updateCurrentState];

    if (_onStateBlock) {
        _onStateBlock(self);
    }
}

- (void)setSpacing:(CGFloat)spacing {
    _spacing = spacing;
    if ((self.currentTitle || self.currentAttributedTitle) && self.currentImage) {
        [self invalidateLayout];
    }
}

- (void)setDirection:(SFButtonDirection)direction {
    _direction = direction;
    if ((self.currentTitle || self.currentAttributedTitle) && self.currentImage) {
        [self invalidateLayout];
    }
}

#pragma mark -

- (UIImage *)currentImage {
    SFButtonAttributes *attrs = [self attributesForState:self.state];

    return attrs.image ? : [self attributesForState:UIControlStateNormal].image;
}

- (UIImage *)currentBackgroundImage {
    SFButtonAttributes *attrs = [self attributesForState:self.state];

    return attrs.backgroundImage ? : [self attributesForState:UIControlStateNormal].backgroundImage;
}

- (NSString *)currentTitle {
    SFButtonAttributes *attrs = [self attributesForState:self.state];
    NSString *title = attrs.title ? : [self attributesForState:UIControlStateNormal].title;

    UIAccessibilityElement *element = [self accessibilityElementAtIndex:0];
    element.accessibilityValue = title;

    return title;
}

- (UIColor *)currentTitleColor {
    SFButtonAttributes *attrs = [self attributesForState:self.state];

    return attrs.titleColor ? : [self attributesForState:UIControlStateNormal].titleColor;
}

- (NSAttributedString *)currentAttributedTitle {
    SFButtonAttributes *attrs = [self attributesForState:self.state];
    NSAttributedString *attributedTitle = attrs.attributedTitle ? : [self attributesForState:UIControlStateNormal].attributedTitle;

    UIAccessibilityElement *element = [self accessibilityElementAtIndex:0];
    element.accessibilityValue = attributedTitle.string;

    return attributedTitle;
}

- (void)updateCurrentState {
    _backgroundImageView.image = self.currentBackgroundImage;
    _imageView.image = self.currentImage;

    if (self.currentTitle) {
        _titleLabel.text = self.currentTitle;
        _titleLabel.textColor = self.currentTitleColor;
    } else if (self.currentAttributedTitle) {
        _titleLabel.attributedText = self.currentAttributedTitle;
    }

    [self invalidateLayout];
}

- (SFButtonAttributes *)attributesForState:(UIControlState)state {
    SFButtonAttributes *attrs = _map[@(state)];
    if (!attrs) {
        attrs = [[SFButtonAttributes alloc] init];
        _map[@(state)] = attrs;
    }

    return attrs;
}

- (void)invalidateLayout {
    [self invalidateIntrinsicContentSize];
    [self setNeedsLayout];
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state {
    SFButtonAttributes *attrs = [self attributesForState:state];
    attrs.image = image;
    _imageView.image = self.currentImage;
    [self invalidateLayout];
}

- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state {
    SFButtonAttributes *attrs = [self attributesForState:state];
    attrs.backgroundImage = image;
    _backgroundImageView.image = self.currentBackgroundImage;
    [self invalidateLayout];
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    SFButtonAttributes *attrs = [self attributesForState:state];
    attrs.title = title;
    _titleLabel.text = self.currentTitle;
    [self invalidateLayout];
}

- (void)setTitleColor:(UIColor *)titleColor forState:(UIControlState)state {
    SFButtonAttributes *attrs = [self attributesForState:state];
    attrs.titleColor = titleColor;
    _titleLabel.textColor = self.currentTitleColor;
    [self invalidateLayout];
}

- (void)setAttributedTitle:(NSAttributedString *)attributedTitle forState:(UIControlState)state {
    SFButtonAttributes *attrs = [self attributesForState:state];
    attrs.attributedTitle = attributedTitle;
    _titleLabel.attributedText = self.currentAttributedTitle;
    [self invalidateLayout];
}

#pragma mark - UIAccessibility

- (NSArray *)accessibleElements {
    if (!_accessibleElements) {
        _accessibleElements = NSMutableArray.array;

        UIAccessibilityElement *element = [[UIAccessibilityElement alloc] initWithAccessibilityContainer:self];
        element.accessibilityTraits = UIAccessibilityTraitButton;
        [_accessibleElements addObject:element];
    }

    _accessibleElements.firstObject.accessibilityFrame = [self.superview convertRect:self.frame toView:nil];

    return _accessibleElements;
}

- (BOOL)isAccessibilityElement {
    return NO;
}

- (NSInteger)accessibilityElementCount {
    return [[self accessibleElements] count];
}

- (id)accessibilityElementAtIndex:(NSInteger)index {
    return [[self accessibleElements] objectAtIndex:index];
}

- (NSInteger)indexOfAccessibilityElement:(id)element {
    return [[self accessibleElements] indexOfObject:element];
}

@end

#endif
