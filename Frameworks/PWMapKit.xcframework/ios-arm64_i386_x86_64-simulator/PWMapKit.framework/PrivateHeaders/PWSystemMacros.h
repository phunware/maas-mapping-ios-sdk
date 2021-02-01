//
//  PWSystemMacros.h
//  PWMapKit
//
//  Copyright (c) 2015 Phunware. All rights reserved.
//

#import <PWCore/PWCore.h>

#ifndef PWMapKit_PWSystemMacros_h
#define PWMapKit_PWSystemMacros_h

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define string(i) @(i).stringValue
#define envString(env) [@{@(2):@"-dev",@(1):@"-stage",@(0):@""} objectForKey:@(env)]
#define s3EnvString(env) [@{@(2):@"-dev",@(1):@"-stage",@(0):@"-prod"} objectForKey:@(env)]

#define PWMapKitLogError(message,...) PWLogError([PWMapKit serviceName],message,__VA_ARGS__)
#define PWMapKitLogWarning(message,...) PWLogWarning([PWMapKit serviceName],message,__VA_ARGS__)
#define PWMapKitLogInfo(message,...) PWLogInfo([PWMapKit serviceName],message,__VA_ARGS__)
#define PWMapKitLogDebug(message,...) PWLogDebug([PWMapKit serviceName],message,__VA_ARGS__)

#endif
