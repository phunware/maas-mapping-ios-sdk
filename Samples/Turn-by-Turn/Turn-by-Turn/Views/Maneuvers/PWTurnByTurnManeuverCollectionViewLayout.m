//
//  PWTurnByTurnManeuverCollectionViewLayout.m
//  PWMapKit
//
//  Created by Phunware on 5/5/15.
//  Copyright (c) 2015 Phunware. All rights reserved.
//

#import "PWTurnByTurnManeuverCollectionViewLayout.h"

@implementation PWTurnByTurnManeuverCollectionViewLayout


-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *attributeArray = [super layoutAttributesForElementsInRect:rect];
    for (UICollectionViewLayoutAttributes *attributes in attributeArray) {
        NSIndexPath *indexPath = attributes.indexPath;
        attributes.frame = [self layoutAttributesForItemAtIndexPath:indexPath].frame;
    }
    
    return attributeArray;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    double xPos;
    
    if (indexPath.item == 0) {
        xPos = CGRectGetMinX(attributes.frame);
    } else {
        NSIndexPath* previousIndexPath = [NSIndexPath indexPathForItem:indexPath.item-1 inSection:indexPath.section];
        UICollectionViewLayoutAttributes *prevAttributes = [self layoutAttributesForItemAtIndexPath:previousIndexPath];
        xPos = CGRectGetMaxX(prevAttributes.frame)+self.cellSpacing;
    }
    
    attributes.frame = CGRectMake(xPos, 0, CGRectGetWidth(attributes.frame), CGRectGetHeight(attributes.frame));
    return attributes;
}

@end
