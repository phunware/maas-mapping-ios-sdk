//
//  PWMapAnnotation.h
//  PWMapKit
//
//  Copyright (c) 2013 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <PWMapKit/PWAnnotation.h>

@interface PWMapAnnotation : NSObject <PWAnnotation, NSCoding, NSCopying>

@property (nonatomic, assign) NSUInteger annotationID;
@property (nonatomic, assign) NSUInteger mapID;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *annotationDescription;

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString *category;

@property (nonatomic, readonly) NSURL *annotationImageURL;
@property (nonatomic, strong) NSURL *imageURL;

@property (nonatomic, strong) NSDictionary *metaData;

+ (instancetype)unpack:(NSDictionary *)dictionary;
- (NSDictionary *)dictionary;

@end
