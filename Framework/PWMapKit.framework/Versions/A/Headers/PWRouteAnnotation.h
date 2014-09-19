//
//  PWRouteAnnotation.h
//  PWMapKit
//
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import <PWMapKit/PWAnnotation.h>

@interface PWRouteAnnotation : NSObject <PWAnnotation>

@property (nonatomic, readonly) BOOL isExit;
@property (nonatomic, readonly) BOOL isAccessible;
@property (nonatomic, readonly) NSString *portalID;

@property (nonatomic, readonly) NSInteger type;

@end
