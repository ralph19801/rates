//
//  RTAssemblyUtils.m
//  Rates
//
//  Created by Garafutdinov Ravil on 30.11.15.
//  Copyright © 2015 RG. All rights reserved.
//

#import "RTAssemblyUtils.h"
#import "TyphoonAssembly.h"

@implementation RTAssemblyUtils

+ (id)definitionForClass:(Class)aClass
{
    return [TyphoonDefinition withClass:aClass
                          configuration:^(TyphoonDefinition *definition) {
                              [definition useInitializer:@selector(init) parameters:nil];
                          }];
}

+ (id)singletonDefinitionForClass:(Class)aClass
{
    return [TyphoonDefinition withClass:aClass
                          configuration:^(TyphoonDefinition *definition) {
                              [definition useInitializer:@selector(init) parameters:nil];
                              [definition setScope:TyphoonScopeSingleton];
                          }];
}

+ (id)httpClientWithBaseUrl:(NSString *)baseUrl
{
    return [TyphoonDefinition withClass:[AFHTTPRequestOperationManager class] configuration:^(TyphoonDefinition *definition)
            {
                [definition useInitializer:@selector(initWithBaseURL:) parameters:^(TyphoonMethod *initializer)
                 {
                     [initializer injectParameterWith:[NSURL URLWithString:baseUrl]];
                 }];
                
                AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
                [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                [definition injectProperty:@selector(requestSerializer) with:requestSerializer];
                
                [definition injectProperty:@selector(responseSerializer) with:[AFJSONResponseSerializer serializer]];
            }];
}

@end
