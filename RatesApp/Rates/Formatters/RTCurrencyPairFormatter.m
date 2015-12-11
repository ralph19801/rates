//
//  RTCurrencyPairFormatter.m
//  Rates
//
//  Created by Garafutdinov Ravil on 06.12.15.
//  Copyright © 2015 RG. All rights reserved.
//

#import "RTCurrencyPairFormatter.h"
#import <RACTuple.h>
#import <RTCurrencyFormatter.h>

@implementation RTCurrencyPairFormatter

- (id)format:(RACTuple *)x
{
    if ([x isKindOfClass:[RACTuple class]] && x.count >= 2)
    {
        NSString *first = [RTCurrencyFormatter stringWithCurrency:[x.first integerValue]];
        NSString *second = [RTCurrencyFormatter stringWithCurrency:[x.second integerValue]];
        return [NSString stringWithFormat:@"%@ → %@", first, second];
    }
    
    return @"";
}

@end
