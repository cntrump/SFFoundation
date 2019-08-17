//
//  SFTextSelectionView.m
//  SFFoundation
//
//  Created by vvveiii on 2019/8/15.
//  Copyright © 2019 lvv. All rights reserved.
//

#import "SFTextSelectionView.h"
#import "SFTextKitContext.h"
#import "SFColor.h"

#if SF_IOS

@interface SFTextSelectionView () {
    SFTextKitContext *_textContext;
    CAShapeLayer *_selectedRangeLayer;
}

@end

@implementation SFTextSelectionView

- (instancetype)initWithFrame:(CGRect)frame
                textContext:(SFTextKitContext *)textContext
                selectedRange:(NSRange)selectedRange
                       origin:(CGPoint)origin {
    if (self = [super initWithFrame:frame]) {
        _origin = origin;
        _textContext = textContext;
        _selectedRangeLayer = CAShapeLayer.layer;
        _selectedRangeLayer.fillColor = [UIColor sf_colorWithRGB:0xd2b8fc alpha:0.3].CGColor;
        [self.layer addSublayer:_selectedRangeLayer];
        self.selectedRange = selectedRange;
    }

    return self;
}

- (void)setSize:(CGSize)size {
    _size = size;
    [_textContext performWithBlock:^(NSLayoutManager *layoutManager, NSTextContainer *textContainer, NSTextStorage *textStorage) {
        textContainer.size = size;
    }];
    
    self.selectedRange = self.selectedRange;
}

- (void)setOrigin:(CGPoint)origin {
    _origin = origin;

    self.selectedRange = self.selectedRange;
}

- (void)setSelectedRange:(NSRange)selectedRange {
    _selectedRange = selectedRange;

    [_textContext performWithBlock:^(NSLayoutManager *layoutManager, NSTextContainer *textContainer, NSTextStorage *textStorage) {
        NSRange glyphRange = [layoutManager glyphRangeForCharacterRange:selectedRange actualCharacterRange:NULL];
        CGRect beginRect = [layoutManager boundingRectForGlyphRange:NSMakeRange(glyphRange.location, 1) inTextContainer:textContainer];
        CGRect endRect = [layoutManager boundingRectForGlyphRange:NSMakeRange(NSMaxRange(glyphRange) - 1, 1) inTextContainer:textContainer];
        CGRect boundingRect = [layoutManager boundingRectForGlyphRange:glyphRange inTextContainer:textContainer];

        self->_selectedRangeLayer.path = [self pathWithBoundingRect:boundingRect beginRect:beginRect endRect:endRect].CGPath;
    }];
}

- (UIBezierPath *)pathWithBoundingRect:(CGRect)boundingRect beginRect:(CGRect)begin endRect:(CGRect)end {
    CGFloat x = _origin.x, y = _origin.y;

    if (CGRectGetMinY(begin) == CGRectGetMinY(end)) {
        return [UIBezierPath bezierPathWithRect:CGRectOffset(CGRectUnion(begin, end), x, y)];
    }

    UIBezierPath *path = UIBezierPath.bezierPath;
    [path appendPath:[UIBezierPath bezierPathWithRect:CGRectMake(CGRectGetMinX(begin) + x, CGRectGetMinY(begin) + y, CGRectGetWidth(boundingRect) - CGRectGetMinX(begin), CGRectGetHeight(begin))]];

    CGFloat h = CGRectGetMinY(end) - CGRectGetMaxY(begin);
    if (h > 0) {
        [path appendPath:[UIBezierPath bezierPathWithRect:CGRectMake(CGRectGetMinX(boundingRect) + x, CGRectGetMaxY(begin) + y, CGRectGetWidth(boundingRect), h)]];
    }

    [path appendPath:[UIBezierPath bezierPathWithRect:CGRectMake(CGRectGetMinX(boundingRect) + x, CGRectGetMinY(end) + y, CGRectGetMaxX(end), CGRectGetHeight(end))]];

    return path;
}

@end

#endif
