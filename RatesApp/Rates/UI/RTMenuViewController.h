//
//  RTMenuViewController.h
//  Rates
//
//  Created by Garafutdinov Ravil on 05.12.15.
//  Copyright © 2015 RG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RTCurrencyFormatter.h>
#import <RACTuple.h>

@interface RTMenuViewController : UITableViewController

@property (nonatomic, strong) RACTuple *selectedPair;
@property (nonatomic, copy) void(^onCurrencyPairSelected)(RACTuple *values);

@end
