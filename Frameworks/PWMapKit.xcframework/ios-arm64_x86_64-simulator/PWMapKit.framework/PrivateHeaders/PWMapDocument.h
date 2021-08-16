//
//  PWMapDocument.h
//  PWMapKit
//
//  Copyright (c) 2015 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PWPDFDocument;
@class PWBuildingFloorResource;

/**
 A `PWMapDocument` object manages building floor data and its associated assets.
 */

@interface PWMapDocument : NSObject

/**
 The building floor resource associated with the map document. (read-only)
 */
@property (readonly) PWBuildingFloorResource *resource;

/**
 The PDF document associated with the map document. (read-only)
 */
@property (readonly) PWPDFDocument *pdf;

@end
