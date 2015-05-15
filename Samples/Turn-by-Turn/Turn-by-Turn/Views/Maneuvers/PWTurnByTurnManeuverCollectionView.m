//
//  DummyCollectionView.m
//  Turn-by-Turn
//
//  Created by Phunware on 4/24/15.
//  Copyright (c) 2015 Phunware, Inc. All rights reserved.
//

#import "PWTurnByTurnManeuverCollectionView.h"

@interface PWTurnByTurnManeuverCollectionView()

@property CGPoint savedCustomContentOffset;

@end


@implementation PWTurnByTurnManeuverCollectionView

-(void)setCustomContentOffset:(CGPoint)contentOffset {
    self.savedCustomContentOffset = contentOffset;
    [super setContentOffset:contentOffset];
}

-(void)setContentOffset:(CGPoint)contentOffset {
    [super setContentOffset:self.savedCustomContentOffset];
}

@end
