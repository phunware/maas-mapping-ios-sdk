//
//  PWTurnByTurnManeuversCollectionViewController+Private.h
//  PWMapKit
//
//  Created by Phunware on 5/4/15.
//  Copyright (c) 2015 Phunware. All rights reserved.
//

#import "PWTurnByTurnManeuversCollectionViewController.h"
#import "PWTurnByTurnManeuverCollectionView.h"

@interface PWTurnByTurnManeuversCollectionViewController () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>

@property (nonatomic) CGFloat cellSpacing;
@property (nonatomic) CGFloat cellWidthOffset;
@property (nonatomic) PWRouteManeuver *currentManeuver;
@property (nonatomic) UICollectionViewLayout *collectionViewLayout;
@property (nonatomic,weak) PWTurnByTurnManeuverCollectionView *collectionView;
@property (nonatomic,weak) UIScrollView *hiddenScrollView;
@property (nonatomic,strong) NSArray *maneuvers;

- (CGFloat)pageWidth;
- (NSArray*)maneuversFromMap;

@end