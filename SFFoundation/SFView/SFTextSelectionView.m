//
//  SFTextSelectionView.m
//  SFFoundation
//
//  Created by vvveiii on 2019/8/15.
//  Copyright © 2019 lvv. All rights reserved.
//

#import "SFTextSelectionView.h"

#if SF_IOS

@interface SFTextSelectionView () {
    NSTextContainer *_textContainer;
    NSLayoutManager *_layoutManager;
    NSTextStorage *_textStorage;
}

@end

@implementation SFTextSelectionView

- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer {
    if (self = [super initWithFrame:frame]) {
        _textContainer = textContainer;
        _layoutManager = textContainer.layoutManager;
        _textStorage = _layoutManager.textStorage;
    }

    return self;
}

@end

#endif
