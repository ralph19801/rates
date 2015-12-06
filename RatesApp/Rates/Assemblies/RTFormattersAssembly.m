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

@implementation RTFormattersAssembly

- (id)currencyPairFormatter
{
    return [RTAssemblyUtils singletonDefinitionForClass:[RTCurrencyPairFormatter class]];
}

@end
