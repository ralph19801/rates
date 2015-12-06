//
//  RTCurrencyFormatter.h
//  RatesNetworkApi
//
//  Created by Garafutdinov Ravil on 06.12.15.
//  Copyright © 2015 RG. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSInteger, RatesCurrencies)
{
    RTC_Undefined = 0,
    RTC_USD,
    RTC_EUR,
    RTC_RUB
};

@interface RTCurrencyFormatter : NSObject

+ (NSString *)stringWithCurrency:(RatesCurrencies)currency;
+ (RatesCurrencies)currencyWithString:(NSString *)strCurrency;

@end
