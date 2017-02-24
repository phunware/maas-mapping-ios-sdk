//
//  MapViewController+Search.h
//  PWMapKit
//
//  Created on 8/29/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <PWMapKit/PWMapKit.h>

#import "MapViewController+Private.h"

@interface MapViewController (Search) <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

- (void)setupSearch;

- (void)shrinkSearchField:(BOOL)shrink showCancelButton:(BOOL)showCancelButton;

- (NSArray *)search:(NSString *)keyword;

- (void)resetSearch;

@end
