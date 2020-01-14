//
//  SFButton.h
//  SFFoundation
//
//  Created by vvveiii on 2019/6/27.
//  Copyright © 2019 lvv. All rights reserved.
//

#if SF_IOS

typedef NS_ENUM(NSInteger, SFButtonDirection) {
    SFButtonDirectionRow = 0,
    SFButtonDirectionRowReverse,
    SFButtonDirectionColumn,
    SFButtonDirectionColumnReverse
};

@interface SFButton : UIControl

@property(nonatomic, assign) UIEdgeInsets contentInset;

@property(nonatomic, assign) CGFloat spacing;

@property(nonatomic, assign) SFButtonDirection direction;

@property(nonatomic, assign) CGSize imageSize; // custom image size, default is CGSizeZero

@property(nonatomic, strong, readonly) UIImage *currentImage;

@property(nonatomic, strong, readonly) UIImage *currentBackgroundImage;

@property(nonatomic, copy, readonly) NSString *currentTitle;

@property(nonatomic, strong, readonly) UIColor *currentTitleColor;

@property(nonatomic, copy, readonly) NSAttributedString *currentAttributedTitle;

@property(nonatomic, strong, readonly) UILabel *titleLabel;

@property(nonatomic, strong, readonly) UIImageView *imageView;

@property(nonatomic, strong, readonly) UIImageView *backgroundImageView;

@property(nonatomic, copy) void (^onStateBlock)(SFButton*);


+ (instancetype)button;

+ (Class)imageViewClass;

+ (Class)backgroundImageViewClass;

- (void)setImage:(UIImage *)image forState:(UIControlState)state;

- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state;

- (void)setTitle:(NSString *)title forState:(UIControlState)state;

- (void)setTitleColor:(UIColor *)titleColor forState:(UIControlState)state;

- (void)setAttributedTitle:(NSAttributedString *)attributedTitle forState:(UIControlState)state;

@end

#endif
