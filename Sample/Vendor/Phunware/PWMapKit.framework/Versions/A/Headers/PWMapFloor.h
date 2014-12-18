//
//  PWMapFloor.h
//  PWMapKit
//
//  Created by Illya Busigin on 7/23/13.
//  Copyright (c) 2013 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PWFloorResource;

@interface PWMapFloor : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) NSUInteger floorID;
@property (nonatomic, assign) NSUInteger mapID;
@property (nonatomic, assign) NSInteger floorLevel;
@property (nonatomic, assign) CGSize coordinateSpace;

@property (nonatomic, strong) NSString *name;

@end
