//
//  NSString+SFExtension.m
//  SFFoundation
//
//  Created by vvveiii on 2019/8/17.
//  Copyright © 2019 lvv. All rights reserved.
//

#import "NSString+SFExtension.h"

@implementation NSString (SFExtension)

+ (BOOL)sf_verifyChinaSecondGenerationIdentity:(NSString *)identity {
    if (identity.length != 18) {
        return NO;
    }

    NSInteger sum = 0;
    for (NSInteger i = 0; i < 17; i++) {
        NSString *n = [identity substringWithRange:NSMakeRange(i, 1)];
        sum += ((1 << (17 - i)) % 11) * n.integerValue;
    }

    NSInteger n = 0;
    NSString *x = [identity substringWithRange:NSMakeRange(17, 1)];
    if ([x compare:@"X" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        n = 10;
    } else {
        n = x.integerValue;
    }

    NSInteger checksum = (12 - (sum % 11)) % 11;

    return checksum == n;
}

@end
