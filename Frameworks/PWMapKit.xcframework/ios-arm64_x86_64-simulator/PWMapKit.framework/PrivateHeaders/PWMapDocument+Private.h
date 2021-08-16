//
//  PWMapDocument+Private.h
//  PWMapKit
//
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import "PWMapDocument.h"

@interface PWMapDocument ()

@property PWBuildingFloorResource *resource;
@property PWPDFDocument *pdf;

- (instancetype)initWithFilePath:(NSString *)filePath resource:(PWBuildingFloorResource *)resource;

@end
