//
//  SimpleConfiguration.m
//  PWMapKit
//
//  Created on 8/4/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import "SimpleConfiguration.h"
#import "CommonSettings.h"

NSString * const SampleConfigurationPlist = @"SampleConfiguration-Map";

@interface SimpleConfiguration()

@end

@implementation SimpleConfiguration

+ (SimpleConfiguration *)sharedInstance {
    static SimpleConfiguration *conf;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        conf = [SimpleConfiguration new];
    });
    
    return conf;
}

- (void)fetchConfiguration:(void(^)(NSDictionary *conf, NSError *error))completion {
    if (self.configuration != nil) {
        if (completion) {
            completion(self.configuration, nil);
        }
        return;
    }
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:SampleConfigurationPlist ofType:@"plist"];
    self.configuration = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    
    if (completion) {
        completion(self.configuration, nil);
    }
}

@end
