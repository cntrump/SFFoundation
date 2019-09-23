//
//  SFPageScrollView.m
//  SFFoundation
//
//  Created by vvveiii on 2019/8/3.
//  Copyright © 2019 lvv. All rights reserved.
//

#import "SFPagingScrollView.h"
#import "SFDelegateForwarder.h"

#if SF_IOS

@implementation SFPagingScrollViewCell

- (instancetype)initWithIdentifier:(NSString *)identifier {
    if (self = [self initWithFrame:CGRectMake(0, 0, 320, 44)]) {
        _identifier = identifier.copy;
    }

    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _contentView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:_contentView];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self layoutContentView];
}

- (void)prepareForReuse {
    [self layoutContentView];
}

- (void)onScrollWillBegin {
}

- (void)onScrollProgress:(CGFloat)percent {
}

- (void)onScrollFinish {
}

- (void)layoutContentView {
    CGRect frame = self.bounds;
    //    if (@available(iOS 11.0, *)) {
    //        UIEdgeInsets inset = self.safeAreaInsets;
    //        frame.origin.x = inset.left;
    //        frame.size.width -= inset.left + inset.right;
    //        frame.origin.y = inset.top;
    //        frame.size.height -= inset.top + inset.bottom;
    //    }

    _contentView.transform = CGAffineTransformIdentity;
    _contentView.frame = frame;
}

@end

#pragma mark - SFPagingScrollView

@interface SFPagingScrollView () <UIScrollViewDelegate> {
    SFDelegateForwarder *_delegateForwarder;
    CGPoint _offset;
    CGRect _frame;
    NSMutableDictionary<NSString*, Class> *_cellClassTable;
    NSMutableDictionary<NSString*, NSMutableSet<SFPagingScrollViewCell*> *> *_reusableCellTable;
    NSMutableArray<SFPagingScrollViewCell*> *_visiableCells;
    NSInteger _startVisiableIndex, _endVisiableIndex;
    NSInteger _numberOfPages;
}

@property(nonatomic, readonly) NSInteger numberOfPages;

@end

@implementation SFPagingScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _cellClassTable = NSMutableDictionary.dictionary;
        _reusableCellTable = NSMutableDictionary.dictionary;
        _visiableCells = NSMutableArray.array;

        self.scrollsToTop = NO;
        self.pagingEnabled = YES;
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _axis = SFPagingScrollAxisHorizontal;
        self.bounces = NO;
        self.delegate = self;
    }

    return self;
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

- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect frame = self.frame;

    if (CGPointEqualToPoint(_offset, self.contentOffset) && CGSizeEqualToSize(_frame.size, frame.size)) {
        return;
    }

    if (!CGSizeEqualToSize(_frame.size, frame.size) && _visiableCells.count > 0) {
        for (SFPagingScrollViewCell *cell in _visiableCells) {
            [cell removeFromSuperview];
            [self enqueueCell:cell];
        }

        [_visiableCells removeAllObjects];
    }

    _frame = frame;
    _numberOfPages = self.numberOfPages;
    [self layout];
}

- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier {
    if ([cellClass isSubclassOfClass:SFPagingScrollViewCell.class] && identifier.length > 0) {
        [_cellClassTable setObject:cellClass forKey:identifier];
    }
}

- (__kindof SFPagingScrollViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier {
    if (identifier.length == 0) {
        return nil;
    }

    NSMutableSet<SFPagingScrollViewCell*> *cellQueue = [self queueForIdentifier:identifier];

    SFPagingScrollViewCell *cell = cellQueue.anyObject;
    if (cell) {
        [cellQueue removeObject:cell];
        [cell prepareForReuse];
        return cell;
    }

    Class cellClass = [_cellClassTable objectForKey:identifier];
    cell = [(SFPagingScrollViewCell *)[cellClass alloc] initWithIdentifier:identifier];

    return cell;
}

- (void)scrollToCellAtIndex:(NSInteger)index animated:(BOOL)animated {
    index = MAX(MIN(index, self.numberOfPages - 1), 0);
    [self setContentOffset:[self offsetForIndex:index] animated:animated];
}

- (void)reloadData {
    _numberOfPages = self.numberOfPages;
    for (SFPagingScrollViewCell *cell in _visiableCells) {
        [cell removeFromSuperview];
        [self enqueueCell:cell];
    }

    [_visiableCells removeAllObjects];

    [self layout];
}

- (void)layout {
    CGPoint offset = self.contentOffset;
    [self layoutVisiableCellsForOffset:offset];
    _offset = offset;
}

#pragma mark - delegates

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _offset = scrollView.contentOffset;
    _numberOfPages = self.numberOfPages;

    for (SFPagingScrollViewCell *cell in _visiableCells) {
        [cell onScrollWillBegin];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self layout];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    for (SFPagingScrollViewCell *cell in _visiableCells) {
        [cell onScrollFinish];
    }
}

#pragma mark -

- (NSMutableSet<SFPagingScrollViewCell*> *)queueForIdentifier:(NSString *)identifier {
    if (identifier.length == 0) {
        return nil;
    }

    NSMutableSet<SFPagingScrollViewCell*> *cellQueue = _reusableCellTable[identifier];
    if (!cellQueue) {
        cellQueue = NSMutableSet.set;
        _reusableCellTable[identifier] = cellQueue;
    }

    return cellQueue;
}

- (void)enqueueCell:(SFPagingScrollViewCell *)cell {
    NSMutableSet<SFPagingScrollViewCell*> *cellQueue = [self queueForIdentifier:cell.identifier];
    [cellQueue addObject:cell];
}

- (void)enqueueInvisiableCellsInRect:(CGRect)visiableRect {
    NSInteger count = _visiableCells.count;
    for (NSInteger i = count - 1; i >= 0; i--) {
        SFPagingScrollViewCell *cell = _visiableCells[i];
        if (!CGRectContainsRect(visiableRect, cell.frame)) {
            [cell removeFromSuperview];
            [self enqueueCell:cell];
            [_visiableCells removeObjectAtIndex:i];
        }
    }
}

- (BOOL)hasCellInRect:(CGRect)frame {
    if (_visiableCells.count == 0) {
        return NO;
    }

    SFPagingScrollViewCell *firstCell = _visiableCells.firstObject;
    SFPagingScrollViewCell *lastCell = _visiableCells.lastObject;
    CGRect visiableRect = CGRectUnion(firstCell.frame, lastCell.frame);

    return CGRectContainsRect(visiableRect, frame);
}

- (CGSize)fittingContentSizeForPages:(NSInteger)numberOfPages pageSize:(CGSize)size {
    CGSize contentSize = CGSizeZero;
    if (_axis == SFPagingScrollAxisVertical) {
        contentSize = CGSizeMake(size.width, numberOfPages * size.height);
    } else if (_axis == SFPagingScrollAxisHorizontal) {
        contentSize = CGSizeMake(numberOfPages * size.width, size.height);
    }

    return contentSize;
}

- (NSInteger)numberOfPages {
    if ([_dataSource respondsToSelector:@selector(numberOfPagesForPagingScrollView:)]) {
        return MAX([_dataSource numberOfPagesForPagingScrollView:self], 0);
    }

    return 0;
}

- (SFPagingScrollViewCell *)visiableCellAtIndex:(NSInteger)index {
    CGPoint origin = [self offsetForIndex:index];
    for (SFPagingScrollViewCell *cell in _visiableCells) {
        if (CGPointEqualToPoint(cell.frame.origin, origin)) {
            return cell;
        }
    }

    return nil;
}

- (SFPagingScrollViewCell *)cellForIndex:(NSInteger)index {
    if ([_dataSource respondsToSelector:@selector(pagingScrollView:cellForIndex:)]) {
        SFPagingScrollViewCell *cell = [_dataSource pagingScrollView:self cellForIndex:index];

        return [cell isKindOfClass:SFPagingScrollViewCell.class] ? cell : nil;
    }

    return nil;
}

- (CGPoint)offsetForIndex:(NSInteger)index {
    CGFloat x = 0, y = 0;

    if (_axis == SFPagingScrollAxisHorizontal) {
        CGFloat w = CGRectGetWidth(self.frame);
        x = index * w;
    } else if (_axis == SFPagingScrollAxisVertical) {
        CGFloat h = CGRectGetHeight(self.frame);
        y = index * h;
    }

    return CGPointMake(x, y);
}

- (NSInteger)indexForOffset:(CGPoint)offset endIndex:(NSInteger *)endIndex {
    UIEdgeInsets inset = self.contentInset;
    if (@available(iOS 11.0, *)) {
        inset = self.adjustedContentInset;
    }

    NSInteger index = 0, end = 0;
    if (_axis == SFPagingScrollAxisHorizontal) {
        CGFloat x = offset.x + inset.left, w = CGRectGetWidth(self.frame);
        index = floor(MAX(x, 0) / w);
        CGFloat maxX = MAX((x + w), 0);
        end = floor(maxX / w);
    } else if (_axis == SFPagingScrollAxisVertical) {
        CGFloat y = offset.y + inset.top, h = CGRectGetHeight(self.frame);
        index = floor(MAX(y, 0) / h);
        CGFloat maxY = MAX((y + h), 0);
        end = floor(maxY / h);
    }

    if (endIndex) {
        *endIndex = end;
    }

    return index;
}

- (void)layoutVisiableCellsForOffset:(CGPoint)offset {
    NSInteger numberOfPages = _numberOfPages;
    if (numberOfPages == 0) {
        for (SFPagingScrollViewCell *cell in _visiableCells) {
            [cell removeFromSuperview];
            [self enqueueCell:cell];
        }

        self.contentSize = CGSizeZero;
        [_visiableCells removeAllObjects];

        return;
    }

    CGRect frame = self.frame;
    self.contentSize = [self fittingContentSizeForPages:numberOfPages pageSize:frame.size];

    NSInteger startIndex, endIndex;
    startIndex = [self indexForOffset:offset endIndex:&endIndex];
    endIndex = MIN(endIndex, numberOfPages - 1);
    _startVisiableIndex = startIndex;
    _endVisiableIndex = endIndex;

    CGFloat x = 0, y = 0, width = CGRectGetWidth(frame), height = CGRectGetHeight(frame);
    CGRect visiableRect = CGRectZero;
    NSInteger numberOfvisiableCell = endIndex - startIndex + 1;

    if (_axis == SFPagingScrollAxisVertical) {
        visiableRect = CGRectMake(0, startIndex * height, width, numberOfvisiableCell * height);
    } else if (_axis == SFPagingScrollAxisHorizontal) {
        visiableRect = CGRectMake(startIndex * width, 0, numberOfvisiableCell * width, height);
    }

    [self enqueueInvisiableCellsInRect:visiableRect];

    for (NSInteger i = startIndex; i <= endIndex; i++) {
        if (_axis == SFPagingScrollAxisVertical) {
            y = i * height;
        } else if (_axis == SFPagingScrollAxisHorizontal) {
            x = i * width;
        }

        CGRect frame = CGRectMake(x, y, width, height);
        if ([self hasCellInRect:frame]) {

            CGFloat percent = 1, minX = x, maxX = x + width;
            if (minX < offset.x && maxX > offset.x) {
                percent = (maxX - offset.x) / width;
            } else if (offset.x + width < maxX && offset.x + width > minX) {
                percent = (offset.x + width - minX) / width;
            }

            SFPagingScrollViewCell *cell = [self visiableCellAtIndex:i];
            [cell onScrollProgress:MIN(MAX(percent, 0), 1)];

            continue;
        }

        SFPagingScrollViewCell *cell = [self cellForIndex:i];
        cell.transform = CGAffineTransformIdentity;
        cell.frame = frame;
        [self addSubview:cell];

        if (![_visiableCells containsObject:cell]) {
            [_visiableCells addObject:cell];
        }
    }
}

@end

#endif
