//
//  SFFoundation.m
//  SFFoundation
//
//  Created by vvveiii on 2019/9/16.
//  Copyright © 2019 lvv. All rights reserved.
//

static BOOL EnableAssertions = NO;

@implementation SFFoundation

+ (void)setEnableAssertions:(BOOL)enableAssertions {
    EnableAssertions = enableAssertions;
}

+ (BOOL)enableAssertions {
    return EnableAssertions;
}

@end
