//
//  DijkstraAlogrithm.h
//  PWMapKit
//
//  Created by Xiangwei Wang on 8/23/17.
//  Copyright © 2017 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PWMapPoint;

@interface PWDijkstraAlgorithm : NSObject

- (void)shortestPathFrom:(id<PWMapPoint>)startPoint
                      to:(id<PWMapPoint>)endPoint
     withAvailablePoints:(NSDictionary *)points
                segments:(NSDictionary *)segments
              completion:(void(^)(NSArray *calculatedPoints, NSError *error))completion;

@end
