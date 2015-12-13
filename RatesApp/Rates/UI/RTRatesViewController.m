//
//  ViewController.m
//  Rates
//
//  Created by Garafutdinov Ravil on 30.11.15.
//  Copyright © 2015 RG. All rights reserved.
//

#import "RTRatesViewController.h"
#import <RatesApiNetworkModel.h>

#import "RTMenuViewController.h"
#import "RTRatesViewModel.h"

#import <RTCurrencyFormatter.h>
#import "RTFormatterProtocol.h"
#import "UIColor+Rates.h"
#import "NSString+Spacing.h"
#import "NSString+Line.h"

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
            NSString *curString = [CurrencyPairFormatter format:x];
            self.currenciesLabel.attributedText = [curString attributedStringWithSpacing:1];
            
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
        
        NSString *rateString = [RateFormatter format:x];
        self.rateLabel.attributedText = [rateString attributedStringWithSpacing:-4];
    }];
    
    [RACObserve(self.viewModel, percent) subscribeNext:^(id x)
    {
        @strongify(self);
        
        NSString *riseString = [PercentFormatter format:[RACTuple tupleWithObjects:self.viewModel.selectedPair.second, x, nil]];
        self.riseLabel.attributedText = [riseString attributedStringWithLineHeight:1.21f];
        
        self.riseLabel.textColor = ([x integerValue] >= 0) ? [UIColor soaringRatesColor] : [UIColor fallingRatesColor];
    }];
    
    [RACObserve(self.viewModel, time) subscribeNext:^(id x)
    {
        @strongify(self);
        
        NSString *timeString = [NSString stringWithFormat:NSLocalizedString(@"UpdatedTimeFormat", @"Updated at mm:hh"),
                                [TimeFormatter format:x]];
        self.timeLabel.attributedText = [timeString attributedStringWithSpacing:2];
    }];
}

- (void)requestRatesForPair:(RACTuple *)pair
{
    @weakify(self);
    [[self.viewModel requestRatesForPair:pair] subscribeError:^(NSError *error)
    {
        [self_weak_ processError:error];
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

- (void)processError:(NSError *)error
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                   message:NSLocalizedString(@"ErrorMessage", @"error message")
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"AlertButtonOk", @"OK")
                                              style:UIAlertActionStyleDefault
                                            handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
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
