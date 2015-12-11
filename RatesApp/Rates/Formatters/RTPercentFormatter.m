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
    if ([x isKindOfClass:[RACTuple class]] && x.count >= 2)
    {
        NSString *curString = [RTCurrencyFormatter stringWithCurrency:[x.first integerValue]];
        NSString *curLocalized = NSLocalizedString(curString, "euro");
        NSInteger percent = [x.second integerValue];
        NSString *percentWithSuffix = [[Factory componentForKey:@"percentSuffixFormatter"] format:x.second];

        NSString *rlt = nil;
        if (percent > 0)
        {
            rlt = [NSString stringWithFormat:NSLocalizedString(@"PersentRisesStringFormat", @""), curLocalized, percent, percentWithSuffix];
        }
        else if (percent < 0)
        {
            rlt = [NSString stringWithFormat:NSLocalizedString(@"PersentFallsStringFormat", @""), curLocalized, -percent, percentWithSuffix];
        }
        else
        {
            rlt = [NSString stringWithFormat:NSLocalizedString(@"PersentNotChangedStringFormat", @""), curLocalized];
        }
        
        return rlt;
    }
    
    return @"";
}

@end
