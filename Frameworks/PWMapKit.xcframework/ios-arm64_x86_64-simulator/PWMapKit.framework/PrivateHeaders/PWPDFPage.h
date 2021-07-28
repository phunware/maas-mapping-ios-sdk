//
//  PWPDFPage.h
//  PWMapKit
//
//  Copyright (c) 2015 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

/**
 `PWPDFPage` represents data used to render PDF document pages.
 
 You can instantiate a `PWPDFPage` with the designated initializer, which includes a reference to the `CGPDFDocumentRef` document object.
 */

@interface PWPDFPage : NSObject

/**
 The `CGPDFDocumentRef` opaque reference pointer. (read-only)
 */
@property (readonly) CGPDFDocumentRef *documentRef;

/**
 The `CGPDFPageRef` opaque reference. This value may be `NULL` if the document page has not yet been loaded. (read-only)
 */
@property (readonly) CGPDFPageRef pageRef;

/**
 Returns the page number of the PDF document page. (read-only)
 */
@property (readonly) NSUInteger pageNumber;

/**
 Indicates whether the page object has been loaded. (read-only)
 */
@property (readonly, getter=isLoaded) BOOL loaded;

/**
 Initializes a PDF page object.
 @param documentRef A pointer to a `CGPDFDocumentRef` document page opaque reference from which this object is loaded.
 @param pageNumber The page number for the PDF page.
 @return A PDF page object.
 */
- (instancetype)initWithPDFDocumentRef:(CGPDFDocumentRef*)documentRef pageNumber:(NSUInteger)pageNumber;

/**
 Loads the document page into memory.
 */
- (void)load;

/**
 Unloads the document page from memory.
 */
- (void)unload;

@end
