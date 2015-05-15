//
//  PWManeuverCollectionView.h
//  Turn-by-Turn
//
//  Created by Phunware on 4/24/15.
//  Copyright (c) 2015 Phunware, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * Collection view whose purpose is to prevent the content offset from getting changed to any value other than the one set by the ManeuverCollectionViewController.
 */
@interface PWTurnByTurnManeuverCollectionView : UICollectionView

-(void)setCustomContentOffset:(CGPoint)contentOffset;

@end
