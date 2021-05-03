//
//  PWPDFPage+Private.h
//  PWMapKit
//
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import "PWPDFPage.h"

@interface PWPDFPage ()

@property CGPDFDocumentRef *documentRef;
@property CGPDFPageRef pageRef;
@property NSUInteger pageNumber;
@property BOOL loaded;

@end
