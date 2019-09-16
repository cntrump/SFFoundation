//
//  SFFoundation.m
//  SFFoundation
//
//  Created by vvveiii on 2019/9/16.
//  Copyright © 2019 lvv. All rights reserved.
//

static BOOL EnableBlockAssertions = NO;

@implementation SFFoundation

+ (void)setEnableBlockAssertions:(BOOL)enableBlockAssertions {
    EnableBlockAssertions = enableBlockAssertions;
}

+ (BOOL)enableBlockAssertions {
    return EnableBlockAssertions;
}

@end
