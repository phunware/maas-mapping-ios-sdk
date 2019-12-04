//
//  PWLandmarkType.h
//  PWMapKit
//
//  Created by Aaron Pendley on 10/11/19.
//  Copyright © 2019 Phunware. All rights reserved.
//

extern const NSInteger PWLandmarkOptionsInvalidAssociatedLandmarkIdentifier;

typedef NS_ENUM(NSUInteger, PWLandmarkType) {
    PWLandmarkTypeLandmark,
    PWLandmarkTypeAssociatedLandmark
};

typedef NS_ENUM(NSUInteger, PWLandmarkPosition) {
    PWLandmarkPositionAt,
    PWLandmarkPositionAfter
};
