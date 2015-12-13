//
//  NSString+Spacing.m
//  Rates
//
//  Created by Garafutdinov Ravil on 13.12.15.
//  Copyright © 2015 RG. All rights reserved.
//

#import "NSString+Spacing.h"

@implementation NSString (Spacing)

- (NSAttributedString *)attributedStringWithSpacing:(CGFloat)spacing
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    
    [attributedString addAttribute:NSKernAttributeName
                             value:@(spacing)
                             range:NSMakeRange(0, [self length])];
    
    return attributedString;
}

@end
