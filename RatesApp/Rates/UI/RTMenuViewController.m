//
//  RTMenuViewController.m
//  Rates
//
//  Created by Garafutdinov Ravil on 05.12.15.
//  Copyright © 2015 RG. All rights reserved.
//

#import "RTMenuViewController.h"
#import "RTFormatterProtocol.h"
#import "RTMenuTVCell.h"

@interface RTMenuViewController ()

@property (nonatomic, strong) NSArray *combinations;
@property (nonatomic, strong) id<RTFormatterProtocol> currencyFormatter;

@end

@implementation RTMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.combinations = @[[RACTuple tupleWithObjectsFromArray:@[@(RTC_USD), @(RTC_RUB)]],
                          [RACTuple tupleWithObjectsFromArray:@[@(RTC_USD), @(RTC_EUR)]],
                          [RACTuple tupleWithObjectsFromArray:@[@(RTC_EUR), @(RTC_RUB)]],
                          [RACTuple tupleWithObjectsFromArray:@[@(RTC_EUR), @(RTC_USD)]],
                          [RACTuple tupleWithObjectsFromArray:@[@(RTC_RUB), @(RTC_USD)]],
                          [RACTuple tupleWithObjectsFromArray:@[@(RTC_RUB), @(RTC_EUR)]]];
    
    self.currencyFormatter = CurrencyPairFormatter;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.combinations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RTMenuTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuCell"];
    
    RACTuple *values = self.combinations[indexPath.row];
    cell.titleString = [self.currencyFormatter format:values];
    
    if ([values.first isEqualToNumber:self.selectedPair.first]
        && [values.second isEqualToNumber:self.selectedPair.second])
    {
        cell.isBold = YES;
    }
    else
    {
        cell.isBold = NO;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    self.selectedPair = self.combinations[indexPath.row];
    self.onCurrencyPairSelected(self.selectedPair);
}

@end
