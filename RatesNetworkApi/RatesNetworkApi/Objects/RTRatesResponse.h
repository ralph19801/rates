//
//  RTRatesResponse.h
//  RatesNetworkApi
//
//  Created by Garafutdinov Ravil on 05.12.15.
//  Copyright © 2015 RG. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface RTRatesResponse : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly) NSString *base;
@property (nonatomic, readonly) NSString *date;
@property (nonatomic, readonly) NSDictionary *rates;

@end
