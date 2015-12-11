//
//  RTFormattersAssembly.m
//  Rates
//
//  Created by Garafutdinov Ravil on 30.11.15.
//  Copyright © 2015 RG. All rights reserved.
//

#import "RTFormattersAssembly.h"
#import "RTAssemblyUtils.h"

#import "RTCurrencyPairFormatter.h"
#import "RTPercentFormatter.h"
#import "RTRateFormatter.h"
#import "RTTimeFormatter.h"
#import "RTPercentSuffixFormatter.h"

@implementation RTFormattersAssembly

- (id)currencyPairFormatter
{
    return [RTAssemblyUtils singletonDefinitionForClass:[RTCurrencyPairFormatter class]];
}

- (id)percentFormatter
{
    return [RTAssemblyUtils singletonDefinitionForClass:[RTPercentFormatter class]];
}

- (id)rateFormatter
{
    return [RTAssemblyUtils singletonDefinitionForClass:[RTRateFormatter class]];
}

- (id)timeFormatter
{
    return [RTAssemblyUtils singletonDefinitionForClass:[RTTimeFormatter class]];
}

- (id)percentSuffixFormatter
{
    return [RTAssemblyUtils singletonDefinitionForClass:[RTPercentSuffixFormatter class]];
}

@end
