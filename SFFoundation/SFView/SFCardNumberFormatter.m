//
//  SFCardNumberFormatter.m
//  SFFoundation
//
//  Created by vvveiii on 2019/8/26.
//  Copyright © 2019 lvv. All rights reserved.
//

#import "SFCardNumberFormatter.h"

@implementation SFCardNumberFormatter

- (instancetype)init {
    if (self = [super init]) {
        _separator = @"-";
        _digitsUnit = 4;
    }

    return self;
}

- (NSString *)stringForObjectValue:(id)obj {
    if (![obj isKindOfClass:NSString.class]) {
        return nil;
    }

    NSString *input = (NSString *)obj;
    NSScanner *scanner = [[NSScanner alloc] initWithString:input];
    scanner.charactersToBeSkipped = [NSCharacterSet characterSetWithCharactersInString:_separator];
    NSMutableString *outString = NSMutableString.string;

    do {
        NSString *s;
        if ([scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:_separator] intoString:&s]) {
            [outString appendString:s];
        }
    } while (!scanner.isAtEnd);

    return outString;
}

- (BOOL)getObjectValue:(out id  _Nullable __autoreleasing *)obj forString:(NSString *)string errorDescription:(out NSString *__autoreleasing  _Nullable *)error {
    NSInteger length = string.length;
    if (length > _digitsUnit) {
        NSMutableString *outString = NSMutableString.string;
        NSInteger count = ceil((CGFloat)length / _digitsUnit);
        for (NSInteger i = 0; i < count; i++) {
            NSInteger index = i * _digitsUnit;
            NSInteger len = _digitsUnit;
            BOOL atEnd = NO;
            if (index + len >= length) {
                len = length - index;
                atEnd = YES;
            }

            [outString appendString:[string substringWithRange:NSMakeRange(index, len)]];

            if (!atEnd) {
                [outString appendString:_separator];
            }
        }

        if (obj) {
            *obj = outString;
        }
    } else {
        if (obj) {
            *obj = [string copy];
        }
    }

    return YES;
}

- (NSString *)cardNumberFromString:(NSString *)string {
    NSString *cardNumber;
    [self getObjectValue:&cardNumber forString:string errorDescription:NULL];

    return cardNumber;
}

- (NSString *)stringFromCardNumber:(NSString *)cardNumber {
    return [self stringForObjectValue:cardNumber];
}

@end
