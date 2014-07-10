//
//  PWView.m
//  PWMapKitSample
//
//  Created by Saumitra Vaidya on 4/3/14.
//  Copyright (c) 2014 Phunware, Inc. All rights reserved.
//

#import "PWView.h"

@implementation PWView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		
		[self customInit];
		
    }
    return self;
}

- (void)customInit
{
	PWMapView *mapView = [[PWMapView alloc] initWithFrame:self.frame];
	_mapView = mapView;
    _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	[self addSubview:_mapView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
