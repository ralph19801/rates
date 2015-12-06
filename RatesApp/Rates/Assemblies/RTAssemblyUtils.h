//
//  RTAssemblyUtils.h
//  Rates
//
//  Created by Garafutdinov Ravil on 30.11.15.
//  Copyright © 2015 RG. All rights reserved.
//

@interface RTAssemblyUtils : NSObject

+ (id)definitionForClass:(Class)aClass;
+ (id)singletonDefinitionForClass:(Class)aClass;

+ (id)httpClientWithBaseUrl:(NSString *)baseUrl;

@end
