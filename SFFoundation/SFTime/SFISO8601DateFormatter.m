//
//  SFISO8601DateFormatter.m
//  SFFoundation
//
//  Created by vvveiii on 2019/6/27.
//  Copyright © 2019 lvv. All rights reserved.
//

#import "SFISO8601DateFormatter.h"

@interface SFISO8601DateFormatter () {
    SFISO8601DateFormatOptions _options;
}

@end

@implementation SFISO8601DateFormatter

- (NSString *)debugDescription {
    [self updateDateFormatIfNeed];
    
    return [NSString stringWithFormat:@"<%@:%p dateFormat:%@ timeZone<%@:%p> locale<%@:%p> super:%@>",
            NSStringFromClass(self.class), self, self.dateFormat,
            self.timeZone.name, self.timeZone,
            self.locale.localeIdentifier, self.locale,
            NSStringFromClass(self.superclass)];
}

+ (instancetype)dateFormatter {
    return [[self alloc] init];
}

- (instancetype)init {
    if (self = [super init]) {
        self.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        self.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        self.calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierISO8601];
        self.formatOptions = SFISO8601DateFormatWithInternetDateTime;
    }

    return self;
}

- (instancetype)copyWithZone:(NSZone *)zone {
    SFISO8601DateFormatter *dateFormatter = [[[self class] allocWithZone:zone] init];
    dateFormatter.locale = self.locale;
    dateFormatter.timeZone = self.timeZone;
    dateFormatter.calendar = self.calendar;
    dateFormatter.formatOptions = _formatOptions;

    return dateFormatter;
}

- (NSString *)dateFormatFormOptions {
    NSString *year = @"", *month = @"", *weakOfYear = @"",
             *day = @"", *hour = @"", *minute = @"", *second = @"",  *fractionalSeconds = @"", *timeZone = @"";
    NSString *dateAndTime = @"", *inDate = @"", *inTime = @"";

    if (BIT_TEST(_formatOptions, SFISO8601DateFormatWithWeekOfYear)) {
        year = @"YYYY";
        day = @"ee";
        weakOfYear = @"'W'ww";
    }

    if (BIT_TEST(_formatOptions, SFISO8601DateFormatWithYear)) {
        if (year.length == 0) year = @"yyyy";
    }

    if (BIT_TEST(_formatOptions, SFISO8601DateFormatWithMonth)) {
        month = @"MM";
        if (day.length == 0) day = @"dd";
    }

    if (BIT_TEST(_formatOptions, SFISO8601DateFormatWithDay)) {
        if (day.length == 0) day = @"DDD";
    }

    if (BIT_TEST(_formatOptions, SFISO8601DateFormatWithTime)) {
        hour = @"HH";
        minute = @"mm";
        second = @"ss";
        dateAndTime = @"'T'";

        if (BIT_TEST(_formatOptions, SFISO8601DateFormatWithFractionalSeconds)) {
            fractionalSeconds = @".SSS";
        }

        if (BIT_TEST(_formatOptions, SFISO8601DateFormatWithColonSeparatorInTime)) {
            inTime = @":";
        }

        if (BIT_TEST(_formatOptions, SFISO8601DateFormatWithSpaceBetweenDateAndTime)) {
            dateAndTime = @" ";
        }
    }
    
    if (BIT_TEST(_formatOptions, SFISO8601DateFormatWithTimeZone)) {
        if (BIT_TEST(_formatOptions, SFISO8601DateFormatWithColonSeparatorInTimeZone)) {
            timeZone = @"ZZZZZ";
        } else {
            if (self.timeZone.secondsFromGMT != 0) {
                timeZone = @"ZZZ";
            } else {
                timeZone = @"ZZZZZ";
            }
        }
    }

    if (BIT_TEST(_formatOptions, SFISO8601DateFormatWithDashSeparatorInDate)) {
        inDate = @"-";

        if (weakOfYear.length > 0) {
            weakOfYear = [NSString stringWithFormat:@"-%@-", weakOfYear];
        } else {
            weakOfYear = inDate;
        }
    }

    NSString *dateFormat = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@",
                            year, inDate, month, weakOfYear, day, dateAndTime,
                            hour, inTime, minute, inTime, second, fractionalSeconds, timeZone];

    return dateFormat;
}

- (NSString *)stringFromDate:(NSDate *)date {
    [self updateDateFormatIfNeed];

    return [super stringFromDate:date];
}

- (NSDate *)dateFromString:(NSString *)string {
    [self updateDateFormatIfNeed];
    
    return [super dateFromString:string];
}

- (void)updateDateFormatIfNeed {
    if (_options != _formatOptions) {
        _options = _formatOptions;
        self.dateFormat = [self dateFormatFormOptions];
    }
}

- (NSDateComponents *)dateComponentsFromDate:(NSDate *)date timeZone:(NSTimeZone *)timeZone {
    NSCalendar *calendar = self.calendar.copy;
    calendar.timeZone = timeZone;

    return [calendar components:NSCalendarUnitEra |
                                NSCalendarUnitYear |
                                NSCalendarUnitMonth |
                                NSCalendarUnitDay |
                                NSCalendarUnitHour |
                                NSCalendarUnitMinute |
                                NSCalendarUnitSecond |
                                NSCalendarUnitWeekday |
                                NSCalendarUnitWeekdayOrdinal |
                                NSCalendarUnitQuarter |
                                NSCalendarUnitWeekOfMonth |
                                NSCalendarUnitWeekOfYear |
                                NSCalendarUnitYearForWeekOfYear |
                                NSCalendarUnitNanosecond |
                                NSCalendarUnitCalendar |
                                NSCalendarUnitTimeZone
                       fromDate:date];
}

- (NSDateComponents *)dateComponentsFromDate:(NSDate *)date {
    return [self dateComponentsFromDate:date timeZone:self.timeZone];
}

- (NSDateComponents *)dateComponentsFromString:(NSString *)dateString {
    NSDate *date = [self dateFromString:dateString];
    NSTimeZone *timeZone = sf_timeZoneFromString(dateString);

    return [self dateComponentsFromDate:date timeZone:timeZone];
}

@end


OBJC_EXTERN NSTimeZone *sf_timeZoneFromString(NSString *dateString) {
    NSInteger seconds = 0, f = 1;
    NSRange range = [dateString rangeOfString:@"+" options:NSBackwardsSearch];
    if (range.location == NSNotFound) {
        range = [dateString rangeOfString:@"-" options:NSBackwardsSearch];
        if (range.location != NSNotFound) {
            f = -1;
        }
    }

    if (range.location != NSNotFound) {
        NSMutableString *tz = [dateString substringFromIndex:range.location + 1].mutableCopy;
        NSRange r = [tz rangeOfString:@":" options:NSBackwardsSearch];
        if (r.location != NSNotFound) {
            [tz replaceCharactersInRange:r withString:@""];
        }

        seconds = tz.integerValue;
        if (seconds >= 100) {
            seconds *= 6 * 6;
        } else {
            seconds *= 60 * 60;
        }
    }

    return [NSTimeZone timeZoneForSecondsFromGMT:f * seconds];
}
