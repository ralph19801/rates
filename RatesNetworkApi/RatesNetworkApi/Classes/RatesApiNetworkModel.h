//
//  RatesApiNetworkModel.h
//  RatesApiNetworkModel
//
//  Created by Garafutdinov Ravil on 05.12.15.
//  Copyright © 2015 RG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa.h>
#import "RTCurrencyFormatter.h"

@interface RatesApiNetworkModel : NSObject

- (id)init __attribute__((unavailable("init is not a supported initializer for this class.")));

- (id)initWithApiClient:(id)apiClient;

- (RACSignal *)requestTodayRatesForBase:(RatesCurrencies)base to:(RatesCurrencies)symbol;
- (RACSignal *)requestRatesForBase:(RatesCurrencies)base to:(RatesCurrencies)symbol andDate:(NSDate *)date;

@end
