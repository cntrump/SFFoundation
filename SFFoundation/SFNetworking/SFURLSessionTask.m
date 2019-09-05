//
//  SFURLSessionTask.m
//  SFFoundation
//
//  Created by vvveiii on 2019/9/5.
//  Copyright © 2019 lvv. All rights reserved.
//

#import "SFURLSessionTask.h"
#import <objc/runtime.h>

@implementation SFURLSessionTaskDelegator
@end

@implementation SFURLSessionDataTaskDelegator
@end

@implementation SFURLSessionDownloadTaskDelegator
@end

@implementation SFURLSessionStreamTaskDelegator
@end

@implementation NSURLSessionTask (SFURLSessionTaskDelegator)

- (SFURLSessionTaskDelegator *)sf_taskDelegator {
    SFURLSessionTaskDelegator *delegator = objc_getAssociatedObject(self, @selector(sf_taskDelegator));
    if (!delegator) {
        if ([self isKindOfClass:NSURLSessionDataTask.class]) {
            delegator = [[SFURLSessionDataTaskDelegator alloc] init];
        } else if ([self isKindOfClass:NSURLSessionDownloadTask.class]) {
            delegator = [[SFURLSessionDownloadTaskDelegator alloc] init];
        } else {
#if SF_MACOS
            if (@available(macOS 10.11, *)) {
#endif
#if SF_IOS
            if (@available(iOS 9.0, *)) {
#endif
                if ([self isKindOfClass:NSURLSessionStreamTask.class]) {
                    delegator = [[SFURLSessionStreamTaskDelegator alloc] init];
                }
            }

            delegator = delegator ? : [[SFURLSessionTaskDelegator alloc] init];
        }

        objc_setAssociatedObject(self, @selector(sf_taskDelegator), delegator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    return delegator;
}

@end
