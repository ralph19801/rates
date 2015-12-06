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

@interface RTRatesViewController ()

@end

@implementation RTRatesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.definesPresentationContext = YES;
    
    [[RatesApi requestTodayRatesForBase:RTC_USD to:RTC_RUB]
     subscribeNext:^(id x) {
         NSLog(@"next: %@", x);
     } error:^(NSError *error) {
         NSLog(@"error: %@", error);
     } completed:^{
         NSLog(@"completed");
     }];
}

@end
