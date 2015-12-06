//
//  RTRateFormatter.m
//  Rates
//
//  Created by Garafutdinov Ravil on 06.12.15.
//  Copyright © 2015 RG. All rights reserved.
//

#import "RTRateFormatter.h"

@implementation RTRateFormatter

- (id)format:(NSNumber *)x
{
    if ([x isKindOfClass:[NSNumber class]])
    {
        return [NSString stringWithFormat:@"%.3f", [x doubleValue]];
    }
    
    return x;
}

@end
