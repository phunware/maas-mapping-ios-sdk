//
//  PWFloydWarshallAlgorithm.h
//  PWMapKit
//
//  Created by Xiangwei Wang on 8/23/17.
//  Copyright © 2017 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PWMapPoint;
@class PWBuilding;

@interface PWFloydWarshallAlgorithm : NSObject

- (void)pathsFrom:(id<PWMapPoint>)start to:(id<PWMapPoint>)end completion:(void(^)(NSArray<id<PWMapPoint>> *path, NSError *error))completion;

// Public for testing
- (NSArray<id<PWMapPoint>> *)pathStart:(id<PWMapPoint>)start end:(id<PWMapPoint>)end inBuilding:(PWBuilding *)building;
- (void)generateFWMatrixForBuilding:(PWBuilding *)building withCompletion:(void(^)(NSError *error))completion;

@end

