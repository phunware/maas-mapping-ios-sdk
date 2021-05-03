//
//  PWPDFDocument+Private.h
//  PWMapKit
//
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import "PWPDFDocument.h"

@interface PWPDFDocument () <NSSecureCoding>

@property NSArray *pages;
@property BOOL loaded;
@property CGPDFDocumentRef documentRef;

@end
