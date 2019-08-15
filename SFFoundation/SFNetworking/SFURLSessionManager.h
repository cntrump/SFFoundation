//
//  SFURLSessionManager.h
//  SFFoundation
//
//  Created by vvveiii on 2019/6/26.
//  Copyright © 2019 lvv. All rights reserved.
//

extern NSErrorDomain SFHTTPErrorDomain;

extern NSString *SFHTTPMethodGET;
extern NSString *SFHTTPMethodHEAD;
extern NSString *SFHTTPMethodPOST;
extern NSString *SFHTTPMethodPUT;
extern NSString *SFHTTPMethodDELETE;
extern NSString *SFHTTPMethodCONNECT;
extern NSString *SFHTTPMethodOPTIONS;
extern NSString *SFHTTPMethodTRACE;
extern NSString *SFHTTPMethodPATCH;

typedef void (^SFURLCompletionHandler)(NSURLRequest *request, NSURLResponse *response, NSData *data, NSError *error);

@interface SFURLSessionManager : NSObject

+ (instancetype)manager;

- (void)send:(NSString *)HTTPMethod
         url:(NSString *)url
     headers:(NSDictionary<NSString *, NSString *> *)headers
        body:(NSData *)body
  completion:(SFURLCompletionHandler)completionHandler;

@end


@interface SFURLSessionManager (SFHTTP)

- (void)getWithURL:(NSString *)url
           headers:(NSDictionary<NSString *, NSString *> *)headers
              body:(NSData *)body
        completion:(SFURLCompletionHandler)completionHandler;

- (void)headWithURL:(NSString *)url
            headers:(NSDictionary<NSString *, NSString *> *)headers
               body:(NSData *)body
         completion:(SFURLCompletionHandler)completionHandler;

- (void)postWithURL:(NSString *)url
            headers:(NSDictionary<NSString *, NSString *> *)headers
               body:(NSData *)body
         completion:(SFURLCompletionHandler)completionHandler;

- (void)putWithURL:(NSString *)url
           headers:(NSDictionary<NSString *, NSString *> *)headers
              body:(NSData *)body
        completion:(SFURLCompletionHandler)completionHandler;

- (void)deleteWithURL:(NSString *)url
              headers:(NSDictionary<NSString *, NSString *> *)headers
                 body:(NSData *)body
           completion:(SFURLCompletionHandler)completionHandler;

- (void)connectWithURL:(NSString *)url
               headers:(NSDictionary<NSString *, NSString *> *)headers
                  body:(NSData *)body
            completion:(SFURLCompletionHandler)completionHandler;

- (void)optionsWithURL:(NSString *)url
               headers:(NSDictionary<NSString *, NSString *> *)headers
                  body:(NSData *)body
            completion:(SFURLCompletionHandler)completionHandler;

- (void)traceWithURL:(NSString *)url
             headers:(NSDictionary<NSString *, NSString *> *)headers
                body:(NSData *)body
          completion:(SFURLCompletionHandler)completionHandler;

- (void)patchWithURL:(NSString *)url
             headers:(NSDictionary<NSString *, NSString *> *)headers
                body:(NSData *)body
          completion:(SFURLCompletionHandler)completionHandler;

@end
