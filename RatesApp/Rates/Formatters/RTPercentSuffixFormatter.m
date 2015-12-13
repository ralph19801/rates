//
//  RTPercentSuffixFormatter.m
//  Rates
//
//  Created by Garafutdinov Ravil on 11.12.15.
//  Copyright © 2015 RG. All rights reserved.
//

#import "RTPercentSuffixFormatter.h"

@implementation RTPercentSuffixFormatter

- (id)format:(NSNumber *)num
{
    if ([num isKindOfClass:[NSNumber class]])
    {
        NSString *localization = [NSBundle mainBundle].preferredLocalizations.firstObject;
        
        if ([localization isEqualToString:@"ru"])
        {
            NSMutableString *rlt = [NSLocalizedString(@"PercentWord", @"") mutableCopy];
            NSUInteger p = labs([num longValue]);
            
            NSUInteger dd = p % 100;
            NSUInteger d = p % 10;
            
            if (2 <= d && d <= 4 && (12 > dd || dd > 14))
            {
                [rlt appendString:NSLocalizedString(@"Percent2-4", @"-а")];
            }
            else if (d != 1 || dd == 11)
            {
                [rlt appendString:NSLocalizedString(@"Percent5-0", @"-ов")];
            }
            
            return rlt;
        }
        else if ([localization isEqualToString:@"en"])
        {
            return NSLocalizedString(@"PercentWord", @"percent");
        }
    }
    
    return @"";
}

@end
