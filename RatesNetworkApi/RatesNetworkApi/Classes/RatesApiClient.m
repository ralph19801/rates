//
//  RatesApiClient.m
//  RatesApiClient
//
//  Created by Garafutdinov Ravil on 05.12.15.
//  Copyright © 2015 RG. All rights reserved.
//

#import "RatesApiClient.h"
#import "NSError+Rates.h"

#import <AFNetworking.h>
#import <ReactiveCocoa.h>

extern const int ddLogLevel;

@interface RatesApiClient ()

@property (nonatomic, strong, readwrite) AFHTTPRequestOperationManager *httpClient;

@end

@implementation RatesApiClient

- (instancetype)initWithHttpClient:(AFHTTPRequestOperationManager *)aHttpClient
{
    NSAssert(aHttpClient, @"aHttpClient cannot be nil.");
    if (self = [super init])
    {
        self.httpClient = aHttpClient;
    }
    return self;
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                 URLString:(NSString *)urlString
                                parameters:(id)parameters
                                     error:(NSError *__autoreleasing *)error
{
    NSString *relativeUrlString = [[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                                          relativeToURL:self.httpClient.baseURL] absoluteString];
    
    NSMutableURLRequest *request
        = [self.httpClient.requestSerializer requestWithMethod:method
                                                     URLString:relativeUrlString
                                                    parameters:parameters
                                                         error:error];
    
    return request;
}

- (NSMutableURLRequest *)multipartFormRequestWithMethod:(NSString *)method
                                              URLString:(NSString *)URLString
                                             parameters:(id)parameters
                              constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block
                                                  error:(NSError *__autoreleasing *)error
{
    NSString *relativeUrlString = [[NSURL URLWithString:[URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] relativeToURL:self.httpClient.baseURL] absoluteString];
    
    NSMutableURLRequest *request
        = [self.httpClient.requestSerializer multipartFormRequestWithMethod:method
                                                                  URLString:relativeUrlString
                                                                 parameters:parameters
                                                  constructingBodyWithBlock:block
                                                                      error:error];
    
    return request;
}

- (RACSignal *)apiRequestWithMethod:(NSString *)aMethod
                             path:(NSString *)aPath
                       parameters:(NSDictionary *)aParameters
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

        return [[RACScheduler schedulerWithPriority:RACSchedulerPriorityDefault] schedule:^
        {
            NSError *requestError = nil;
            NSMutableURLRequest *request = [self requestWithMethod:aMethod
                                                         URLString:aPath
                                                        parameters:aParameters
                                                             error:&requestError];
            
            if (requestError)
            {
                [subscriber sendError:[NSError apiErrorWithCode:RatesApiStatus_BadRequest andUserInfo:[NSDictionary userInfoWithOriginalError:requestError]]];
                return;
            }
            
            [self startOperationWithURLRequest:request andSubscriber:subscriber];
        }];
    }];
}


- (RACSignal *)apiRequestWithMethod:(NSString *)aMethod
                               path:(NSString *)aPath
                         parameters:(NSDictionary *)aParameters
          constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        return [[RACScheduler schedulerWithPriority:RACSchedulerPriorityDefault] schedule:^
        {
            NSError *requestError = nil;
            NSMutableURLRequest *request = [self multipartFormRequestWithMethod:aMethod
                                                                      URLString:aPath
                                                                     parameters:aParameters
                                                      constructingBodyWithBlock:block
                                                                          error:&requestError];
            
            if (requestError)
            {
                [subscriber sendError:[NSError apiErrorWithCode:RatesApiStatus_BadRequest andUserInfo:[NSDictionary userInfoWithOriginalError:requestError]]];
                return;
            }
            
            [self startOperationWithURLRequest:request andSubscriber:subscriber];
        }];
    }];
}

- (void)startOperationWithURLRequest:(NSMutableURLRequest *)request andSubscriber:(id<RACSubscriber>) subscriber
{
    AFHTTPRequestOperation *operation = [self.httpClient HTTPRequestOperationWithRequest:request
                                                                                 success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        if (responseObject)
        {
            [subscriber sendNext:responseObject];
        }
    
        [subscriber sendCompleted];
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSError *requestError = nil;
        
        if (operation.response)
        {
            requestError = [NSError apiErrorWithCode:RatesApiStatus_ServerError andUserInfo:[NSDictionary userInfoWithServerResponse:operation.response]];
        }
        else
        {
            requestError = [NSError apiErrorWithCode:RatesApiStatus_ConnectionError andUserInfo:[NSDictionary userInfoWithOriginalError:error]];
        }
         
        [subscriber sendError:requestError];
    }];
    
    [self.httpClient.operationQueue addOperation:operation];
}

@end
