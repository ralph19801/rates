//
//  ViewController.m
//  Rates
//
//  Created by Garafutdinov Ravil on 30.11.15.
//  Copyright © 2015 RG. All rights reserved.
//

#import "RTRatesViewController.h"
#import <RatesApiNetworkModel.h>
#import <RTCurrencyFormatter.h>
#import "RTFormatterProtocol.h"

#import "RTMenuViewController.h"
#import "RTRatesViewModel.h"

#define kAnimationDuration 0.5f

@interface RTRatesViewController ()

@property (nonatomic, weak) IBOutlet UILabel *currenciesLabel;
@property (nonatomic, weak) IBOutlet UILabel *rateLabel;
@property (nonatomic, weak) IBOutlet UILabel *riseLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *containerBottomConstraint;
@property (nonatomic, weak) IBOutlet UIView *menuContainer;
@property (nonatomic, strong) RTMenuViewController *menuViewController;

@property (nonatomic, strong) RTRatesViewModel *viewModel;

@end

@implementation RTRatesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.viewModel = [[RTRatesViewModel alloc] init];
    self.viewModel.selectedPair = [RACTuple tupleWithObjectsFromArray:@[@(RTC_USD), @(RTC_RUB)]];
    self.menuViewController.selectedPair = self.viewModel.selectedPair;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"RatesVCEmbedMenuTVCSegue"])
    {
        self.menuViewController = segue.destinationViewController;
        
        @weakify(self);
        self.menuViewController.onCurrencyPairSelected = ^(RACTuple *values)
        {
            @strongify(self);
            self.currenciesLabel.text = [CurrencyPairFormatter format:values];
            self.viewModel.selectedPair = values;
            [self.menuViewController.tableView reloadData];
            [self closeMenu:self];
        };
    }
}

#pragma mark Menu
- (IBAction)onMenuButtonTouch:(id)sender
{
    [self openMenu];
}

- (void)openMenu
{
    if (self.containerBottomConstraint.constant != 0)
    {
        [self animateMenuToConst:0];
    }
}

- (IBAction)closeMenu:(id)sender
{
    if (self.containerBottomConstraint.constant == 0)
    {
        [self animateMenuToConst:-self.menuContainer.bounds.size.height];
    }
}

- (void)animateMenuToConst:(CGFloat)constant
{
    self.containerBottomConstraint.constant = constant;
    [self.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:kAnimationDuration
                     animations:^
     {
         [self.view layoutIfNeeded];
     }];
}

@end
