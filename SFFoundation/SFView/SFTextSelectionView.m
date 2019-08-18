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
    }

    return self;
}

- (void)setTintColor:(UIColor *)tintColor {
    super.tintColor = tintColor;

    CGRect rect = CGRectMake(0, 0, 11, 11);

    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0.5, 0.5, 10, 10)] addClip];
    [tintColor setFill];
    UIRectFill(rect);
    self.layer.contents = (__bridge id)UIGraphicsGetImageFromCurrentImageContext().CGImage;
    UIGraphicsEndImageContext();
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
        _style = style;
        _grabberDot = [[SFSelectionGrabberDot alloc] initWithFrame:CGRectZero];
        [self addSubview:_grabberDot];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    switch (_style) {
        case SFSelectionGrabberStyleTop:
            _grabberDot.frame = CGRectMake(-4.5, -10, 11, 11);
            break;

        case SFSelectionGrabberStyleBottom:
            _grabberDot.frame = CGRectMake(-4.5, CGRectGetHeight(self.bounds) - 1, 11, 11);
            break;

        default:
            break;
    }
}

- (void)setTintColor:(UIColor *)tintColor {
    super.tintColor = tintColor;

    CGRect rect = CGRectMake(0, 0, 2, 2);

    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [tintColor setFill];
    UIRectFill(rect);
    self.layer.contents = (__bridge id)UIGraphicsGetImageFromCurrentImageContext().CGImage;
    UIGraphicsEndImageContext();

    _grabberDot.tintColor = tintColor;
}

@end

#pragma mark - SFTextSelectionView

typedef NS_ENUM(NSInteger, SFSelectionDirection) {
    SFSelectionDirectionUndefined,
    SFSelectionDirectionLeft,
    SFSelectionDirectionRight
};

@interface SFTextSelectionView () {
    SFTextKitContext *_textContext;
    CAShapeLayer *_textRangeLayer;
    UIView *_beginView, *_endView;
    SFSelectionGrabber *_beginGrabber, *_endGrabber;
    SFSelectionDirection _selectionDirection;
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
        _textRangeLayer.contentsScale = UIScreen.mainScreen.scale;
        [self.layer addSublayer:_textRangeLayer];

        _beginView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:_beginView];

        _endView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:_endView];

        _beginGrabber = [[SFSelectionGrabber alloc] initWithStyle:SFSelectionGrabberStyleTop];
        [self addSubview:_beginGrabber];

        _endGrabber = [[SFSelectionGrabber alloc] initWithStyle:SFSelectionGrabberStyleBottom];
        [self addSubview:_endGrabber];

        self.tintColor = [UIColor sf_colorWithRGB:0x007aff];
        self.selectedRange = selectedRange;
    }

    return self;
}

- (void)setTintColor:(UIColor *)tintColor {
    super.tintColor = tintColor;

    _beginGrabber.tintColor = tintColor;
    _endGrabber.tintColor = tintColor;
    _textRangeLayer.fillColor = [tintColor colorWithAlphaComponent:0.2].CGColor;
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

#pragma mark -

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];

    CGPoint location = [touches.anyObject locationInView:self];
    CGRect rect = UIEdgeInsetsInsetRect(_beginGrabber.frame, UIEdgeInsetsMake(-22, -10, 0, -10));
    if (CGRectContainsPoint(rect, location)) {
        _selectionDirection = SFSelectionDirectionLeft;
        return;
    }

    rect = UIEdgeInsetsInsetRect(_endGrabber.frame, UIEdgeInsetsMake(0, -10, -22, -10));
    if (CGRectContainsPoint(rect, location)) {
        _selectionDirection = SFSelectionDirectionRight;
        return;
    }

    _selectionDirection = SFSelectionDirectionUndefined;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];

    if (_selectionDirection == SFSelectionDirectionUndefined) {
        return;
    }

    CGPoint location = [touches.anyObject locationInView:self];
    CGPoint p = CGPointMake(location.x - _origin.x, location.y - _origin.y);
    __block NSInteger characterIndex = NSNotFound;
    [_textContext performWithBlock:^(NSLayoutManager *layoutManager, NSTextContainer *textContainer, NSTextStorage *textStorage) {
        NSInteger glyphIndex = [layoutManager glyphIndexForPoint:p inTextContainer:textContainer];
        characterIndex = [layoutManager characterIndexForGlyphAtIndex:glyphIndex];
    }];

    NSInteger maxIndex = NSMaxRange(_selectedRange) - 1;
    NSRange selectedRange = _selectedRange;

    switch (_selectionDirection) {
        case SFSelectionDirectionLeft:
            if (characterIndex > maxIndex) {
                characterIndex = maxIndex;
            }

            selectedRange.location = characterIndex;
            selectedRange.length += _selectedRange.location - characterIndex;
            break;

        case SFSelectionDirectionRight:
            if (characterIndex < _selectedRange.location) {
                characterIndex = _selectedRange.location;
            }

            selectedRange.length += characterIndex - maxIndex;
            break;

        default:
            break;
    }

    self.selectedRange = selectedRange;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    _selectionDirection = SFSelectionDirectionUndefined;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    _selectionDirection = SFSelectionDirectionUndefined;
}

@end

#endif
