//
//  RTMenuTVCell.m
//  Rates
//
//  Created by Garafutdinov Ravil on 06.12.15.
//  Copyright © 2015 RG. All rights reserved.
//

#import "RTMenuTVCell.h"
#import "UIColor+Rates.h"
#import "UIFont+Rates.h"

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
        self.titleLabel.font = [UIFont boldCellTitleFont];
        self.titleLabel.textColor = [UIColor boldCellTitleColor];
    }
    else
    {
        self.titleLabel.font = [UIFont regularCellTitleFont];
        self.titleLabel.textColor = [UIColor regularCellTitleColor];
    }
}

- (void)prepareForReuse
{
    self.titleString = @"";
    self.isBold = NO;
}

@end
