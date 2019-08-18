//
//  SFStringTokenizer.h
//  SFFoundation
//
//  Created by vvveiii on 2019/8/18.
//  Copyright © 2019 lvv. All rights reserved.
//

@interface SFStringTokenizer : NSObject

+ (NSString *)bestStringLanguage:(NSString *)string range:(NSRange)range;

- (instancetype)initWithString:(NSString *)string range:(NSRange)range options:(CFOptionFlags)options locale:(NSLocale *)locale;

- (void)setString:(NSString *)string range:(NSRange)range;
- (CFStringTokenizerTokenType)goToTokenAtIndex:(NSInteger)index;
- (CFStringTokenizerTokenType)advanceToNextToken;
- (NSRange)getCurrentTokenRange;
- (CFTypeRef)currentTokenAttributeForAttribute:(CFOptionFlags)attribute;
- (NSInteger)getCurrentSubTokens:(NSRange *)ranges maxRangeLength:(NSInteger)maxRangeLength derivedSubTokens:(NSMutableArray *)derivedSubTokens;

@end

SF_EXTERN_C_BEGIN

NS_INLINE NSRange SFNSRangeFromCFRange(CFRange r) {
    return NSMakeRange(r.location, r.length);
}

NS_INLINE CFRange SFCFRangeFromNSRange(NSRange r) {
    return CFRangeMake(r.location, r.length);
}

SF_EXTERN_C_END
