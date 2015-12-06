//
//  RatesApiClient.m
//  RatesApiClient
//
//  Created by Garafutdinov Ravil on 05.12.15.
//  Copyright © 2015 RG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import <ReactiveCocoa.h>

@class AFHTTPRequestOperationManager;

@interface RatesApiClient : NSObject

@property (nonatomic, strong, readonly) AFHTTPRequestOperationManager *httpClient;
@property (nonatomic, strong) NSMutableDictionary *customHeaders;

- (instancetype) initWithHttpClient:(AFHTTPRequestOperationManager *)aHttpClient;

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                 URLString:(NSString *)URLString
                                parameters:(id)parameters
                                     error:(NSError *__autoreleasing *)error;

- (RACSignal *)apiRequestWithMethod:(NSString *)aMethod
                               path:(NSString *)aPath
                         parameters:(NSDictionary *)aParameters;

- (RACSignal *)apiRequestWithMethod:(NSString *)aMethod
                               path:(NSString *)aPath
                         parameters:(NSDictionary *)aParameters
          constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block;

@end


@interface RatesApiClient (Unavailable)

- (id)init __attribute__((unavailable("init is not a supported initializer for this class.")));

@end