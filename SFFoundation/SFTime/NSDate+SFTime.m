//
//  NSDate+SFTime.m
//  SFFoundation
//
//  Created by vvveiii on 2019/6/28.
//  Copyright © 2019 lvv. All rights reserved.
//

#import "NSDate+SFTime.h"
#import "SFISO8601DateFormatter.h"

@implementation NSDate (SFTime)

- (BOOL)sf_sameYear:(NSDate *)date inTimezone:(NSTimeZone *)timezone {
    SFISO8601DateFormatter *dateFormatter = SFISO8601DateFormatter.dateFormatter;

    if (timezone) {
        dateFormatter.timeZone = timezone;
    }

    NSDateComponents *aDayDC = [dateFormatter dateComponentsFromDate:date];
    NSDateComponents *dc = [dateFormatter dateComponentsFromDate:self];

    return aDayDC.year == dc.year;
}

- (BOOL)sf_sameMonth:(NSDate *)date inTimezone:(NSTimeZone *)timezone {
    SFISO8601DateFormatter *dateFormatter = SFISO8601DateFormatter.dateFormatter;

    if (timezone) {
        dateFormatter.timeZone = timezone;
    }

    NSDateComponents *aDayDC = [dateFormatter dateComponentsFromDate:date];
    NSDateComponents *dc = [dateFormatter dateComponentsFromDate:self];

    return aDayDC.year == dc.year &&
            aDayDC.month == dc.month;
}

- (BOOL)sf_sameDay:(NSDate *)date inTimezone:(NSTimeZone *)timezone {
    SFISO8601DateFormatter *dateFormatter = SFISO8601DateFormatter.dateFormatter;

    if (timezone) {
        dateFormatter.timeZone = timezone;
    }

    NSDateComponents *aDayDC = [dateFormatter dateComponentsFromDate:date];
    NSDateComponents *dc = [dateFormatter dateComponentsFromDate:self];

    return aDayDC.year == dc.year &&
            aDayDC.month == dc.month &&
            aDayDC.day == dc.day;
}

@end
