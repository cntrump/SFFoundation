//
//  SFDeInitHelper.h
//  SFFoundation
//
//  Created by vvveiii on 2019/9/18.
//  Copyright © 2019 lvv. All rights reserved.
//

@interface NSObject (SFDeInitHelper)

- (void)sf_addDeInitBlock:(void (^)(void))block;  // block called when dealloc

@end
