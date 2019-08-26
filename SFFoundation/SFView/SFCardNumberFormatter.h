//
//  SFCardNumberFormatter.h
//  SFFoundation
//
//  Created by vvveiii on 2019/8/26.
//  Copyright © 2019 lvv. All rights reserved.
//

@interface SFCardNumberFormatter : NSFormatter

@property(nonatomic, copy) NSString *separator;     // default is "-"
@property(nonatomic, assign) NSUInteger digitsUnit; // default is 4

- (NSString *)cardNumberFromString:(NSString *)string;

- (NSString *)stringFromCardNumber:(NSString *)cardNumber;

@end
