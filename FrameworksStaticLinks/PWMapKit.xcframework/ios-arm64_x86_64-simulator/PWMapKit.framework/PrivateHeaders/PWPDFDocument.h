//
//  PWPDFDocument.h
//  PWMapKit
//
//  Copyright (c) 2015 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

/**
 A `PWPDFDocument` object represents a PDF file and defines methods for loading, unloading and viewing PDF data.
 
 The other utility classes are either instantiated from methods in `PDFDocument` or `PWPWDFPage`.
 
 Initialize a PDFDocument object with a URL to a PDF file. Then, ask for the page count, add or delete pages, perform a find or parse selected content into an NSString object.
 */

@interface PWPDFDocument : NSObject

/**
 The array of `PWPDFPage` objects associated with this document.
 */
@property (readonly) NSArray *pages;

/**
 A Boolean value that states whether the document object has been loaded. (read-only)
 */
@property (readonly, getter=isLoaded) BOOL loaded;

/**
 The file URL with which the document was initialized. (read-only)
 */
@property (readonly) NSURL *fileURL;

/**
 Returns the current size of the document. (read-only)
 */
@property (readonly) CGSize size;

/**
 A reference to the `CGPDFDocumentRef` document object. This property may be `nil` if the document has not yet been loaded.
 */
@property (readonly) CGPDFDocumentRef documentRef;

/**
 Returns a document object initialized with its file system location.
 @param fileURL A URL file identifying the location of the document on the disk. Passing `nil` or an empty URL will throw `NSInvalidArgumentException`.
 @return A Phunware PDF document object.
 */
- (instancetype)initWithFileURL:(NSURL *)fileURL;

/**
 Loads the document object.
 */
- (void)load;

/**
 Unloads the document object.
 */
- (void)unload;

@end
