//
//  NSString+Line.m
//  Rates
//
//  Created by Garafutdinov Ravil on 13.12.15.
//  Copyright © 2015 RG. All rights reserved.
//

#import "NSString+Line.h"

@implementation NSString (Line)

- (NSAttributedString *)attributedStringWithLineHeight:(CGFloat)lineHeight
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineHeight;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.length)];
    
    return attributedString;
}

@end
