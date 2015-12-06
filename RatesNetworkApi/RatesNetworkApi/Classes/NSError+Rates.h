//
//  NSError+Rates.h
//  RatesApiClient
//
//  Created by Garafutdinov Ravil on 05.12.15.
//  Copyright © 2015 RG. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kRatesApi_DomainName @"RatesApiErrorDomain"

typedef NS_ENUM (NSInteger, RatesApiStatus)
{
    RatesApiStatus_Undefined             = INT_MIN,
    RatesApiStatus_Unknown,
    RatesApiStatus_FileSystemError       = -4,
    RatesApiStatus_BadRequest            = -3,
    RatesApiStatus_ServerError           = -2,
    RatesApiStatus_ConnectionError       = -1,
    RatesApiStatus_OK                    = 1,
};

extern NSString * const kRatesApiErrorUserInfoOriginalErrorKey;
extern NSString * const kRatesApiErrorUserInfoServerResponseKey;

@interface NSError (Rates)

+ (NSError *)apiErrorWithCode:(RatesApiStatus)anErrorCode andUserInfo:(NSDictionary *)anUserInfo;

- (BOOL)isApiError;

@end

@interface NSDictionary (Rates)

@property (nonatomic, strong, readonly) NSError *originalError;
@property (nonatomic, strong, readonly) NSHTTPURLResponse *serverResponse;

+ (NSDictionary *)userInfoDictionaryWithUserInfo:(NSDictionary *)userInfo andOriginalError:(NSError *)originalError;
+ (NSDictionary *)userInfoWithOriginalError:(NSError *)error;
+ (NSDictionary *)userInfoWithServerResponse:(NSHTTPURLResponse *)response;

@end
