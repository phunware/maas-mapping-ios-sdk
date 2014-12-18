//
//  PWMap.h
//  PWMapKit
//
//  Created by Illya Busigin on 7/23/13.
//  Copyright (c) 2013 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PWMapData : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) NSUInteger mapID;
@property (nonatomic, assign) NSInteger campusID;
@property (nonatomic, strong) NSString *mapName;
@property (nonatomic, strong) NSString *streetAddress;

@end
