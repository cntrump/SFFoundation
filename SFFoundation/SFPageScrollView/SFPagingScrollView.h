//
//  SFPagingScrollView.h
//  SFFoundation
//
//  Created by vvveiii on 2019/8/3.
//  Copyright © 2019 lvv. All rights reserved.
//

typedef NS_ENUM(NSInteger, SFPagingScrollAxis) {
    SFPagingScrollAxisHorizontal = 0,
    SFPagingScrollAxisVertical
};

#if SF_IOS

@interface SFPagingScrollViewCell : UIView

@property(nonatomic, readonly) NSString *identifier;
@property(nonatomic, readonly) UIView *contentView;

- (instancetype)initWithIdentifier:(NSString *)identifier;
- (void)prepareForReuse NS_REQUIRES_SUPER;

- (void)onScrollWillBegin NS_REQUIRES_SUPER;
- (void)onScrollProgress:(CGFloat)percent NS_REQUIRES_SUPER;
- (void)onScrollFinish NS_REQUIRES_SUPER;

@end

@class SFPagingScrollView;
@protocol SFPagingScrollViewDataSource <NSObject>

@optional
- (NSInteger)numberOfPagesForPagingScrollView:(SFPagingScrollView *)scrollView;
- (SFPagingScrollViewCell *)pagingScrollView:(SFPagingScrollView *)scrollView cellForIndex:(NSInteger)index;

@end

@interface SFPagingScrollView : UIScrollView

@property(nonatomic, assign) SFPagingScrollAxis axis;
@property(nonatomic, weak) id<SFPagingScrollViewDataSource> dataSource;

- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier;
- (__kindof SFPagingScrollViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;

- (void)scrollToCellAtIndex:(NSInteger)index animated:(BOOL)animated;

- (SFPagingScrollViewCell *)visiableCellAtIndex:(NSInteger)index;

- (void)reloadData;

@end

#endif
