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

@implementation SFURLSessionWebSocketTaskDelegator
@end

@implementation NSURLSessionWebSocketTask (SFURLSessionWebSocketTask)

- (void)sendTextMessage:(NSString *)text completionHandler:(void (^)(NSError *error))completionHandler {
    [self sendMessage:[[NSURLSessionWebSocketMessage alloc] initWithString:text] completionHandler:completionHandler];
}

- (void)sendDataMessage:(NSData *)data completionHandler:(void (^)(NSError *error))completionHandler {
    [self sendMessage:[[NSURLSessionWebSocketMessage alloc] initWithData:data] completionHandler:completionHandler];
}

@end

@implementation NSURLSessionTask (SFURLSessionTaskDelegator)

- (void)setSf_delegator:(SFURLSessionTaskDelegator *)delegator {
    objc_setAssociatedObject(self, @selector(sf_delegator), delegator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SFURLSessionTaskDelegator *)sf_delegator {
    SFURLSessionTaskDelegator *delegator = objc_getAssociatedObject(self, @selector(sf_delegator));
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

#if SF_MACOS
            if (@available(macOS 10.15, *)) {
#endif
#if SF_IOS
            if (@available(iOS 13.0, *)) {
#endif
                if ([self isKindOfClass:NSURLSessionWebSocketTask.class]) {
                    delegator = [[SFURLSessionWebSocketTaskDelegator alloc] init];
                }
            }

            if (!delegator) {
                delegator = [[SFURLSessionTaskDelegator alloc] init];
            }
        }

        self.sf_delegator = delegator;
    }

    return delegator;
}

@end
