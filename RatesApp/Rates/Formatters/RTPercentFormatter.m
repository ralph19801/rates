//
//  RTPercentFormatter.m
//  Rates
//
//  Created by Garafutdinov Ravil on 06.12.15.
//  Copyright © 2015 RG. All rights reserved.
//

#import "RTPercentFormatter.h"
#import <RACTuple.h>
#import <RTCurrencyFormatter.h>

@implementation RTPercentFormatter

- (id)format:(RACTuple *)x
{
    if ([x isKindOfClass:[RACTuple class]])
    {
        NSString *curString = [RTCurrencyFormatter stringWithCurrency:[x.first integerValue]];
        NSString *curLocalized = NSLocalizedString(curString, "");
        NSInteger percent = [x.second integerValue];

        NSString *rlt = nil;
        if (percent > 0)
        {
            rlt = [NSString stringWithFormat:NSLocalizedString(@"PersentRisesStringFormat", @""), curLocalized, percent];
        }
        else if (percent < 0)
        {
            rlt = [NSString stringWithFormat:NSLocalizedString(@"PersentFallsStringFormat", @""), curLocalized, -percent];
        }
        else
        {
            rlt = [NSString stringWithFormat:NSLocalizedString(@"PersentNotChangedStringFormat", @""), curLocalized];
        }
        
        return rlt;
    }
    return x;
}

@end
