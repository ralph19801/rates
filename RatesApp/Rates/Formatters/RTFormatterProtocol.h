//
//  RTFormatterProtocol.h
//  Rates
//
//  Created by Garafutdinov Ravil on 06.12.15.
//  Copyright © 2015 RG. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RTFormatterProtocol <NSObject>

@required
- (id)format:(id)x;

@end
