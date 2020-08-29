//
//  SFRuntime.h
//  SFFoundation
//
//  Created by vvveiii on 2019/6/27.
//  Copyright © 2019 lvv. All rights reserved.
//

SF_EXTERN_C_BEGIN

void sf_swizzleClass(Class cls, SEL originalSelector, SEL swizzledSelector);
void sf_swizzleInstance(Class cls, SEL originalSelector, SEL swizzledSelector);

SF_EXTERN_C_END
