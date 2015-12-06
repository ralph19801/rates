//
//  RTRatesResponse.m
//  RatesNetworkApi
//
//  Created by Garafutdinov Ravil on 05.12.15.
//  Copyright © 2015 RG. All rights reserved.
//

#import "RTRatesResponse.h"

@implementation RTRatesResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"base" : @"base",
             @"date" : @"date",
             @"rates" : @"rates"
             };
}

- (NSString *)symbol
{
    return self.rates.allKeys.firstObject;
}

- (double)rate
{
    return [self.rates[self.symbol] doubleValue];
}

@end
