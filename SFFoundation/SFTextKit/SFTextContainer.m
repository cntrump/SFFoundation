//
//  SFTextContainer.m
//  SFFoundation
//
//  Created by vvveiii on 2019/8/19.
//  Copyright © 2019 lvv. All rights reserved.
//

#import "SFTextContainer.h"

@implementation SFTextContainer

- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode {
    NSLineBreakMode old = self.lineBreakMode;
    super.lineBreakMode = lineBreakMode;
    if (old != lineBreakMode) {
        [self setNeedsLayout];
    }
}

- (void)setMaximumNumberOfLines:(NSUInteger)maximumNumberOfLines {
    NSUInteger old = self.maximumNumberOfLines;
    super.maximumNumberOfLines = maximumNumberOfLines;
    if (old != maximumNumberOfLines) {
        [self setNeedsLayout];
    }
}

- (void)setNeedsLayout {
    [self.layoutManager textContainerChangedGeometry:self];
}

@end
