//
//  ViewController.m
//  SFFoundationExample
//
//  Created by vvveiii on 2019/6/26.
//  Copyright © 2019 lvv. All rights reserved.
//

#import "ViewController.h"
@import SFFoundation;

@interface ScrollCell : SFPagingScrollViewCell {
    SFImageScrollView *_aniView;
}

@end

@implementation ScrollCell

- (instancetype)initWithIdentifier:(NSString *)identifier {
    if (self = [super initWithIdentifier:identifier]) {
        self.contentView.backgroundColor = UIColor.orangeColor;
        _aniView = [[SFImageScrollView alloc] init];
        _aniView.image = [UIImage imageNamed:@"test_png"];
        _aniView.backgroundColor = UIColor.brownColor;
        [self.contentView addSubview:_aniView];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    _aniView.frame = self.contentView.bounds;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    _aniView.transform = CGAffineTransformIdentity;
}

- (void)onScrollProgress:(CGFloat)percent {
    [super onScrollProgress:percent];
    _aniView.transform = CGAffineTransformMakeScale(0.5 + 0.5 *percent, 0.5 + 0.5 *percent);
}

@end

@interface TableView : UITableView {
    SFDelegateForwarder *_delegateForwarder;
}

@end

@implementation TableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {

    }

    return self;
}

- (id<UITableViewDelegate>)delegate {
    return _delegateForwarder.externalDelegate;
}

- (void)setDelegate:(id<UITableViewDelegate>)delegate {
    if (delegate) {
        _delegateForwarder = [[SFDelegateForwarder alloc] initWithInternalDelegate:self externalDelegate:delegate];
    } else {
        _delegateForwarder = nil;
    }

    super.delegate = (id<UITableViewDelegate>)_delegateForwarder;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"%@", NSStringFromClass(self.class));
}

@end

@interface PopViewController : UIViewController

@end

@implementation PopViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"dismiss" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor sf_colorWithRGB:0x4890ef] forState:UIControlStateNormal];
    button.frame = CGRectMake(50, 80, 80, 35);
    [button addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)action:(id)sender {
    [self sf_dismissViewControllerAnimated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.presentingViewController.preferredStatusBarStyle;
}

@end

@interface RoundButton : SFButton

@property(nonatomic, strong, readonly) SFImageView *backgroundImageView;

@end

@implementation RoundButton

+ (Class)backgroundImageViewClass {
    return SFImageView.class;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.backgroundImageView.cornerRadius = INFINITY;
    }

    return self;
}

@end

@interface UIAsyncLabelContext : NSObject

@property(nonatomic, copy) UIColor *backgroundColor;
@property(nonatomic, copy) NSAttributedString *attributedText;
@property(nonatomic, assign) NSUInteger numberOfLines;
@property(nonatomic, assign) NSLineBreakMode lineBreakMode;

@property(nonatomic, copy) NSAttributedString *truncationAttributedText;

@end

@implementation UIAsyncLabelContext

@end

@interface UIAsyncLabel : UILabel {

}

@end

@implementation UIAsyncLabel

+ (Class)layerClass {
    return SFAsyncLayer.class;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentScaleFactor = UIScreen.mainScreen.scale;
    }

    return self;
}

- (UIAsyncLabelContext *)drawParametersInAsyncLayer:(SFAsyncLayer * _Nonnull)layer {
    UIAsyncLabelContext *context = [[UIAsyncLabelContext alloc] init];
    context.backgroundColor = self.backgroundColor;
    context.numberOfLines = self.numberOfLines;
    context.lineBreakMode = self.lineBreakMode;
    context.attributedText = self.attributedText;
    context.lineBreakMode = self.lineBreakMode;

    return context;
}

- (void)asyncLayer:(SFAsyncLayer * _Nonnull)layer drawInContext:(CGContextRef _Nonnull)context bounds:(CGRect)bounds
        parameters:(UIAsyncLabelContext *)parameters renderSynchronously:(BOOL)renderSynchronously {
    [parameters.backgroundColor setFill];
    UIRectFill(bounds);

    SFTextKitContext *textKitContext = [SFTextKitContext contextWithSize:bounds.size attributedText:parameters.attributedText];
    [textKitContext performWithBlock:^(NSLayoutManager *layoutManager, NSTextContainer *textContainer, NSTextStorage *textStorage) {
        textContainer.lineBreakMode = parameters.lineBreakMode;
        textContainer.maximumNumberOfLines = parameters.numberOfLines;
        NSRange glyphRange = [layoutManager glyphRangeForTextContainer:textContainer];
        [layoutManager drawBackgroundForGlyphRange:glyphRange atPoint:CGPointZero];
        [layoutManager drawGlyphsForGlyphRange:glyphRange atPoint:CGPointZero];
    }];
}

@end

@interface Cell : UITableViewCell {
    UIAsyncLabel *_label;
    SFAsyncImageView *_backgroundView;
}

@end

@implementation Cell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _backgroundView = [[SFAsyncImageView alloc] initWithImage:[UIImage sf_imageWithColor:UIColor.orangeColor]];
        [self.contentView addSubview:_backgroundView];
        _backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addConstraints:@[
                                           [NSLayoutConstraint constraintWithItem:_backgroundView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:0],
                                           [NSLayoutConstraint constraintWithItem:_backgroundView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:0],
                                           [NSLayoutConstraint constraintWithItem:_backgroundView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0],
                                           [NSLayoutConstraint constraintWithItem:_backgroundView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:0]
                                           ]];

        _label = [[UIAsyncLabel alloc] init];
        _label.lineBreakMode = NSLineBreakByWordWrapping;
        _label.numberOfLines = 0;
        _label.font = [UIFont systemFontOfSize:15];
        _label.textColor = UIColor.whiteColor;
        _label.text = @"Yoga builds with buck. Make sure you install buck before contributing to Yoga. Yoga's main implementation is in C, with bindings to supported languages and frameworks. When making changes to Yoga please ensure the changes are also propagated to these bindings when applicable.";
        [self.contentView addSubview:_label];
        _label.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addConstraints:@[
                                           [NSLayoutConstraint constraintWithItem:_label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:0],
                                           [NSLayoutConstraint constraintWithItem:_label attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:0],
                                           [NSLayoutConstraint constraintWithItem:_label attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0],
                                           [NSLayoutConstraint constraintWithItem:_label attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:0]
                                           ]];
    }

    return self;
}

@end

@interface TextContainerView : UIView {
    SFTextSelectionView *_textSelectionView;
}

@property(nonatomic, readonly) SFTextKitContext *context;

@end

@implementation TextContainerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.whiteColor;
        
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
                                                                         attributes:@{
                                                                                      NSFontAttributeName: [UIFont systemFontOfSize:17],
                                                                                      NSForegroundColorAttributeName: UIColor.orangeColor
                                                                                      }];
        _context = [[SFTextKitContext alloc] initWithSize:self.bounds.size attributedText:attrString];

        _textSelectionView = [[SFTextSelectionView alloc] initWithFrame:self.bounds
                                                                                textContext:_context
                                                                              selectedRange:NSMakeRange(30, 1)
                                                                                     origin:CGPointMake(25, 25)];
        [self addSubview:_textSelectionView];
    }

    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    CGSize size = CGSizeMake(CGRectGetWidth(rect) - 30, CGRectGetHeight(rect) - 30);
    CGPoint start = CGPointMake(15, 15);
    [_context performWithBlock:^(NSLayoutManager *layoutManager, NSTextContainer *textContainer, NSTextStorage *textStorage) {
        textContainer.size = size;
        NSRange glyphRange = [layoutManager glyphRangeForTextContainer:textContainer];
        [layoutManager drawBackgroundForGlyphRange:glyphRange atPoint:start];
        [layoutManager drawGlyphsForGlyphRange:glyphRange atPoint:start];
    }];

    _textSelectionView.origin = start;
    _textSelectionView.size = size;
}

@end

@interface SFUILabel : UILabel

@end

@implementation SFUILabel

- (NSAttributedString *)attributedText {
    NSAttributedString *attributedText = super.attributedText;

    return attributedText;
}

@end

#pragma mark - ViewController

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, SFPagingScrollViewDataSource, UIScrollViewDelegate> {
    SFURLSessionManager *_sessionManager;
    SFDispatchQueuePool *_pool;

    SFButton *_button;
    SFView *_animatedImageView;
    TableView *_tableView;
    SFPagingScrollView *_pagingScrollView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"push" style:UIBarButtonItemStylePlain target:self action:@selector(push:)];

    SFUILabel *label = [[SFUILabel alloc] init];
    label.font = [UIFont systemFontOfSize:19];
    label.textColor = UIColor.purpleColor;
    label.text = @"123";
    [self.view addSubview:label];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:@[
                                [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:20],
                                [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:20],
                                [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:120]
                                ]];

    NSLog(@"%@", label.attributedText);

    TextContainerView *textView = [[TextContainerView alloc] initWithFrame:CGRectMake(50, 100, 180, 150)];
    [self.view addSubview:textView];
}

- (void)push:(id)sender {
    [self.navigationController pushViewController:[[UIViewController alloc] init] animated:YES];
}

- (void)buttonAction:(SFButton *)sender {
    [SFOverlayWindow.window presentViewController:[[PopViewController alloc] init] animated:YES completion:nil];
}

- (void)testAnimate:(id)sender {
    CGRect frame = _animatedImageView.frame;
    if (CGSizeEqualToSize(frame.size, CGSizeMake(80, 80))) {
        frame = SFRectScale(frame, 2);
    } else {
        frame = SFRectScale(frame, 0.5);
    }

    [UIView animateWithDuration:0.4 animations:^{
        _animatedImageView.frame = frame;
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"%@", NSStringFromClass(self.class));

    if (scrollView == _pagingScrollView) {
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Cell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(Cell.class) forIndexPath:indexPath];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1000;
}

#pragma mark -

- (NSInteger)numberOfPagesForPagingScrollView:(SFPagingScrollView *)scrollView {
    return 5;
}

- (SFPagingScrollViewCell *)pagingScrollView:(SFPagingScrollView *)scrollView cellForIndex:(NSInteger)index {
    ScrollCell *cell = [scrollView dequeueReusableCellWithIdentifier:NSStringFromClass(ScrollCell.class)];
    cell.contentView.backgroundColor = index % 2 == 0 ? UIColor.orangeColor : UIColor.purpleColor;

    return cell;
}

@end
