//
//  ViewController.m
//  SFFoundationHosting
//
//  Created by v on 2019/10/24.
//  Copyright © 2019 lvv. All rights reserved.
//

#import "ViewController.h"
@import SFFoundation;

@interface ItemCell : UICollectionViewCell {
    SFBoxView *_boxView;
}

@end

@implementation ItemCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _boxView = [[SFBoxView alloc] initWithFrame:self.contentView.bounds];
        _boxView.backgroundView.backgroundColor = UIColor.whiteColor;
        _boxView.selectionView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        [_boxView setPadding:UIEdgeInsetsMake(30, 30, 30, 30)];
        [_boxView setCornerRadius:20];
        [_boxView setShadow:UIColor.blackColor offset:CGSizeMake(0, 5) blur:30 opacity:0.2];
        [self.contentView addSubview:_boxView];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    _boxView.frame = self.contentView.bounds;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    _boxView.highlighted = selected;
}

@end

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    UICollectionView *_collectionView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:({
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 30;
        layout.minimumInteritemSpacing = 30;
        layout;
    })];
    _collectionView.backgroundColor = UIColor.clearColor;
    [_collectionView registerClass:ItemCell.class forCellWithReuseIdentifier:NSStringFromClass(ItemCell.class)];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self.view addSubview:_collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10000;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(ItemCell.class) forIndexPath:indexPath];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat w = CGRectGetWidth(collectionView.bounds) - 32;

    return CGSizeMake(w, w * 1.2);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

@end
