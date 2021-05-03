//
//  DebugDotAnnotationView.h
//  PWMapKit
//
//  Created by Patrick Dunshee on 5/24/18.
//  Copyright © 2018 Phunware. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface PWDebugDotAnnotationView : MKAnnotationView

- (instancetype)initWithColor:(UIColor *)color diameter:(CGFloat)diameter annotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier;

@end
