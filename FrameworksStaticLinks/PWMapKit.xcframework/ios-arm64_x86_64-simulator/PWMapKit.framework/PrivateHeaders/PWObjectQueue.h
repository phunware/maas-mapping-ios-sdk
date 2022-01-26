//
//  PWObjectQueue.h
//  PWMapKit
//
//  Created by Sam Odom on 12/10/14.
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PWObjectQueue : NSObject

@property (readonly) BOOL isEmpty;
@property (readonly) id head;
@property (readonly) id tail;
@property (readonly) NSUInteger numberOfItems;

- (void)enqueueObject:(id)object;
- (id)dequeueObject;
- (void)clearObjects;

@end
