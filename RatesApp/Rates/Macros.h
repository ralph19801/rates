//
//  Macros.h
//  RadarPlus
//
//  Created by Garafutdinov Ravil on 05.11.15.
//  Copyright © 2015 FunBox LLC. All rights reserved.
//

#ifndef Macros_h
#define Macros_h

#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define NSLogRect(msg, rect) NSLog(@"%@: %.0f,%.0f %.0f*%.0f", msg, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)

#define SAFE_RUN0(x) if (x) x()
#define SAFE_RUN(x, arg) if (x) x(arg)

#endif /* Macros_h */
