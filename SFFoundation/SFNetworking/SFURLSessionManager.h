//
//  SFURLSessionManager.h
//  SFFoundation
//
//  Created by vvveiii on 2019/6/26.
//  Copyright © 2019 lvv. All rights reserved.
//

extern NSErrorDomain SFHTTPErrorDomain;

extern NSString *SFHTTPGET;
extern NSString *SFHTTPHEAD;
extern NSString *SFHTTPPOST;
extern NSString *SFHTTPPUT;
extern NSString *SFHTTPDELETE;
extern NSString *SFHTTPCONNECT;
extern NSString *SFHTTPOPTIONS;
extern NSString *SFHTTPTRACE;
extern NSString *SFHTTPPATCH;

typedef void (^SFURLCompletionHandler)(NSURLRequest *request, NSURLResponse *response, NSData *data, NSError *error);

@interface SFURLSessionManager : NSObject

+ (instancetype)manager;

+ (instancetype)managerWithConfiguration:(NSURLSessionConfiguration *)configuration;

- (void)invalidateAndCancel;
- (void)finishTasksAndInvalidate;

@end


@interface SFURLSessionManager (SFHTTP)

- (void)http:(NSString *)HTTPMethod
       url:(NSURL *)url
   headers:(NSDictionary<NSString *, NSString *> *)headers
      body:(NSData *)body
completion:(SFURLCompletionHandler)completionHandler;

- (void)httpGET:(NSURL *)url
           headers:(NSDictionary<NSString *, NSString *> *)headers
        completion:(SFURLCompletionHandler)completionHandler;

- (void)httpHEAD:(NSURL *)url
            headers:(NSDictionary<NSString *, NSString *> *)headers
         completion:(SFURLCompletionHandler)completionHandler;

- (void)httpPOST:(NSURL *)url
            headers:(NSDictionary<NSString *, NSString *> *)headers
               body:(NSData *)body
         completion:(SFURLCompletionHandler)completionHandler;

- (void)httpPUT:(NSURL *)url
           headers:(NSDictionary<NSString *, NSString *> *)headers
              body:(NSData *)body
        completion:(SFURLCompletionHandler)completionHandler;

- (void)httpDELETE:(NSURL *)url
              headers:(NSDictionary<NSString *, NSString *> *)headers
           completion:(SFURLCompletionHandler)completionHandler;

- (void)httpCONNECT:(NSURL *)url
               headers:(NSDictionary<NSString *, NSString *> *)headers
                  body:(NSData *)body
            completion:(SFURLCompletionHandler)completionHandler;

- (void)httpOPTIONS:(NSURL *)url
               headers:(NSDictionary<NSString *, NSString *> *)headers
            completion:(SFURLCompletionHandler)completionHandler;

- (void)httpTRACE:(NSURL *)url
             headers:(NSDictionary<NSString *, NSString *> *)headers
          completion:(SFURLCompletionHandler)completionHandler;

- (void)httpPATCH:(NSURL *)url
             headers:(NSDictionary<NSString *, NSString *> *)headers
                body:(NSData *)body
          completion:(SFURLCompletionHandler)completionHandler;

@end

#if (SF_MACOS && __MAC_OS_X_VERSION_MAX_ALLOWED >= __MAC_10_15) || (SF_IOS && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
@interface SFURLSessionManager (SFWebSocket)

- (NSURLSessionWebSocketTask *)webSocketTaskWithURL:(NSURL *)url
                                            didOpen:(void (^)(NSString *protocol))didOpen
                                           didClose:(void (^)(NSURLSessionWebSocketCloseCode closeCode, NSData *reson))didClose
                                         completion:(void (^)(NSError *error))completionHandler API_AVAILABLE(macos(10.15), ios(13.0), watchos(6.0), tvos(13.0));

- (NSURLSessionWebSocketTask *)webSocketTaskWithURL:(NSURL *)url
                                          protocols:(NSArray<NSString *>*)protocols
                                            didOpen:(void (^)(NSString *protocol))didOpen
                                           didClose:(void (^)(NSURLSessionWebSocketCloseCode closeCode, NSData *reson))didClose
                                         completion:(void (^)(NSError *error))completionHandler API_AVAILABLE(macos(10.15), ios(13.0), watchos(6.0), tvos(13.0));

- (NSURLSessionWebSocketTask *)webSocketTaskWithRequest:(NSURLRequest *)request
                                                didOpen:(void (^)(NSString *protocol))didOpen
                                               didClose:(void (^)(NSURLSessionWebSocketCloseCode closeCode, NSData *reson))didClose
                                             completion:(void (^)(NSError *error))completionHandler API_AVAILABLE(macos(10.15), ios(13.0), watchos(6.0), tvos(13.0));

@end
#endif
