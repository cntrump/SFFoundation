//
//  NSDate+SFTime.h
//  SFFoundation
//
//  Created by vvveiii on 2019/6/28.
//  Copyright © 2019 lvv. All rights reserved.
//

@interface NSDate (SFTime)

- (BOOL)sf_sameYear:(NSDate *)date inTimezone:(NSTimeZone *)timezone;
- (BOOL)sf_sameMonth:(NSDate *)date inTimezone:(NSTimeZone *)timezone;
- (BOOL)sf_sameDay:(NSDate *)date inTimezone:(NSTimeZone *)timezone;

@end
