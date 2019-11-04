//
//  SFURIFixup.m
//  SFFoundation
//
//  Created by v on 2019/11/4.
//  Copyright © 2019 lvv. All rights reserved.
//

#import "SFURIFixup.h"

static NSURL *punycodedURL(NSString *string) {
    if (string.length == 0) {
        return nil;
    }

    NSURLComponents *components = [NSURLComponents componentsWithString:string];

    return components.URL;
}

static NSString *replaceBrackets(NSString *url) {
    return [[url stringByReplacingOccurrencesOfString:@"[" withString:@"%5B"] stringByReplacingOccurrencesOfString:@"]" withString:@"%5D"];
}

@implementation NSCharacterSet (SFURL)

+ (instancetype)sf_URLAllowedCharacterSet {
    return [self characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~:/?#[]@!$&'()*+,;=%"];
}

@end

@implementation SFURIFixup

+ (NSURL *)getURL:(NSString *)entry {
    if (entry.length == 0) {
        return nil;
    }

    NSURL *url = [NSURL URLWithString:entry];
    if (url) {
        return url;
    }

    NSString *trimmed = [entry stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
    NSString *escaped = [trimmed stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.sf_URLAllowedCharacterSet];
    if (!escaped) {
        return nil;
    }

    escaped = replaceBrackets(escaped);
    url = punycodedURL(escaped);
    if (url && url.scheme) {
        return url;
    }

    if ([trimmed rangeOfString:@"."].length == 0) {
        return nil;
    }

    if ([trimmed rangeOfString:@" "].length > 0) {
        return nil;
    }

    url = punycodedURL([@"http://" stringByAppendingString:escaped]);
    if (url && url.host) {
        return url;
    }

    return url;
}

@end
