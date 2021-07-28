//
//  PWLandmark+Private.h
//  PWMapKit
//
//  Created by Aaron Pendley on 10/11/19.
//  Copyright © 2019 Phunware. All rights reserved.
//

#import "PWLandmark.h"

NS_ASSUME_NONNULL_BEGIN

@interface PWLandmark()

- (instancetype)initWithType:(PWLandmarkType)landmarkType
                        name:(NSString*)name
                    position:(PWLandmarkPosition)position
                    distance:(CLLocationDistance)distance NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
