//
//  RTTimeFormatter.m
//  Rates
//
//  Created by Garafutdinov Ravil on 11.12.15.
//  Copyright © 2015 RG. All rights reserved.
//

#import "RTTimeFormatter.h"

@implementation RTTimeFormatter

- (id)format:(NSDate *)date
{
    if ([date isKindOfClass:[NSDate class]])
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        return [formatter stringFromDate:date];
    }
    
    return @"";
}

@end
