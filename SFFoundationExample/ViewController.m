//
//  ViewController.m
//  SFFoundationExample
//
//  Created by vvveiii on 2019/6/26.
//  Copyright © 2019 lvv. All rights reserved.
//

#import "ViewController.h"
@import SFFoundation;
@import SDWebImage;

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
        [_backgroundView sd_setImageWithURL:[NSURL URLWithString:@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3987907653,720009510&fm=27&gp=0.jpg"] placeholderImage:[UIImage sf_imageWithColor:UIColor.magentaColor]];
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

    _pool = SFDispatchQueuePool.pool;

    for (NSUInteger i = 0; i < 100; i++) {
        [_pool async:^{
        }];
    }

    _sessionManager = SFURLSessionManager.manager;
    [_sessionManager getWithURL:@"https://github.com" headers:nil body:nil completion:^(NSURLRequest *request, NSURLResponse *response, NSData *data, NSError *error) {
        
    }];

    _tableView = [[TableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [_tableView registerClass:Cell.class forCellReuseIdentifier:NSStringFromClass(Cell.class)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.estimatedRowHeight = 50;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:_tableView];

//    UIAsyncLabel *asyncView = [[UIAsyncLabel alloc] initWithFrame:CGRectMake(50, 220, 50, 50)];
//    asyncView.backgroundColor = UIColor.purpleColor;
//    asyncView.textColor = UIColor.whiteColor;
//    asyncView.text = @"123";
//    [self.view addSubview:asyncView];

    _button = SFButton.button;
    _button.frame = CGRectMake(50, 120, 120, 80);
    _button.direction = SFButtonDirectionColumn;
    _button.spacing = 10;
    [_button setImage:[UIImage imageNamed:@"Expression_76"] forState:UIControlStateNormal];
    [_button setTitle:@"123456" forState:UIControlStateNormal];
    [_button setTitle:@"000000" forState:UIControlStateHighlighted];
    [_button setTitleColor:UIColor.whiteColor forState:UIControlStateHighlighted];
    [_button setBackgroundImage:[UIImage sf_imageWithColor:[UIColor sf_colorWithRGB:0x05a5ee]] forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];

    RoundButton *b = [RoundButton button];
    b.frame = CGRectMake(180, 120, 80, 80);
    [b setBackgroundImage:[UIImage imageNamed:@"test_png"] forState:UIControlStateNormal];
    [b setBackgroundImage:[UIImage sf_imageWithColor:[UIColor sf_colorWithRGB:0 alpha:0.3]] forState:UIControlStateHighlighted];
    [b addTarget:self action:@selector(testAnimate:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b];

    SFISO8601DateFormatter *df = [[SFISO8601DateFormatter alloc] init];
    df.formatOptions = SFISO8601DateFormatWithYear |
                       SFISO8601DateFormatWithMonth |
                       SFISO8601DateFormatWithDay |
                       SFISO8601DateFormatWithDashSeparatorInDate |
                       SFISO8601DateFormatWithTime |
                       SFISO8601DateFormatWithColonSeparatorInTime |
                       SFISO8601DateFormatWithFractionalSeconds |
                       SFISO8601DateFormatWithTimeZone;
    df.timeZone = [NSTimeZone systemTimeZone];

    NSDate *date = [df.copy dateFromString:@"2016-12-02T17:35:58.616+0800"];
    NSDateComponents *dc = [df.copy dateComponentsFromString:@"2016-12-02T17:35:58.616-0900"];
    NSLog(@"%@", [df stringFromDate:NSDate.date]);

    UIImage *image = [UIImage imageNamed:@"test_png"];
    CGSize imageSize = image.size;
    UIImage *cropImage = [image sf_cropRect:CGRectMake((imageSize.width - 50) * 0.5, (imageSize.height - 50) * 0.5, 50, 50)];

    _animatedImageView = [[SFView alloc] init];
    _animatedImageView.contentMode = UIViewContentModeScaleAspectFit;
    _animatedImageView.frame = CGRectMake(80, 250, 80, 80);
    [self.view addSubview:_animatedImageView];

    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(50, 64, 200, 44)];
    [self.view addSubview:searchBar];
    UITextField *searchField = [searchBar sf_getIvarValueWithName:@"_searchField"];
    searchField.placeholder = @"test";

    NSString *path = [NSBundle.mainBundle pathForResource:@"demo" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:path];
    NSData *imageData = [NSData dataWithContentsOfFile:[bundle pathForResource:@"demo" ofType:@"png"]];
    _animatedImageView.sf_animatedImageData = imageData;
    _animatedImageView.backgroundColor = UIColor.orangeColor;

    SFImageSource *is = [[SFImageSource alloc] initWithData:imageData];
    UIImage *thumb = [is thumbnailAtIndex:0 maxPixelSize:16];

    UITextField *textField = [[UITextField alloc] init];
    UILabel *placeholderLabel = [textField sf_getIvarValueWithName:@"_placeholderLabel"];
    textField.placeholder = @"x";

    NSLog(@"get ivar:%@", searchField);

    _pagingScrollView = [[SFPagingScrollView alloc] initWithFrame:self.view.bounds];
    [_pagingScrollView registerClass:ScrollCell.class forCellReuseIdentifier:NSStringFromClass(ScrollCell.class)];
    _pagingScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _pagingScrollView.dataSource = self;
    _pagingScrollView.delegate = self;
    [self.view addSubview:_pagingScrollView];

    SFMagnifierView *magnifierView = [[SFMagnifierView alloc] initWithFrame:CGRectMake(50, 100, 100, 100)];
    magnifierView.backgroundColor = [UIColor sf_colorWithRGB:0xff0000 alpha:0.3];
    magnifierView.targetView = _pagingScrollView;
    [self.view addSubview:magnifierView];
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
