//
//  SimpleConfiguration.h
//  PWMapKit
//
//  Created on 8/4/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const SampleConfigurationUrl;

@interface SimpleConfiguration : NSObject

@property (nonatomic, strong) NSDictionary *configuration;

+ (SimpleConfiguration *)sharedInstance;

- (void)fetchConfiguration:(void(^)(NSDictionary *conf, NSError *error))completion;

@end
