//
//  SFURLSessionManager.m
//  SFFoundation
//
//  Created by vvveiii on 2019/6/26.
//  Copyright © 2019 lvv. All rights reserved.
//

#import "SFURLSessionManager.h"

NSErrorDomain SFHTTPErrorDomain = @"SFHTTPErrorDomain";

NSString *SFHTTPMethodGET      = @"GET";
NSString *SFHTTPMethodHEAD     = @"HEAD";
NSString *SFHTTPMethodPOST     = @"POST";
NSString *SFHTTPMethodPUT      = @"PUT";
NSString *SFHTTPMethodDELETE   = @"DELETE";
NSString *SFHTTPMethodCONNECT  = @"CONNECT";
NSString *SFHTTPMethodOPTIONS  = @"OPTIONS";
NSString *SFHTTPMethodTRACE    = @"TRACE";
NSString *SFHTTPMethodPATCH    = @"PATCH";

#define HTTP_CODE_400   (400)

static BOOL HTTPMethodHasNoBody(NSString *HTTPMethod) {
    HTTPMethod = HTTPMethod.uppercaseString;

    return [HTTPMethod isEqualToString:SFHTTPMethodGET] ||
            [HTTPMethod isEqualToString:SFHTTPMethodHEAD] ||
            [HTTPMethod isEqualToString:SFHTTPMethodDELETE] ||
            [HTTPMethod isEqualToString:SFHTTPMethodOPTIONS] ||
            [HTTPMethod isEqualToString:SFHTTPMethodTRACE];
}

@interface SFURLSessionManager () {
    NSURLSession *_session;
}

@end

@implementation SFURLSessionManager

- (void)dealloc {
    [_session invalidateAndCancel];
}

+ (instancetype)manager {
    return [[self alloc] init];
}

- (instancetype)init {
    if (self = [super init]) {
        NSURLSessionConfiguration *config = NSURLSessionConfiguration.defaultSessionConfiguration;
        _session = [NSURLSession sessionWithConfiguration:config];
    }

    return self;
}

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request completionHandler:(SFURLCompletionHandler)completionHandler {
    NSURLSessionDataTask *dataTask = [_session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if ([response isKindOfClass:NSHTTPURLResponse.class]) {
            NSHTTPURLResponse *resp = (NSHTTPURLResponse *)response;
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
            completionHandler(request, response, data, error);
        }
    }];

    return dataTask;
}

- (void)send:(NSString *)HTTPMethod
         url:(NSString *)url
     headers:(NSDictionary<NSString *, NSString *> *)headers
        body:(NSData *)body
  completion:(SFURLCompletionHandler)completionHandler {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod = HTTPMethod;
    request.HTTPBody = HTTPMethodHasNoBody(HTTPMethod) ? nil : body;

    [headers enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
        [request setValue:obj forHTTPHeaderField:key];
    }];

    NSURLSessionDataTask *dataTask = [self dataTaskWithRequest:request completionHandler:completionHandler];
    [dataTask resume];
}

@end


@implementation SFURLSessionManager (SFHTTP)

- (void)getWithURL:(NSString *)url
           headers:(NSDictionary<NSString *, NSString *> *)headers
              body:(NSData *)body
        completion:(SFURLCompletionHandler)completionHandler {
    [self send:SFHTTPMethodGET url:url headers:headers body:body completion:completionHandler];
}

- (void)headWithURL:(NSString *)url
            headers:(NSDictionary<NSString *, NSString *> *)headers
               body:(NSData *)body
         completion:(SFURLCompletionHandler)completionHandler {
    [self send:SFHTTPMethodHEAD url:url headers:headers body:body completion:completionHandler];
}

- (void)postWithURL:(NSString *)url
            headers:(NSDictionary<NSString *, NSString *> *)headers
               body:(NSData *)body
         completion:(SFURLCompletionHandler)completionHandler {
    [self send:SFHTTPMethodPOST url:url headers:headers body:body completion:completionHandler];
}

- (void)putWithURL:(NSString *)url
           headers:(NSDictionary<NSString *, NSString *> *)headers
              body:(NSData *)body
        completion:(SFURLCompletionHandler)completionHandler {
    [self send:SFHTTPMethodPUT url:url headers:headers body:body completion:completionHandler];
}

- (void)deleteWithURL:(NSString *)url
              headers:(NSDictionary<NSString *, NSString *> *)headers
                 body:(NSData *)body
           completion:(SFURLCompletionHandler)completionHandler {
    [self send:SFHTTPMethodDELETE url:url headers:headers body:body completion:completionHandler];
}

- (void)connectWithURL:(NSString *)url
               headers:(NSDictionary<NSString *, NSString *> *)headers
                  body:(NSData *)body
            completion:(SFURLCompletionHandler)completionHandler {
    [self send:SFHTTPMethodCONNECT url:url headers:headers body:body completion:completionHandler];
}

- (void)optionsWithURL:(NSString *)url
               headers:(NSDictionary<NSString *, NSString *> *)headers
                  body:(NSData *)body
            completion:(SFURLCompletionHandler)completionHandler {
    [self send:SFHTTPMethodOPTIONS url:url headers:headers body:body completion:completionHandler];
}

- (void)traceWithURL:(NSString *)url
             headers:(NSDictionary<NSString *, NSString *> *)headers
                body:(NSData *)body
          completion:(SFURLCompletionHandler)completionHandler {
    [self send:SFHTTPMethodTRACE url:url headers:headers body:body completion:completionHandler];
}

- (void)patchWithURL:(NSString *)url
             headers:(NSDictionary<NSString *, NSString *> *)headers
                body:(NSData *)body
          completion:(SFURLCompletionHandler)completionHandler {
    [self send:SFHTTPMethodPATCH url:url headers:headers body:body completion:completionHandler];
}

@end
