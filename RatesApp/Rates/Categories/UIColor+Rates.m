//
//  UIColor+Rates.m
//  Rates
//
//  Created by Garafutdinov Ravil on 06.12.15.
//  Copyright © 2015 RG. All rights reserved.
//

#import "UIColor+Rates.h"

@implementation UIColor (Rates)

+ (UIColor *)regularCellTitleColor
{
    return [UIColor colorWithWhite:1 alpha:0.7f];
}

+ (UIColor *)boldCellTitleColor
{
    return [UIColor whiteColor];
}

+ (UIColor *)soaringRatesColor
{
    return [UIColor colorWithRed:126.f / 255.f green:211.f / 255.f blue:33.f / 255.f alpha:1.f];
}

+ (UIColor *)fallingRatesColor
{
    return [UIColor redColor];
}

@end
