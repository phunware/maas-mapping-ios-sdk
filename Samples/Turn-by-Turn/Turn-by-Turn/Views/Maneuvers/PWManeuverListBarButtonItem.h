//
//  PWManeuverListBarButtonItem.h
//  PWMapKit
//
//  Created by Phunware on 4/29/15.
//  Copyright (c) 2015 Phunware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWManeuverListBarButtonItem : UIBarButtonItem

-(instancetype)initWithTarget:(id)target action:(SEL)selector;

- (instancetype)initWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action NS_UNAVAILABLE;
- (instancetype)initWithImage:(UIImage *)image landscapeImagePhone:(UIImage *)landscapeImagePhone style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action NS_UNAVAILABLE;
- (instancetype)initWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action NS_UNAVAILABLE;
- (instancetype)initWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem target:(id)target action:(SEL)action NS_UNAVAILABLE;
- (instancetype)initWithCustomView:(UIView *)customView NS_UNAVAILABLE;
- (id)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (id)init NS_UNAVAILABLE;

@end
