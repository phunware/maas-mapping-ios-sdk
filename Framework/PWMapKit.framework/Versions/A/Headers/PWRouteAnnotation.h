//
//  PWRouteAnnotation.h
//  PWMapKit
//
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import <PWMapKit/PWAnnotationProtocol.h>

@interface PWRouteAnnotation : NSObject <PWAnnotationProtocol>

@property (readonly, getter=isExit) BOOL exit;
@property (readonly, getter=isAccessible) BOOL accessible;
@property (copy, readonly) NSString *portalID;

@property (readonly) PWBuildingAnnotationType type;

@end
