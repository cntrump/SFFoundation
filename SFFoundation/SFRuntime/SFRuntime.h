//
//  SFRuntime.h
//  SFFoundation
//
//  Created by vvveiii on 2019/6/27.
//  Copyright © 2019 lvv. All rights reserved.
//

@interface NSObject (SFRuntime)

+ (void)sf_swizzleMethod:(SEL)originalSelector with:(SEL)swizzledSelector;

- (id)sf_getIvarValueWithName:(NSString *)name;

@end

SF_EXTERN_C_BEGIN

void sf_swizzle(Class cls, SEL originalSel, Class newClass, SEL newSel);

SF_EXTERN_C_END
