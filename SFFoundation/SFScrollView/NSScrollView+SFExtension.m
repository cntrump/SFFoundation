//
//  NSScrollView+SFExtension.m
//  SFFoundation
//
//  Created by vvveiii on 2019/8/9.
//  Copyright © 2019 lvv. All rights reserved.
//  refer: https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/NSScrollViewGuide/Articles/Scrolling.html#//apple_ref/doc/uid/TP40003463-SW1

#import "NSScrollView+SFExtension.h"

#if SF_MACOS

@implementation NSScrollView (SFExtension)

- (void)sf_scrollToTop {
    NSPoint newScrollOrigin;

    // assume that the scrollview is an existing variable
    if (self.documentView.isFlipped) {
        newScrollOrigin = NSMakePoint(0.0, 0.0);
    } else {
        newScrollOrigin = NSMakePoint(0.0, NSMaxY(self.documentView.frame) - NSHeight(self.contentView.bounds));
    }

    [self.documentView scrollPoint:newScrollOrigin];
}

- (void)sf_scrollToBottom {
    NSPoint newScrollOrigin;

    // assume that the scrollview is an existing variable
    if (self.documentView.isFlipped) {
        newScrollOrigin = NSMakePoint(0.0, NSMaxY(self.documentView.frame) - NSHeight(self.contentView.bounds));
    } else {
        newScrollOrigin = NSMakePoint(0.0, 0.0);
    }

    [self.documentView scrollPoint:newScrollOrigin];
}

@end

#endif
