//
//  PWMapDocument.h
//  PWMapKit
//
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PWPDFDocument;
@class PWBuildingFloorResource;

/**
 A `PWMapDocument` object manages floor data and its associated assets.
 
 A map document is initialized by `PWBuildingManager`. Initializing this object is not recommended.
 */

@interface PWMapDocument : NSObject <NSCoding, NSCopying>

/**
 The floor resource associated with the map document. (read-only)
 */
@property (nonatomic, readonly) PWBuildingFloorResource *resource;

/**
 The PDF document associated with the map document. (read-only)
 */
@property (nonatomic, readonly) PWPDFDocument *pdf;

/**
 @return The URL of the document file.
 */
- (NSString *)fileURL;

@end
