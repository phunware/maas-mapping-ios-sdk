//
//  PWFirebaseManager.h
//  PWLocation
//
//  Created by Chesley Stephens on 2/27/17.
//  Copyright © 2017 Phunware Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AppDelegate;

@interface FBManager : NSObject

+ (FBManager *)shared;

- (void)configureWithAppDelegate:(AppDelegate *)appDelegate;

@end
