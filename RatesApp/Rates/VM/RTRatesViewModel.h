//
//  RTRatesViewModel.h
//  Rates
//
//  Created by Garafutdinov Ravil on 06.12.15.
//  Copyright © 2015 RG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa.h>

@interface RTRatesViewModel : NSObject

- (id)init __attribute__((unavailable("init is not a supported initializer for this class.")));

- (instancetype)initWithNetworkModel:(id)model;

// output
@property (nonatomic, strong, readonly) RACTuple *selectedPair;
@property (nonatomic, assign, readonly) double rate;
@property (nonatomic, assign, readonly) NSInteger percent;

// input
- (RACSignal *)requestRatesForPair:(RACTuple *)pair;

@end
