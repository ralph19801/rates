//
//  RTCurrencyFormatter.m
//  RatesNetworkApi
//
//  Created by Garafutdinov Ravil on 06.12.15.
//  Copyright © 2015 RG. All rights reserved.
//

#import "RTCurrencyFormatter.h"

@implementation RTCurrencyFormatter

+ (NSString *)stringWithCurrency:(RatesCurrencies)currency
{
    static NSDictionary *currencies;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      currencies = @{@(RTC_USD) : @"USD",
                                     @(RTC_EURO) : @"EURO",
                                     @(RTC_RUB) : @"RUB"};
                  });
    
    return currencies[@(currency)];
}

+ (RatesCurrencies)currencyWithString:(NSString *)strCurrency
{
    static NSDictionary *currencies;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      currencies = @{@"USD" : @(RTC_USD),
                                     @"EURO" : @(RTC_EURO),
                                     @"RUB" : @(RTC_RUB)};
                  });
    
    return [currencies[strCurrency] integerValue];
}

@end
