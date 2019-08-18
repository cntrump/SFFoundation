//
//  SFStringTokenizer.m
//  SFFoundation
//
//  Created by vvveiii on 2019/8/18.
//  Copyright © 2019 lvv. All rights reserved.
//

#import "SFStringTokenizer.h"

@interface SFStringTokenizer () {
    CFStringTokenizerRef _tokenizer;
}

@end

@implementation SFStringTokenizer

+ (NSString *)bestStringLanguage:(NSString *)string range:(NSRange)range {
    return (__bridge_transfer NSString *)CFStringTokenizerCopyBestStringLanguage((__bridge CFStringRef)string, SFCFRangeFromNSRange(range));
}

- (void)dealloc {
    if (_tokenizer) {
        CFRelease(_tokenizer);
    }
}

- (instancetype)initWithString:(NSString *)string range:(NSRange)range options:(CFOptionFlags)options locale:(NSLocale *)locale {
    if (self = [super init]) {
        _tokenizer = CFStringTokenizerCreate(kCFAllocatorDefault, (__bridge CFStringRef)string,
                                             SFCFRangeFromNSRange(range),
                                             options,
                                             (__bridge CFLocaleRef)locale);
    }

    return self;
}

- (void)setString:(NSString *)string range:(NSRange)range {
    CFStringTokenizerSetString(_tokenizer, (__bridge CFStringRef)string, SFCFRangeFromNSRange(range));
}

- (CFStringTokenizerTokenType)goToTokenAtIndex:(NSInteger)index {
    return CFStringTokenizerGoToTokenAtIndex(_tokenizer, index);
}

- (CFStringTokenizerTokenType)advanceToNextToken {
    return CFStringTokenizerAdvanceToNextToken(_tokenizer);
}

- (NSRange)getCurrentTokenRange {
    CFRange r = CFStringTokenizerGetCurrentTokenRange(_tokenizer);

    return SFNSRangeFromCFRange(r);
}

- (CFTypeRef)currentTokenAttributeForAttribute:(CFOptionFlags)attribute {
    return CFStringTokenizerCopyCurrentTokenAttribute(_tokenizer, attribute);
}

- (NSInteger)getCurrentSubTokens:(NSRange *)ranges maxRangeLength:(NSInteger)maxRangeLength derivedSubTokens:(NSMutableArray *)derivedSubTokens {
    CFRange r;
    CFIndex count = CFStringTokenizerGetCurrentSubTokens(_tokenizer, &r, maxRangeLength, (__bridge CFMutableArrayRef)derivedSubTokens);

    if (ranges) {
        *ranges = SFNSRangeFromCFRange(r);
    }

    return count;
}

@end
