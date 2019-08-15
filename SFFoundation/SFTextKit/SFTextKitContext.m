//
//  SFTextKitContext.m
//  SFFoundation
//
//  Created by vvveiii on 2019/7/20.
//  Copyright © 2019 lvv. All rights reserved.
//

#import "SFTextKitContext.h"
#import "SFTextStorage.h"
#import "SFDispatchSemaphore.h"

static SFDispatchSemaphore *TextKitStorageLock(void) {
    static SFDispatchSemaphore *lock;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lock = [SFDispatchSemaphore semaphoreWithValue:1];
    });

    return lock;
}

@interface SFTextKitContext () {
    SFDispatchSemaphore *_lock;
}

@end

@implementation SFTextKitContext

+ (instancetype)contextWithSize:(CGSize)size attributedText:(NSAttributedString *)attributedText {
    return [[self alloc] initWithSize:size attributedText:attributedText];
}

- (instancetype)init {
    return [self initWithSize:CGSizeZero attributedText:nil];
}

- (instancetype)initWithSize:(CGSize)size attributedText:(NSAttributedString *)attributedText {
    return [self initWithSize:size attributedText:attributedText layoutClass:nil containerClass:nil];
}

- (instancetype)initWithSize:(CGSize)size
              attributedText:(NSAttributedString *)attributedText
                 layoutClass:(Class)layoutClass
              containerClass:(Class)containerClass {
    if (self = [super init]) {
        _lock = [SFDispatchSemaphore semaphoreWithValue:1];
        _size = size;
        _layoutManager = [[layoutClass ? : NSLayoutManager.class alloc] init];
        _layoutManager.usesFontLeading = NO;

#if SF_MACOS
        if (@available(macOS 10.11, *)) {
#endif
            _textContainer = [[containerClass ? : NSTextContainer.class alloc] initWithSize:size];
#if SF_MACOS
        } else {
            _textContainer = [[containerClass ? : NSTextContainer.class alloc] initWithContainerSize:size];
        }
#endif
        _textContainer.lineFragmentPadding = 0;

        _textStorage = [[SFTextStorage alloc] init];

        [_layoutManager addTextContainer:_textContainer];
        [_textStorage addLayoutManager:_layoutManager];
        if (attributedText) {
            [TextKitStorageLock() wait];
            [_textStorage setAttributedString:attributedText];
            [TextKitStorageLock() signal];
        }
    }

    return self;
}

- (void)setSize:(CGSize)size {
    _size = size;
    [self performWithBlock:^(NSLayoutManager *layoutManager, NSTextContainer *textContainer, NSTextStorage *textStorage) {
#if SF_IOS
        textContainer.size = size;
#endif
#if SF_MACOS
        if (@available(macOS 10.11, *)) {
            textContainer.size = size;
        } else {
            textContainer.containerSize = size;
        }
#endif
    }];
}

- (void)performWithBlock:(SFTextKitContextBlock)block {
    if (block) {
        [_lock wait];
        block(_layoutManager, _textContainer, _textStorage);
        [_lock signal];
    }
}

@end
