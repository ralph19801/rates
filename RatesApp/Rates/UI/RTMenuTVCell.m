//
//  RTMenuTVCell.m
//  Rates
//
//  Created by Garafutdinov Ravil on 06.12.15.
//  Copyright © 2015 RG. All rights reserved.
//

#import "RTMenuTVCell.h"

@interface RTMenuTVCell()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@end

@implementation RTMenuTVCell

- (void)setTitleString:(NSString *)titleString
{
    _titleString = titleString;
    
    self.titleLabel.text = _titleString;
}

- (void)setIsBold:(BOOL)isBold
{
    _isBold = isBold;
    
    if (_isBold)
    {
        self.titleLabel.font = [UIFont fontWithName:@"Lato-Black" size:28];
        self.titleLabel.textColor = [UIColor whiteColor];
    }
    else
    {
        self.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:28];
        self.titleLabel.textColor = [UIColor colorWithWhite:1 alpha:0.7f];
    }
}

- (void)prepareForReuse
{
    self.titleString = @"";
    self.isBold = NO;
}

@end
