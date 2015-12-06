//
//  NSError+Rates.m
//  RatesApiClient
//
//  Created by Garafutdinov Ravil on 05.12.15.
//  Copyright © 2015 RG. All rights reserved.
//

#import "NSError+Rates.h"

NSString * const kFbgApiErrorUserInfoOriginalErrorKey   = @"kFbgApiErrorUserInfoOriginalErrorKey";
NSString * const kFbgApiErrorUserInfoServerResponseKey  = @"kFbgApiErrorUserInfoServerResponseKey";

@implementation NSError (Rates)

+ (NSError *)apiErrorWithCode:(RatesApiStatus)anErrorCode andUserInfo:(NSDictionary *)anUserInfo
{
    return [NSError errorWithDomain:kRatesApi_DomainName code:anErrorCode userInfo:anUserInfo];
}

- (BOOL)isApiError
{
    return [self.domain isEqualToString:kRatesApi_DomainName];
}

@end


@implementation NSDictionary (Rates)

+ (NSDictionary *)userInfoDictionaryWithUserInfo:(NSDictionary *)userInfo andOriginalError:(NSError *)originalError
{
    NSMutableDictionary *retval = [NSMutableDictionary dictionaryWithDictionary:userInfo];
    [retval setObject:originalError forKey:kFbgApiErrorUserInfoOriginalErrorKey];
    
    return retval;
}

+ (NSDictionary *)userInfoWithOriginalError:(NSError *)error
{
    return [NSDictionary dictionaryWithObject:error forKey:kFbgApiErrorUserInfoOriginalErrorKey];
}

+ (NSDictionary *)userInfoWithServerResponse:(NSHTTPURLResponse *)response
{
    return [NSDictionary dictionaryWithObject:response forKey:kFbgApiErrorUserInfoServerResponseKey];
}

- (NSError *)originalError
{
    return self[kFbgApiErrorUserInfoOriginalErrorKey];
}

- (NSHTTPURLResponse *)serverResponse
{
    return self[kFbgApiErrorUserInfoServerResponseKey];
}

@end
