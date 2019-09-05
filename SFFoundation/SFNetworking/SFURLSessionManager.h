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

- (void)http:(NSString *)HTTPMethod
         url:(NSURL *)url
     headers:(NSDictionary<NSString *, NSString *> *)headers
        body:(NSData *)body
  completion:(SFURLCompletionHandler)completionHandler;

@end


@interface SFURLSessionManager (SFHTTP)

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
