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
 
 A map document is initialized by `PWBuildingManager`. Initializing this object is not recommended.
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

/**
 The URL of the document's local file.
 */
@property (readonly) NSURL *fileURL;

@end
