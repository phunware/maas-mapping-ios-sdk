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

- (NSArray *)shortestPathFrom:(id<PWMapPoint>)startPoint
                           to:(id<PWMapPoint>)endPoint
          withAvailablePoints:(NSDictionary *)points
                     segments:(NSDictionary *)segments
                        error:(NSError **)error;

- (NSDictionary *)poiDistancesFor:(id<PWMapPoint>)startPoint
              withAvailablePoints:(NSDictionary *)points
                         segments:(NSDictionary *)segments
                            error:(NSError **)error;

@end
