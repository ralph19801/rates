//
//  RatesNetworkApiTests.m
//  RatesNetworkApiTests
//
//  Created by Garafutdinov Ravil on 05.12.15.
//  Copyright © 2015 RG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <AFNetworking.h>
#import <Expecta.h>
#import <Nocilla.h>
#import <ReactiveCocoa.h>

#import "RatesApiNetworkModel.h"
#import "RatesApiClient.h"
#import "RTRatesResponse.h"
#import "NSError+Rates.h"
#import "RTCurrencyFormatter.h"

#define kBaseUrl          @"http://rates.ru"
#define kExpectaTimeOut   0.5

@interface RatesNetworkApiTests : XCTestCase

@property (nonatomic, strong) RatesApiNetworkModel *networkModel;

@end

@implementation RatesNetworkApiTests

- (void)setUp
{
    [super setUp];
    
    [Expecta setAsynchronousTestTimeout:kExpectaTimeOut];
    [[LSNocilla sharedInstance] start];
    
    AFHTTPRequestOperationManager *httpClient = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    RatesApiClient *apiClient = [[RatesApiClient alloc] initWithHttpClient:httpClient];
    self.networkModel = [[RatesApiNetworkModel alloc] initWithApiClient:apiClient];
}

- (void)tearDown
{
    self.networkModel = nil;
    
    [[LSNocilla sharedInstance] stop];
    [[LSNocilla sharedInstance] clearStubs];
    
    [super tearDown];
}

- (void)testTodayRatesOk
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"today_rates" withExtension:@"json"];
    NSData *responseData = [NSData dataWithContentsOfURL:url];
    
    stubRequest(@"GET", @"http://rates.ru/latest?base=USD&symbols=RUB")
    .andReturn(200)
    .withHeader(@"Content-Type", @"application/json")
    .withBody(responseData);
    
    __block RTRatesResponse *ratesResponse = nil;
    __block NSError *responseError = nil;
    __block BOOL isCompleted = NO;
    
    [[self.networkModel requestTodayRatesForBase:RTC_USD to:RTC_RUB]
     subscribeNext:^(RTRatesResponse *x)
    {
        ratesResponse = x; //<=====
    }
     error:^(NSError *error)
    {
        responseError = error;
    }
     completed:^
    {
        isCompleted = YES; //<=====
    }];
    
    EXP_expect(ratesResponse).will.toNot.beNil();
    EXP_expect(ratesResponse.base).will.to.equal(@"USD");
    EXP_expect(ratesResponse.date).will.to.equal(@"2015-12-04");
    
    EXP_expect(ratesResponse.rates).will.toNot.beNil();
    EXP_expect(ratesResponse.rates.count).will.to.equal(@(1));
    
    if (ratesResponse.rates.count > 0)
    {
        EXP_expect(ratesResponse.rates[@"RUB"]).will.toNot.beNil();
        EXP_expect(ratesResponse.rates[@"RUB"]).will.to.equal(@(67.521));
    }
    
    EXP_expect(responseError).will.to.beNil();
    EXP_expect(isCompleted).will.beTruthy();
}

- (void)testTodayRates500
{
    stubRequest(@"GET", @"http://rates.ru/latest?base=USD&symbols=RUB")
    .andReturn(500);
    
    __block RTRatesResponse *ratesResponse = nil;
    __block NSError *responseError = nil;
    __block BOOL isCompleted = NO;
    
    [[self.networkModel requestTodayRatesForBase:RTC_USD to:RTC_RUB]
     subscribeNext:^(RTRatesResponse *x)
     {
         ratesResponse = x;
     }
     error:^(NSError *error)
     {
         responseError = error; //<=====
     }
     completed:^
     {
         isCompleted = YES;
     }];
    
    EXP_expect(ratesResponse).will.to.beNil();
    
    EXP_expect(responseError).will.toNot.beNil();
    EXP_expect(responseError.code).will.to.equal(@(RatesApiStatus_ServerError));
    
    EXP_expect(isCompleted).will.beFalsy();
}

- (void)testTodayRatesEmpty
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"today_rates_empty" withExtension:@"json"];
    NSData *responseData = [NSData dataWithContentsOfURL:url];
    
    stubRequest(@"GET", @"http://rates.ru/latest?base=USD&symbols=RUB")
    .andReturn(200)
    .withHeader(@"Content-Type", @"application/json")
    .withBody(responseData);
    
    __block RTRatesResponse *ratesResponse = nil;
    __block NSError *responseError = nil;
    __block BOOL isCompleted = NO;
    
    [[self.networkModel requestTodayRatesForBase:RTC_USD to:RTC_RUB]
     subscribeNext:^(RTRatesResponse *x)
     {
         ratesResponse = x;
     }
     error:^(NSError *error)
     {
         responseError = error; //<=====
     }
     completed:^
     {
         isCompleted = YES;
     }];
    
    EXP_expect(ratesResponse).will.to.beNil();
    
    EXP_expect(responseError).will.toNot.beNil();
    EXP_expect(responseError.code).will.to.equal(@(RatesApiStatus_BadRequest));
    
    EXP_expect(isCompleted).will.beFalsy();
}

- (void)testOtherDateRatesOk
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"other_date_rates" withExtension:@"json"];
    NSData *responseData = [NSData dataWithContentsOfURL:url];
    
    stubRequest(@"GET", @"http://rates.ru/2000-01-13?base=USD&symbols=RUB")
    .andReturn(200)
    .withHeader(@"Content-Type", @"application/json")
    .withBody(responseData);
    
    NSString *dateString = @"2000-01-13";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    
    __block RTRatesResponse *ratesResponse = nil;
    __block NSError *responseError = nil;
    __block BOOL isCompleted = NO;
    
    [[self.networkModel requestRatesForBase:RTC_USD to:RTC_RUB andDate:date]
     subscribeNext:^(RTRatesResponse *x)
     {
         ratesResponse = x; //<=====
     }
     error:^(NSError *error)
     {
         responseError = error;
     }
     completed:^
     {
         isCompleted = YES; //<=====
     }];
    
    EXP_expect(ratesResponse).will.toNot.beNil();
    EXP_expect(ratesResponse.base).will.to.equal(@"USD");
    EXP_expect(ratesResponse.date).will.to.equal(@"2000-01-13");
    
    EXP_expect(ratesResponse.rates).will.toNot.beNil();
    EXP_expect(ratesResponse.rates.count).will.to.equal(@(1));
    
    if (ratesResponse.rates.count > 0)
    {
        EXP_expect(ratesResponse.rates[@"RUB"]).will.toNot.beNil();
        EXP_expect(ratesResponse.rates[@"RUB"]).will.to.equal(@(67.52111));
    }
    
    EXP_expect(responseError).will.to.beNil();
    EXP_expect(isCompleted).will.beTruthy();
}

@end
