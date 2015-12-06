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

@end
