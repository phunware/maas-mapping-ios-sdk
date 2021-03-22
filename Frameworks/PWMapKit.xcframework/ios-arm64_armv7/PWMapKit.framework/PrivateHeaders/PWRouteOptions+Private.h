//
//  PWRouteOptions+Private.h
//  PWMapKit
//
//  Created by Aaron Pendley on 10/16/19.
//  Copyright © 2019 Phunware. All rights reserved.
//

#import "PWRouteOptions.h"

@interface PWRouteOptions()

/**
 Flag indicating whether the requested directions must include only visually impaired friendly points.
 @discussion The default value for this option is `false`.
 */
// APENDLEY: Currently the `visualImpairedEnabled` property is not completely exposed to customers. They can set this flag on POIs/Waypoints,
// however currently the SDK does not provide a way to filter out 'visualImpaired' points when routing. When we do officially
// provide it, we should then make this flag publicly available.
@property(nonatomic, assign) BOOL visualImpairedEnabled;

@end
