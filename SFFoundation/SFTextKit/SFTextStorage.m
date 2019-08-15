//
//  SFTextStorage.m
//  SFFoundation
//
//  Created by vvveiii on 2019/4/26.
//  Copyright © 2019 lvv. All rights reserved.
//

#import "SFTextStorage.h"

@interface SFTextStorage () {
    NSMutableAttributedString *_innerStorage;
}

@end

@implementation SFTextStorage

- (instancetype)init {
    if (self = [super init]) {
        _innerStorage = [[NSMutableAttributedString alloc] init];
    }

    return self;
}

- (NSString *)string {
    return _innerStorage.string;
}

- (NSDictionary *)attributesAtIndex:(NSUInteger)location effectiveRange:(NSRangePointer)range {
    return [_innerStorage attributesAtIndex:location effectiveRange:range];
}

- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str {
    [_innerStorage replaceCharactersInRange:range withString:str];

    [self edited:NSTextStorageEditedCharacters range:range changeInLength:str.length - range.length];
}

- (void)setAttributes:(NSDictionary *)attrs range:(NSRange)range {
    [_innerStorage setAttributes:attrs range:range];

    [self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
}

@end
