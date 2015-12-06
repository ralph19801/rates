//
//  RatesApiNetworkModel.m
//  RatesApiNetworkModel
//
//  Created by Garafutdinov Ravil on 05.12.15.
//  Copyright © 2015 RG. All rights reserved.
//

#import "RatesApiNetworkModel.h"
#import <AFNetworking.h>
#import <Mantle.h>

#import "RatesApiClient.h"
#import "NSError+Rates.h"
#import "RTRatesResponse.h"
#import "RTCurrencyFormatter.h"

#define HTTP_GET    @"GET"
#define HTTP_POST   @"POST"
#define HTTP_PUT    @"PUT"
#define HTTP_DELETE @"DELETE"

typedef id(^RTAFetchResponseBlock)(RTRatesResponse *responseObject);
typedef void(^RTASubscriberErrorBlock)(id<RACSubscriber> subscriber, NSError *error);
typedef void(^RTASubscriberNextBlock)(id<RACSubscriber>subscriber, RTRatesResponse *responseObject, RACDisposable *disposable);
typedef void(^RTASendNextBlock)(id<RACSubscriber>subscriber, RTRatesResponse *payloadObject);

@interface RatesApiNetworkModel()

@property (nonatomic, strong) RatesApiClient *apiClient;

@end

@implementation RatesApiNetworkModel

- (id)initWithApiClient:(id)apiClient
{
    if (self = [super init])
    {
        self.apiClient = apiClient;
    }
    
    return self;
}

#pragma mark RAC blocks
- (RTAFetchResponseBlock)defaultMapFetchResponseBlockWithRootClass:(Class)rootClass
{
    return ^id(id responseObject)
    {
        if (!responseObject)
        {
            return nil;
        }
        
        NSError *parseError = nil;
        id jsonResponse = [MTLJSONAdapter modelOfClass:rootClass
                                    fromJSONDictionary:responseObject
                                                 error:&parseError];
        if (parseError)
        {
            return nil;
        }
        
        return jsonResponse;
    };
}

- (RTASubscriberErrorBlock)defaultSubscriberErrorBlock
{
    return ^(id<RACSubscriber>subscriber, NSError *error) {
        if (error.isApiError) {
            [subscriber sendError:[NSError apiErrorWithCode:error.code andUserInfo:nil]];
        } else {
            [subscriber sendError:error];
        }
    };
}

- (RTASubscriberNextBlock)defaultSubscriberNextBlock:(void(^)(id<RACSubscriber>subscriber, id payloadObject))noErrorBlock
{
    return ^(id<RACSubscriber>subscriber, RTRatesResponse *responseObject, RACDisposable *disposable)
    {
        if (!responseObject) // сервер не вернул ничего
        {
            [self defaultSubscriberErrorBlock](subscriber, [NSError apiErrorWithCode:RatesApiStatus_ConnectionError andUserInfo:nil]);
            [disposable dispose];
        }
        else if (responseObject.rates.count == 0) // на сервере нет данных для этого запроса
        {
            [self defaultSubscriberErrorBlock](subscriber, [NSError apiErrorWithCode:RatesApiStatus_BadRequest andUserInfo:nil]);
            [disposable dispose];
        }
        else if (noErrorBlock)
        {
            noErrorBlock(subscriber, responseObject);
        }
    };
}

#pragma mark API protocol method
- (RACSignal *)apiRequestWithMethod:(NSString *)aMethod
                               path:(NSString *)aPath
                         parameters:(NSDictionary *)aParameters
{
    return [self.apiClient apiRequestWithMethod:aMethod path:aPath parameters:aParameters];
}

- (RACSignal *)multipartFormApiRequestWithMethod:(NSString *)aMethod
                                            path:(NSString *)aPath
                                      parameters:(NSDictionary *)aParameters
                       constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block
{
    return [self.apiClient apiRequestWithMethod:aMethod
                                           path:aPath
                                     parameters:aParameters
                      constructingBodyWithBlock:block];
}

- (RACSignal *)signalForMethod:(NSString *)method
                          path:(NSString *)path
                    withParams:(NSDictionary *)params
{
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber)
            {
                @strongify(self);
                RACDisposable *requestDisposable = [[[self apiRequestWithMethod:method
                                                                           path:path
                                                                     parameters:params]
                map:^id(id responseObject)
                {
                     return [self defaultMapFetchResponseBlockWithRootClass:RTRatesResponse.class](responseObject);
                }]
                subscribeNext:^(id x)
                {
                    [self defaultSubscriberNextBlock:^(id<RACSubscriber> subscriber, id payloadObject)
                     {
                         [subscriber sendNext:payloadObject];
                     }
                     ](subscriber, x, requestDisposable);
                }
                error:^(NSError *error)
                {
                    [self defaultSubscriberErrorBlock](subscriber, error);
                }
                completed:^
                {
                    [subscriber sendCompleted];
                }];
                return requestDisposable;
            }];
}

#pragma mark Requests
- (RACSignal *)requestTodayRatesForBase:(RatesCurrencies)base to:(RatesCurrencies)symbol
{
    NSAssert(base, @"base cannot be undefined.");
    NSAssert(symbol, @"symbol cannot be undefined.");
    
    NSDictionary *params = @{@"base" : [RTCurrencyFormatter stringWithCurrency:base],
                             @"symbols" : [RTCurrencyFormatter stringWithCurrency:symbol]};
    
    return [self signalForMethod:HTTP_GET
                            path:@"latest"
                      withParams:params];
}

- (RACSignal *)requestRatesForBase:(RatesCurrencies)base to:(RatesCurrencies)symbol andDate:(NSDate *)date
{
    NSAssert(base, @"base cannot be undefined.");
    NSAssert(symbol, @"symbol cannot be undefined.");
    NSAssert(date, @"date cannot be nil.");
    
    NSDictionary *params = @{@"base" : [RTCurrencyFormatter stringWithCurrency:base],
                             @"symbols" : [RTCurrencyFormatter stringWithCurrency:symbol]};
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *stringDate = [dateFormatter stringFromDate:date];
    
    return [self signalForMethod:HTTP_GET
                            path:stringDate
                      withParams:params];
}

@end
