//
//  SFURLSessionTask.h
//  SFFoundation
//
//  Created by vvveiii on 2019/9/5.
//  Copyright © 2019 lvv. All rights reserved.
//

@interface SFURLSessionTaskDelegator : NSObject

@property(nonatomic, copy) void (^willBeginDelayedRequest)(NSURLRequest *request, void (^completionHandler)(NSURLSessionDelayedRequestDisposition disposition, NSURLRequest *newRequest)) API_AVAILABLE(macos(10.13), ios(11.0), watchos(4.0), tvos(11.0));

@property(nonatomic, copy) void (^taskIsWaitingForConnectivity)(void);

@property(nonatomic, copy) void (^willPerformHTTPRedirection)(NSHTTPURLResponse *response, NSURLRequest *request, void (^completionHandler)(NSURLRequest *));

@property(nonatomic, copy) void (^didReceiveChallenge)(NSURLAuthenticationChallenge *challenge, void (^completionHandler)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential));

@property(nonatomic, copy) void (^needNewBodyStream)(void (^completionHandler)(NSInputStream *bodyStream));

@property(nonatomic, copy) void (^didSendBodyData)(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend);

@property(nonatomic, copy) void (^didFinishCollectingMetrics)(NSURLSessionTaskMetrics *metrics) API_AVAILABLE(macosx(10.12), ios(10.0), watchos(3.0), tvos(10.0));

@property(nonatomic, copy) void (^didCompleteWithError)(NSError *error);

@end

#pragma mark -

@interface SFURLSessionDataTaskDelegator : SFURLSessionTaskDelegator

@property(nonatomic, copy) void (^didReceiveResponse)(NSURLResponse *response, void (^completionHandler)(NSURLSessionResponseDisposition disposition));

@property(nonatomic, copy) void (^didBecomeDownloadTask)(NSURLSessionDownloadTask *downloadTask);

@property(nonatomic, copy) void (^didBecomeStreamTask)(NSURLSessionStreamTask *streamTask) API_AVAILABLE(macosx(10.11), ios(9.0), watchos(3.0), tvos(9.0));

@property(nonatomic, copy) void (^didReceiveData)(NSData *data);

@property(nonatomic, copy) void (^willCacheResponse)(NSCachedURLResponse *proposedResponse, void (^completionHandler)(NSCachedURLResponse *cachedResponse));

@end

#pragma mark -

@interface SFURLSessionDownloadTaskDelegator : SFURLSessionTaskDelegator

@property(nonatomic, copy) void (^didFinishDownloadingToURL)(NSURL *location);

@property(nonatomic, copy) void (^didWriteData)(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite);

@property(nonatomic, copy) void (^didResumeAtOffset)(int64_t fileOffset, int64_t expectedTotalBytes);

@end

#pragma mark -

NS_CLASS_AVAILABLE(10_11, 9_0)
@interface SFURLSessionStreamTaskDelegator : SFURLSessionTaskDelegator

@property(nonatomic, copy) void (^readClosedForStreamTask)(void);

@property(nonatomic, copy) void (^writeClosedForStreamTask)(void);

@property(nonatomic, copy) void (^betterRouteDiscoveredForStreamTask)(void);

@property(nonatomic, copy) void (^didBecomeInputStream)(NSInputStream *inputStream, NSOutputStream *outputStream);

@end

#pragma mark -

NS_CLASS_AVAILABLE(10_15, 13_0)
@interface SFURLSessionWebSocketTaskDelegator : SFURLSessionTaskDelegator

@property(nonatomic, copy) void (^didOpenWithProtocol)(NSString *protocol);

@property(nonatomic, copy) void (^didCloseWithCode)(NSURLSessionWebSocketCloseCode closeCode, NSData *reason);

@end

#pragma mark -

@interface NSURLSessionTask (SFURLSessionTaskDelegator)

@property(nonatomic, readonly) SFURLSessionTaskDelegator *sf_delegator;

@end

#pragma mark -

@interface NSURLSessionDataTask (SFURLSessionDataTaskDelegator)

@property(nonatomic, readonly) SFURLSessionDataTaskDelegator *sf_delegator;

@end

#pragma mark -

@interface NSURLSessionDownloadTask (SFURLSessionDownloadTaskDelegator)

@property(nonatomic, readonly) SFURLSessionDownloadTaskDelegator *sf_delegator;

@end

#pragma mark -

NS_CLASS_AVAILABLE(10_11, 9_0)
@interface NSURLSessionStreamTask (SFURLSessionStreamTaskDelegator)

@property(nonatomic, readonly) SFURLSessionStreamTaskDelegator *sf_delegator;

@end

#pragma mark -

NS_CLASS_AVAILABLE(10_15, 13_0)
@interface NSURLSessionWebSocketTask (SFURLSessionWebSocketTaskDelegator)

@property(nonatomic, readonly) SFURLSessionWebSocketTaskDelegator *sf_delegator;

@end

NS_CLASS_AVAILABLE(10_15, 13_0)
@interface NSURLSessionWebSocketTask (SFURLSessionWebSocketTask)

- (void)sendTextMessage:(NSString *)text completionHandler:(void (^)(NSError *error))completionHandler;
- (void)sendDataMessage:(NSData *)data completionHandler:(void (^)(NSError *error))completionHandler;

@end

