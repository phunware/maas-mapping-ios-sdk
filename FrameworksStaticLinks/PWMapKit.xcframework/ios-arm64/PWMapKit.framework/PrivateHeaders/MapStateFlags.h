//
//  MapStateFlags.h
//  PWMapKit
//
//  Created by Sam Odom on 2/6/15.
//  Copyright (c) 2015 Phunware. All rights reserved.
//

#ifndef PWMapKit_MapStateFlags_h
#define PWMapKit_MapStateFlags_h

#import "PWMapKitDefines.h"

typedef NS_OPTIONS(NSUInteger, MapStateFlags) {
    MapRegionChanging = 1 << 0,
    UserLocationChanging = 1 << 1,
    TrackingModeChanging = 1 << 2,
    HeadingModeChanging = 1 << 3
};

extern const MapStateFlags DefaultMapStateFlags;


BOOL MapRegionIsChanging(MapStateFlags);
void SetMapRegionIsChanging(MapStateFlags*);
void ClearMapRegionIsChanging(MapStateFlags*);

BOOL UserLocationIsChanging(MapStateFlags);
void SetUserLocationIsChanging(MapStateFlags*);
void ClearUserLocationIsChanging(MapStateFlags*);

BOOL TrackingModeIsChanging(MapStateFlags);
void SetTrackingModeIsChanging(MapStateFlags*);
void ClearTrackingModeIsChanging(MapStateFlags*);

BOOL HeadingModeIsChanging(MapStateFlags);
void SetHeadingModeIsChanging(MapStateFlags*);
void ClearHeadingModeIsChanging(MapStateFlags*);

#endif
