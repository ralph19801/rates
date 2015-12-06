//
//  RTDefaultAssembly.h
//  Rates
//
//  Created by Garafutdinov Ravil on 30.11.15.
//  Copyright © 2015 RG. All rights reserved.
//

#import "RTDefaultAssembly.h"
#import "RTAssemblyUtils.h"

#import <RatesApiNetworkModel.h>
#import <RatesApiClient.h>

@implementation RTDefaultAssembly

#pragma mark - model

- (id)ratesApiNetworkModel
{
    id apiClient = [self ratesApiClient];
    
    return [TyphoonDefinition withClass:[RatesApiNetworkModel class]
                          configuration:^(TyphoonDefinition *definition)
    {
        [definition useInitializer:@selector(initWithApiClient:)
                        parameters:^(TyphoonMethod *initializer)
        {
            [initializer injectParameterWith:apiClient];
        }];
        [definition setScope:TyphoonScopeSingleton];
    }];
}

- (id)ratesHttpClient
{
    return [RTAssemblyUtils httpClientWithBaseUrl:@"http://api.fixer.io/"];
}

- (id)ratesApiClient
{
    return [TyphoonDefinition withClass:[RatesApiClient class] configuration:^(TyphoonDefinition *definition)
    {
        [definition useInitializer:@selector(initWithHttpClient:)
                        parameters:^(TyphoonMethod *initializer)
         {
             [initializer injectParameterWith:[self ratesHttpClient]];
         }];
    }];
}

@end
