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
#import "UIColor+Rates.h"

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
    
    self.viewModel = [[RTRatesViewModel alloc] initWithNetworkModel:RatesApi];
    
    [self setupSubscriptions];
    
    RACTuple *firstRates = [RACTuple tupleWithObjectsFromArray:@[@(RTC_USD), @(RTC_RUB)]];
    [self requestRatesForPair:firstRates];
}

- (void)setupSubscriptions
{
    @weakify(self);
    [RACObserve(self.viewModel, selectedPair) subscribeNext:^(id x)
    {
        @strongify(self);
        
        if (x)
        {
            self.currenciesLabel.text = [CurrencyPairFormatter format:x];
            self.menuViewController.selectedPair = x;
        }
        else
        {
            self.currenciesLabel.text = NSLocalizedString(@"n_a", @"N/A");
        }
    }];
    
    [RACObserve(self.viewModel, rate) subscribeNext:^(id x)
    {
        @strongify(self);
        
        self.rateLabel.text = [RateFormatter format:x];
    }];
    
    [RACObserve(self.viewModel, percent) subscribeNext:^(id x)
    {
        @strongify(self);
        
        self.riseLabel.text = [PercentFormatter format:[RACTuple tupleWithObjects:self.viewModel.selectedPair.second, x, nil]];
        self.riseLabel.textColor = ([x integerValue] >= 0) ? [UIColor soaringRatesColor] : [UIColor fallingRatesColor];
    }];
}

- (void)requestRatesForPair:(RACTuple *)pair
{
    [[self.viewModel requestRatesForPair:pair]
     subscribeNext:^(id x)
    {
        NSLog(@"next: %@", x);
    }
     error:^(NSError *error)
    {
        NSLog(@"error: %@", error);
    }
     completed:^
    {
        NSLog(@"completed");
    }];
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
            [self closeMenu];
            [self requestRatesForPair:values];
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

- (void)closeMenu
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
