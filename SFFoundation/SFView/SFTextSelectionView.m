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

typedef NS_ENUM(NSInteger, SFSelectionGrabberStyle) {
    SFSelectionGrabberStyleUndefined,
    SFSelectionGrabberStyleTop,
    SFSelectionGrabberStyleBottom
};

@interface SFSelectionGrabberDot : UIView

@end

@implementation SFSelectionGrabberDot

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.blueColor;
    }

    return self;
}

@end

@interface SFSelectionGrabber : UIView {
    SFSelectionGrabberDot *_grabberDot;
    SFSelectionGrabberStyle _style;
}

@end

@implementation SFSelectionGrabber

- (instancetype)initWithStyle:(SFSelectionGrabberStyle)style {
    if (self = [super initWithFrame:CGRectZero]) {
        self.backgroundColor = UIColor.blueColor;

        _style = style;

        CGRect dotFrame = CGRectZero;
        switch (style) {
            case SFSelectionGrabberStyleTop:
                dotFrame = CGRectMake(-4.5, -10, 11, 11);
                break;

            case SFSelectionGrabberStyleBottom:
                dotFrame = CGRectMake(-4.5, -1, 11, 11);
                break;

            default:
                break;
        }

        _grabberDot = [[SFSelectionGrabberDot alloc] initWithFrame:dotFrame];
        [self addSubview:_grabberDot];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (_style == SFSelectionGrabberStyleBottom) {
        _grabberDot.frame = CGRectMake(-4.5, CGRectGetHeight(self.bounds) - 1, 11, 11);
    }
}

@end

#pragma mark - SFTextSelectionView

@interface SFTextSelectionView () {
    SFTextKitContext *_textContext;
    CAShapeLayer *_textRangeLayer;
    UIView *_beginView, *_endView;
    SFSelectionGrabber *_beginGrabber, *_endGrabber;
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
        _textRangeLayer = CAShapeLayer.layer;
        _textRangeLayer.fillColor = [UIColor sf_colorWithRGB:0x0000ff alpha:0.3].CGColor;
        [self.layer addSublayer:_textRangeLayer];

        _beginView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:_beginView];

        _endView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:_endView];

        _beginGrabber = [[SFSelectionGrabber alloc] initWithStyle:SFSelectionGrabberStyleTop];
        [self addSubview:_beginGrabber];

        _endGrabber = [[SFSelectionGrabber alloc] initWithStyle:SFSelectionGrabberStyleBottom];
        [self addSubview:_endGrabber];

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

        self->_textRangeLayer.path = [self pathWithBoundingRect:boundingRect beginRect:beginRect endRect:endRect].CGPath;
    }];
}

- (UIBezierPath *)pathWithBoundingRect:(CGRect)boundingRect beginRect:(CGRect)begin endRect:(CGRect)end {
    CGFloat x = _origin.x, y = _origin.y;

    if (CGRectGetMinY(begin) == CGRectGetMinY(end)) {
        CGRect rect = CGRectOffset(CGRectUnion(begin, end), x, y);
        _beginView.frame = CGRectMake(CGRectGetMinX(rect) + 0.5, CGRectGetMinY(rect), 0, CGRectGetHeight(rect));
        _endView.frame = CGRectMake(CGRectGetMaxX(rect) + 0.5, CGRectGetMinY(rect), 0, CGRectGetHeight(rect));

        _beginGrabber.frame = CGRectMake(CGRectGetMinX(_beginView.frame) - 0.5, CGRectGetMinY(_beginView.frame), 2, CGRectGetHeight(_beginView.frame));
        _endGrabber.frame = CGRectMake(CGRectGetMinX(_endView.frame) - 1.5, CGRectGetMinY(_endView.frame), 2, CGRectGetHeight(_endView.frame));

        return [UIBezierPath bezierPathWithRect:rect];
    }

    CGRect rect = CGRectMake(CGRectGetMinX(begin) + x,
                             CGRectGetMinY(begin) + y,
                             CGRectGetWidth(boundingRect) - CGRectGetMinX(begin),
                             CGRectGetHeight(begin));
    _beginView.frame = CGRectMake(CGRectGetMinX(rect) + 0.5, CGRectGetMinY(rect), 0, CGRectGetHeight(rect));
    _beginGrabber.frame = CGRectMake(CGRectGetMinX(_beginView.frame) - 0.5, CGRectGetMinY(_beginView.frame), 2, CGRectGetHeight(_beginView.frame));

    UIBezierPath *path = UIBezierPath.bezierPath;
    [path appendPath:[UIBezierPath bezierPathWithRect:rect]];

    CGFloat h = CGRectGetMinY(end) - CGRectGetMaxY(begin);
    if (h > 0) {
        [path appendPath:[UIBezierPath bezierPathWithRect:CGRectMake(CGRectGetMinX(boundingRect) + x, CGRectGetMaxY(begin) + y, CGRectGetWidth(boundingRect), h)]];
    }

    rect = CGRectMake(CGRectGetMinX(boundingRect) + x,
                      CGRectGetMinY(end) + y,
                      CGRectGetMaxX(end),
                      CGRectGetHeight(end));
    _endView.frame = CGRectMake(CGRectGetMaxX(rect) + 0.5, CGRectGetMinY(rect), 0, CGRectGetHeight(rect));
    _endGrabber.frame = CGRectMake(CGRectGetMinX(_endView.frame) - 1.5, CGRectGetMinY(_endView.frame), 2, CGRectGetHeight(_endView.frame));

    [path appendPath:[UIBezierPath bezierPathWithRect:rect]];

    return path;
}

@end

#endif
