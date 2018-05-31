//
//  PWUserLocation.h
//  PWMapKit
//
//  Copyright (c) 2015 Phunware. All rights reserved.
//

#import <PWLocation/PWLocation.h>

#import "PWMapPoint.h"

/**
 * The annotation representing the current location of the user according to the registered location manager.
 */
@interface PWUserLocation : PWIndoorLocation <PWMapPoint>

@end
