//
//  SFURLSessionManager.m
//  SFFoundation
//
//  Created by vvveiii on 2019/6/26.
//  Copyright © 2019 lvv. All rights reserved.
//

#import "SFURLSessionManager.h"
#import "SFURLSessionTask.h"
#import <mutex>

NSErrorDomain SFHTTPErrorDomain = @"SFHTTPErrorDomain";

NSString *SFHTTPGET      = @"GET";
NSString *SFHTTPHEAD     = @"HEAD";
NSString *SFHTTPPOST     = @"POST";
NSString *SFHTTPPUT      = @"PUT";
NSString *SFHTTPDELETE   = @"DELETE";
NSString *SFHTTPCONNECT  = @"CONNECT";
NSString *SFHTTPOPTIONS  = @"OPTIONS";
NSString *SFHTTPTRACE    = @"TRACE";
NSString *SFHTTPPATCH    = @"PATCH";

#define HTTP_CODE_400   (400)

@interface SFURLSessionManager () {
    NSOperationQueue *_delegateQueue;
    NSURLSession *_session;
    NSURLSessionConfiguration *_configuration;
    std::mutex _sessionMutex;
}

@property(nonatomic, readonly) NSURLSession *session;

@end

@implementation SFURLSessionManager

+ (instancetype)manager {
    return [[self alloc] initWithConfiguration:nil];
}

+ (instancetype)managerWithConfiguration:(NSURLSessionConfiguration *)configuration {
    return [[self alloc] initWithConfiguration:configuration];
}

- (instancetype)initWithConfiguration:(NSURLSessionConfiguration *)configuration {
    if (self = [super init]) {
        _delegateQueue = [[NSOperationQueue alloc] init];
        _delegateQueue.maxConcurrentOperationCount = 1;

        _configuration = [configuration copy];
        if (!_configuration) {
            _configuration = [NSURLSessionConfiguration.defaultSessionConfiguration copy];
        }
    }

    return self;
}

- (NSURLSession *)session {
    _sessionMutex.lock();

    if (!_session) {
        _session = [NSURLSession sessionWithConfiguration:_configuration
                                                 delegate:(id<NSURLSessionDelegate>)self
                                            delegateQueue:_delegateQueue];
    }

    _sessionMutex.unlock();

    return _session;
}

- (void)invalidateAndCancel {
    _sessionMutex.lock();
    [_session invalidateAndCancel];
    _session = nil;
    _sessionMutex.unlock();
}

- (void)finishTasksAndInvalidate {
    _sessionMutex.lock();
    [_session finishTasksAndInvalidate];
    _session = nil;
    _sessionMutex.unlock();
}

#pragma mark - NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
willBeginDelayedRequest:(NSURLRequest *)request
 completionHandler:(void (^)(NSURLSessionDelayedRequestDisposition disposition, NSURLRequest * _Nullable newRequest))completionHandler
API_AVAILABLE(macos(10.13), ios(11.0), watchos(4.0), tvos(11.0)) {
    if (task.sf_delegator.willBeginDelayedRequest) {
        task.sf_delegator.willBeginDelayedRequest(request, completionHandler);
    } else {
        completionHandler(NSURLSessionDelayedRequestContinueLoading, nil);
    }
}

- (void)URLSession:(NSURLSession *)session taskIsWaitingForConnectivity:(NSURLSessionTask *)task
API_AVAILABLE(macos(10.13), ios(11.0), watchos(4.0), tvos(11.0)) {
    if (task.sf_delegator.taskIsWaitingForConnectivity) {
        task.sf_delegator.taskIsWaitingForConnectivity();
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
willPerformHTTPRedirection:(NSHTTPURLResponse *)response
        newRequest:(NSURLRequest *)request
 completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler {
    if (task.sf_delegator.willPerformHTTPRedirection) {
        task.sf_delegator.willPerformHTTPRedirection(response, request, completionHandler);
    } else {
        completionHandler(request);
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    if (task.sf_delegator.didReceiveChallenge) {
        task.sf_delegator.didReceiveChallenge(challenge, completionHandler);
    } else {
        completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
 needNewBodyStream:(void (^)(NSInputStream * _Nullable bodyStream))completionHandler {
    if (task.sf_delegator.needNewBodyStream) {
        task.sf_delegator.needNewBodyStream(completionHandler);
    } else {
        completionHandler(nil);
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
    if (task.sf_delegator.didSendBodyData) {
        task.sf_delegator.didSendBodyData(bytesSent, totalBytesSent, totalBytesExpectedToSend);
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didFinishCollectingMetrics:(NSURLSessionTaskMetrics *)metrics API_AVAILABLE(macosx(10.12), ios(10.0), watchos(3.0), tvos(10.0)) {
    if (task.sf_delegator.didFinishCollectingMetrics) {
        task.sf_delegator.didFinishCollectingMetrics(metrics);
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error {
    if (task.sf_delegator.didCompleteWithError) {
        task.sf_delegator.didCompleteWithError(error);
    }
}

#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    if (dataTask.sf_delegator.didReceiveResponse) {
        dataTask.sf_delegator.didReceiveResponse(response, completionHandler);
    } else {
        completionHandler(NSURLSessionResponseAllow);
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask {
    if (dataTask.sf_delegator.didBecomeDownloadTask) {
        dataTask.sf_delegator.didBecomeDownloadTask(downloadTask);
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didBecomeStreamTask:(NSURLSessionStreamTask *)streamTask API_AVAILABLE(macosx(10.11), ios(9.0), watchos(3.0), tvos(9.0)) {
    if (dataTask.sf_delegator.didBecomeStreamTask) {
        dataTask.sf_delegator.didBecomeStreamTask(streamTask);
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    if (dataTask.sf_delegator.didReceiveData) {
        dataTask.sf_delegator.didReceiveData(data);
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
 willCacheResponse:(NSCachedURLResponse *)proposedResponse
 completionHandler:(void (^)(NSCachedURLResponse * _Nullable cachedResponse))completionHandler {
    if (dataTask.sf_delegator.willCacheResponse) {
        dataTask.sf_delegator.willCacheResponse(proposedResponse, completionHandler);
    } else {
        completionHandler(proposedResponse);
    }
}

#pragma mark - NSURLSessionDownloadDelegate

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
    if (downloadTask.sf_delegator.didFinishDownloadingToURL) {
        downloadTask.sf_delegator.didFinishDownloadingToURL(location);
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    if (downloadTask.sf_delegator.didWriteData) {
        downloadTask.sf_delegator.didWriteData(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes {
    if (downloadTask.sf_delegator.didResumeAtOffset) {
        downloadTask.sf_delegator.didResumeAtOffset(fileOffset, expectedTotalBytes);
    }
}

#pragma mark - NSURLSessionStreamDelegate

- (void)URLSession:(NSURLSession *)session readClosedForStreamTask:(NSURLSessionStreamTask *)streamTask API_AVAILABLE(macosx(10.11), ios(9.0), watchos(3.0), tvos(9.0)) {
    if (streamTask.sf_delegator.readClosedForStreamTask) {
        streamTask.sf_delegator.readClosedForStreamTask();
    }
}

- (void)URLSession:(NSURLSession *)session writeClosedForStreamTask:(NSURLSessionStreamTask *)streamTask API_AVAILABLE(macosx(10.11), ios(9.0), watchos(3.0), tvos(9.0)) {
    if (streamTask.sf_delegator.writeClosedForStreamTask) {
        streamTask.sf_delegator.writeClosedForStreamTask();
    }
}

- (void)URLSession:(NSURLSession *)session betterRouteDiscoveredForStreamTask:(NSURLSessionStreamTask *)streamTask API_AVAILABLE(macosx(10.11), ios(9.0), watchos(3.0), tvos(9.0)) {
    if (streamTask.sf_delegator.betterRouteDiscoveredForStreamTask) {
        streamTask.sf_delegator.betterRouteDiscoveredForStreamTask();
    }
}

- (void)URLSession:(NSURLSession *)session streamTask:(NSURLSessionStreamTask *)streamTask
didBecomeInputStream:(NSInputStream *)inputStream
      outputStream:(NSOutputStream *)outputStream API_AVAILABLE(macosx(10.11), ios(9.0), watchos(3.0), tvos(9.0)) {
    if (streamTask.sf_delegator.didBecomeInputStream) {
        streamTask.sf_delegator.didBecomeInputStream(inputStream, outputStream);
    }
}

#pragma mark - NSURLSessionWebSocketDelegate

#if (SF_MACOS && __MAC_OS_X_VERSION_MAX_ALLOWED >= __MAC_10_15) || (SF_IOS && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
- (void)URLSession:(NSURLSession *)session webSocketTask:(NSURLSessionWebSocketTask *)webSocketTask didOpenWithProtocol:(NSString * _Nullable) protocol API_AVAILABLE(macos(10.15), ios(13.0), watchos(6.0), tvos(13.0)) {
    if (webSocketTask.sf_delegator.didOpenWithProtocol) {
        webSocketTask.sf_delegator.didOpenWithProtocol(protocol);
    }
}

- (void)URLSession:(NSURLSession *)session webSocketTask:(NSURLSessionWebSocketTask *)webSocketTask didCloseWithCode:(NSURLSessionWebSocketCloseCode)closeCode reason:(NSData * _Nullable)reason API_AVAILABLE(macos(10.15), ios(13.0), watchos(6.0), tvos(13.0)) {
    if (webSocketTask.sf_delegator.didCloseWithCode) {
        webSocketTask.sf_delegator.didCloseWithCode(closeCode, reason);
    }
}
#endif

@end


@implementation SFURLSessionManager (SFHTTP)

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request completionHandler:(SFURLCompletionHandler)completionHandler {
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request];

    __block NSURLResponse *response_ = nil;
    __block NSMutableData *respData_ = NSMutableData.data;

    dataTask.sf_delegator.didReceiveResponse = ^(NSURLResponse *response, void (^completionHandler)(NSURLSessionResponseDisposition disposition)) {
        response_ = response;
        completionHandler(NSURLSessionResponseAllow);
    };

    dataTask.sf_delegator.didReceiveData = ^(NSData *data) {
        [respData_ appendData:data];
    };

    dataTask.sf_delegator.didCompleteWithError = ^(NSError *error) {
        if ([response_ isKindOfClass:NSHTTPURLResponse.class]) {
            NSHTTPURLResponse *resp = (NSHTTPURLResponse *)response_;
            NSInteger statusCode = resp.statusCode;
            if (statusCode >= HTTP_CODE_400) {
                error = [NSError errorWithDomain:SFHTTPErrorDomain code:statusCode userInfo:@{
                                                                                              @"method": request.HTTPMethod,
                                                                                              @"url": request.URL.absoluteString,
                                                                                              NSLocalizedDescriptionKey: [NSString stringWithFormat:@"server return %ld", (long)statusCode]
                                                                                              }];
            }
        }

        if (completionHandler) {
            completionHandler(request, response_, respData_, error);
        }
    };

    return dataTask;
}

- (void)http:(NSString *)HTTPMethod
         url:(NSURL *)url
     headers:(NSDictionary<NSString *, NSString *> *)headers
        body:(NSData *)body
  completion:(SFURLCompletionHandler)completionHandler {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = HTTPMethod;
    request.HTTPBody = body;

    [headers enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
        [request setValue:obj forHTTPHeaderField:key];
    }];

    NSURLSessionDataTask *dataTask = [self dataTaskWithRequest:request completionHandler:completionHandler];
    [dataTask resume];
}

- (void)httpGET:(NSURL *)url
           headers:(NSDictionary<NSString *, NSString *> *)headers
        completion:(SFURLCompletionHandler)completionHandler {
    [self http:SFHTTPGET url:url headers:headers body:nil completion:completionHandler];
}

- (void)httpHEAD:(NSURL *)url
            headers:(NSDictionary<NSString *, NSString *> *)headers
         completion:(SFURLCompletionHandler)completionHandler {
    [self http:SFHTTPHEAD url:url headers:headers body:nil completion:completionHandler];
}

- (void)httpPOST:(NSURL *)url
            headers:(NSDictionary<NSString *, NSString *> *)headers
               body:(NSData *)body
         completion:(SFURLCompletionHandler)completionHandler {
    [self http:SFHTTPPOST url:url headers:headers body:body completion:completionHandler];
}

- (void)httpPUT:(NSURL *)url
           headers:(NSDictionary<NSString *, NSString *> *)headers
              body:(NSData *)body
        completion:(SFURLCompletionHandler)completionHandler {
    [self http:SFHTTPPUT url:url headers:headers body:body completion:completionHandler];
}

- (void)httpDELETE:(NSURL *)url
              headers:(NSDictionary<NSString *, NSString *> *)headers
           completion:(SFURLCompletionHandler)completionHandler {
    [self http:SFHTTPDELETE url:url headers:headers body:nil completion:completionHandler];
}

- (void)httpCONNECT:(NSURL *)url
               headers:(NSDictionary<NSString *, NSString *> *)headers
                  body:(NSData *)body
            completion:(SFURLCompletionHandler)completionHandler {
    [self http:SFHTTPCONNECT url:url headers:headers body:body completion:completionHandler];
}

- (void)httpOPTIONS:(NSURL *)url
               headers:(NSDictionary<NSString *, NSString *> *)headers
            completion:(SFURLCompletionHandler)completionHandler {
    [self http:SFHTTPOPTIONS url:url headers:headers body:nil completion:completionHandler];
}

- (void)httpTRACE:(NSURL *)url
             headers:(NSDictionary<NSString *, NSString *> *)headers
          completion:(SFURLCompletionHandler)completionHandler {
    [self http:SFHTTPTRACE url:url headers:headers body:nil completion:completionHandler];
}

- (void)httpPATCH:(NSURL *)url
             headers:(NSDictionary<NSString *, NSString *> *)headers
                body:(NSData *)body
          completion:(SFURLCompletionHandler)completionHandler {
    [self http:SFHTTPPATCH url:url headers:headers body:body completion:completionHandler];
}

@end

#if (SF_MACOS && __MAC_OS_X_VERSION_MAX_ALLOWED >= __MAC_10_15) || (SF_IOS && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
@implementation SFURLSessionManager (SFWebSocket)

- (NSURLSessionWebSocketTask *)webSocketWithURL:(NSURL *)url API_AVAILABLE(macos(10.15), ios(13.0), watchos(6.0), tvos(13.0)) {
    return [self webSocketWithURL:url protocols:nil];
}

- (NSURLSessionWebSocketTask *)webSocketWithURL:(NSURL *)url protocols:(NSArray<NSString *>*)protocols API_AVAILABLE(macos(10.15), ios(13.0), watchos(6.0), tvos(13.0)) {
    NSURLSessionWebSocketTask *webSocketTask = protocols ?
                                                [self.session webSocketTaskWithURL:url protocols:protocols] :
                                                [self.session webSocketTaskWithURL:url];

    return webSocketTask;
}

- (NSURLSessionWebSocketTask *)webSocketWithRequest:(NSURLRequest *)request API_AVAILABLE(macos(10.15), ios(13.0), watchos(6.0), tvos(13.0)) {
    NSURLSessionWebSocketTask *webSocketTask = [self.session webSocketTaskWithRequest:request];

    return webSocketTask;
}

@end
#endif
