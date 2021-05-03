//
//  NSObject+IsEmpty.h
//  PWMapKit
//
//  Created by Aaron Pendley on 10/8/19.
//  Copyright © 2019 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>

// A common pattern in objective-c is to check whether a collection is nil, and then to check whether it contains any items.
// This is a convenience to make that pattern less painful and verbose.
// Inspired by http://blog.wilshipley.com/2005/10/pimp-my-code-interlude-free-code.html but modified to account
// for 'object' being an instance of type NSNull, which we would usually consider to be "empty".
// It's not the prettiest thing, but it works for all Cocoa objects for which we'd want to check for a lack of value.
// NOTE: The reason this is implemented as a free function instead of as an instance method on NSObject is because
// of the behavior of objective-c to return false-y values when sending a message to a nil object. For example,
// if we made isEmpty an instance method, and we attempted to call it on a nil object, it would always return false,
// which clearly is not what we would expect. Making it a free function ensures we get the correct behavior even when
// the reference to the collection object is nil (or NSNull).

static inline BOOL isEmpty(_Nullable id object) {
    if (object == nil) {
        return YES;
    }

    if ([object isEqual: [NSNull null]]) {
        return YES;
    }

    if ([object respondsToSelector:@selector(length)]) {
        return [(NSData *)object length] == 0;
    }

    if ([object respondsToSelector:@selector(count)]) {
        return [(NSArray *)object count] == 0;
    }

    return NO;
}
