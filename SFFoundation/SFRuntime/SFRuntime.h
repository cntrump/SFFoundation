//
//  SFRuntime.h
//  SFFoundation
//
//  Created by vvveiii on 2019/6/27.
//  Copyright © 2019 lvv. All rights reserved.
//

@interface NSObject (SFRuntime)

- (id)sf_getIvarValueWithName:(NSString *)name;

@end

SF_EXTERN_C_BEGIN

void sf_swizzleClass(Class cls, SEL originalSelector, SEL swizzledSelector);
void sf_swizzleInstance(Class cls, SEL originalSelector, SEL swizzledSelector);

SF_EXTERN_C_END

#if SF_IOS
@interface UIViewController (SFRuntime)

@property(nonatomic, copy) void (^sf_viewWillLayoutSubviewsBlock)(void);
@property(nonatomic, copy) void (^sf_viewDidLayoutSubviewsBlock)(void);

@end

@interface UIPresentationController (SFRuntime)

@property(nonatomic, copy) void (^sf_containerViewWillLayoutSubviewsBlock)(void);
@property(nonatomic, copy) void (^sf_containerViewDidLayoutSubviewsBlock)(void);

@end

@interface UIView (SFRuntime)

@property(nonatomic, copy) void (^sf_drawRectBlock)(CGRect rect);
@property(nonatomic, copy) void (^sf_layoutSubviewsBlock)(void);
@property(nonatomic, copy) void (^sf_tintColorDidChangeBlock)(void);

@end
#endif
