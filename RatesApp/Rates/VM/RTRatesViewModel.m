//
//  RTRatesViewModel.m
//  Rates
//
//  Created by Garafutdinov Ravil on 06.12.15.
//  Copyright © 2015 RG. All rights reserved.
//

#import "RTRatesViewModel.h"
#import <RatesApiNetworkModel.h>
#import <RTRatesResponse.h>
#import <RTCurrencyFormatter.h>

@interface RTRatesViewModel()

@property (nonatomic, strong) RatesApiNetworkModel *networkModel;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) NSError *lastError;

@property (nonatomic, strong, readwrite) RACTuple *selectedPair;
@property (nonatomic, assign, readwrite) double rate;
@property (nonatomic, assign, readwrite) NSInteger percent;
@end

@implementation RTRatesViewModel

#pragma mark Base
- (id)init
{
    [self doesNotRecognizeSelector:_cmd];
    
    return nil;
}

- (void)dealloc
{
    [self operationDidEnd];
}

- (id)initWithNetworkModel:(id)model
{
    if (self = [super init])
    {
        NSAssert(model, @"model cannot be nil");
        
        self.networkModel = model;
        
        self.isLoading = NO;
        self.lastError = nil;
        
        self.selectedPair = nil;
        self.rate = 0;
        self.percent = 0;
    }
    
    return self;
}

- (RACSignal *)wrapSignal:(RACSignal *)aSignal
{
    return [self wrapSignal:aSignal withBeforeNextBlock:nil andBeforeErrorBlock:nil];
}

- (RACSignal *)wrapSignal:(RACSignal *)aSignal
      withBeforeNextBlock:(void (^)(id x))beforeNextBlock
      andBeforeErrorBlock:(void (^)(NSError *error))beforeErrorBlock
{
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        return [[RACScheduler schedulerWithPriority:RACSchedulerPriorityDefault]
                schedule:^
        {
            @strongify(self);
            [self operationWillBegin];
            
            [aSignal
             subscribeNext:^(id x)
            {
                SAFE_RUN(beforeNextBlock, x);
                [subscriber sendNext:x];
            }
             error:^(NSError *error)
            {
                @strongify(self);
                SAFE_RUN(beforeErrorBlock, error);
                [subscriber sendError:error];
                [self operationDidFailWithError:error];
            }
             completed:^
            {
                @strongify(self);
                [subscriber sendCompleted];
                [self operationDidEnd];
            }];
        }];
    }];
}

- (void)operationWillBegin
{
    self.lastError = nil;
    self.isLoading = YES;
}

- (void)operationDidEnd
{
    self.isLoading = NO;
}

- (void)operationDidFailWithError:(NSError *)error
{
    self.isLoading = NO;
    self.lastError = error;
}

#pragma mark Requests
- (RACSignal *)requestRatesForPair:(RACTuple *)pair
{
    NSAssert(pair, @"pair cannot be nil");
    NSAssert(pair.count >= 2, @"pair must contain first and second argument");
    NSAssert([pair.first isKindOfClass:[NSNumber class]], @"first must be a number");
    NSAssert([pair.second isKindOfClass:[NSNumber class]], @"second must be a number");
    
    self.selectedPair = pair;
    
    RatesCurrencies first = [pair.first integerValue];
    RatesCurrencies second = [pair.second integerValue];

    NSDate *today = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [cal components:NSCalendarUnitHour fromDate:today];
    [components setHour:-24*3]; //@TODO: тут косяк сервиса, который отдает данные с задержкой в два дня
    
    NSDate *yesterday = [cal dateByAddingComponents:components toDate:today options:0];
    
    RACSignal *combined = [RACSignal combineLatest:@[[self.networkModel requestTodayRatesForBase:first to:second],
                                                     [self.networkModel requestRatesForBase:first to:second andDate:yesterday]]];
    
    @weakify(self);
    RACSignal *wrapped = [self wrapSignal:combined
                      withBeforeNextBlock:^(RACTuple *x)
    {
        @strongify(self);
        RTRatesResponse *todayRates = x.first;
        RTRatesResponse *yesterdayRates = x.second;
        
        RatesCurrencies todayBase = [RTCurrencyFormatter currencyWithString:todayRates.base];
        RatesCurrencies todaySymbol = [RTCurrencyFormatter currencyWithString:todayRates.symbol];
        
        if ([self.selectedPair.first integerValue] == todayBase
            && [self.selectedPair.second integerValue] == todaySymbol)
        {
            self.rate = todayRates.rate;
            self.percent = round((todayRates.rate / yesterdayRates.rate) * 100.f - 100.f);
        }
    }
                      andBeforeErrorBlock:^(NSError *error)
    {
        ; //@TODO: обработка ошибки BAD_REQUEST
    }];
    
    return wrapped;
}

@end
