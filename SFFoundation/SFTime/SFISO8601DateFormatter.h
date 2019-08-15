//
//  SFISO8601DateFormatter.h
//  SFFoundation
//
//  Created by vvveiii on 2019/6/27.
//  Copyright © 2019 lvv. All rights reserved.
//

typedef NS_OPTIONS(NSUInteger, SFISO8601DateFormatOptions) {
    /* The format for year is inferred based on whether or not the week of year option is specified.
     - if week of year is present, "YYYY" is used to display week dates.
     - if week of year is not present, "yyyy" is used by default.
     */
    SFISO8601DateFormatWithYear = BIT(0),
    SFISO8601DateFormatWithMonth = BIT(1),

    SFISO8601DateFormatWithWeekOfYear = BIT(2),  // This includes the "W" prefix (e.g. "W49")

    /* The format for day is inferred based on provided options.
     - if month is not present, day of year ("DDD") is used.
     - if month is present, day of month ("dd") is used.
     - if either weekOfMonth or weekOfYear is present, local day of week ("ee") is used.
     */
    SFISO8601DateFormatWithDay = BIT(4),

    SFISO8601DateFormatWithTime = BIT(5),  // This uses the format "HHmmss"
    SFISO8601DateFormatWithTimeZone = BIT(6),

    SFISO8601DateFormatWithSpaceBetweenDateAndTime = BIT(7),  // Use space instead of "T"
    SFISO8601DateFormatWithDashSeparatorInDate = BIT(8),  // Add separator for date ("-")
    SFISO8601DateFormatWithColonSeparatorInTime = BIT(9),  // Add separator for time (":")
    SFISO8601DateFormatWithColonSeparatorInTimeZone = BIT(10),  // Add ":" separator in timezone (e.g. +08:00)
    SFISO8601DateFormatWithFractionalSeconds = BIT(11),  // Add 3 significant digits of fractional seconds (".SSS")

    SFISO8601DateFormatWithFullDate = (SFISO8601DateFormatWithYear|SFISO8601DateFormatWithMonth|SFISO8601DateFormatWithDay|SFISO8601DateFormatWithDashSeparatorInDate),
    SFISO8601DateFormatWithFullTime = (SFISO8601DateFormatWithTime|SFISO8601DateFormatWithColonSeparatorInTime|SFISO8601DateFormatWithTimeZone|SFISO8601DateFormatWithColonSeparatorInTimeZone),

    SFISO8601DateFormatWithInternetDateTime = (SFISO8601DateFormatWithFullDate|SFISO8601DateFormatWithFullTime),  // RFC 3339
};

@interface SFISO8601DateFormatter : NSDateFormatter

@property(nonatomic, assign) SFISO8601DateFormatOptions formatOptions;

+ (instancetype)dateFormatter;

- (NSDateComponents *)dateComponentsFromDate:(NSDate *)date;
- (NSDateComponents *)dateComponentsFromString:(NSString *)dateString;

@end


OBJC_EXTERN NSTimeZone *sf_timeZoneFromString(NSString *dateString);
