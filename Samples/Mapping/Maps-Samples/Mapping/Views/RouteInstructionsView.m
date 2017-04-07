//
//  PWRouteInstructionsView.m
//  PWMapKit
//
//  Created on 5/21/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import "RouteInstructionsView.h"
#import "RouteInstructionCollectionViewCell.h"

@interface RouteInstructionsView () <UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>

@property (strong,nonatomic) UICollectionViewFlowLayout *collectionViewFlowLayout;
@property (strong,nonatomic) UICollectionView *collectionView;
@property (nonatomic) NSIndexPath *currentIndexPath;

@end

@implementation RouteInstructionsView

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.frame = self.bounds;
        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self addSubview:blurEffectView];
        
        _collectionViewFlowLayout =[[UICollectionViewFlowLayout alloc] init];
        [_collectionViewFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _collectionViewFlowLayout.minimumInteritemSpacing = 0;
        _collectionViewFlowLayout.minimumLineSpacing = 0;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:_collectionViewFlowLayout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[RouteInstructionCollectionViewCell class] forCellWithReuseIdentifier:@"collectionCellIdentifier"];
        [self addSubview:_collectionView];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRouteInstruction:) name:PWRouteInstructionChangedNotificationKey object:nil];
        
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setRoute:(PWRoute *)route {
    _route = route;
    [self updateForInstructionChangeWithIndex:0];
    [self invalidateLayout];
}

- (instancetype)initWithRoute:(PWRoute *)route {
    if (self = [super init]) {
        self.route = route;
    }
    return self;
}

#pragma mark - Collection View DataSource and Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.route.routeInstructions count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.bounds.size.width, self.bounds.size.height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"collectionCellIdentifier";
    
    RouteInstructionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    PWRouteInstruction *instruction = [self.route.routeInstructions objectAtIndex:indexPath.row];
    
    cell.instruction = instruction;
    
    return cell;
}

- (void)invalidateLayout {
    [self.collectionView reloadData];
    [self.collectionView scrollToItemAtIndexPath:self.currentIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSUInteger currentIndex = self.collectionView.contentOffset.x / self.collectionView.frame.size.width;
    [self updateForInstructionChangeWithIndex:currentIndex];
}

#pragma mark - Current Instruction Helpers

- (void)updateForInstructionChangeWithIndex:(NSUInteger)currentIndex {
    if (self.route.routeInstructions.count > currentIndex) {
        self.currentIndexPath = [NSIndexPath indexPathForRow:currentIndex inSection:0];
        
        PWRouteInstruction *instruction = [self.route.routeInstructions objectAtIndex:currentIndex];
        
        if ([self.delegate respondsToSelector:@selector(route:didChangeRouteInstruction:)]) {
            [self.delegate route:self.route didChangeRouteInstruction:instruction];
        }
    }
}

- (void)changeRouteInstruction:(NSNotification *)notification {
    PWRouteInstruction *instruction = notification.object;
    if (!instruction) {
        return;
    }

    PWRouteInstruction *currentInstruction = self.route.routeInstructions[self.currentIndexPath.row];
    if ([currentInstruction isEqual:instruction]) {
        return;
    }
    
    NSIndexPath *toIndexPath = nil;
    for (int k=0; k < self.route.routeInstructions.count; k++) {
        PWRouteInstruction *tmpInstruction = self.route.routeInstructions[k];
        if ([tmpInstruction isEqual:instruction]) {
            toIndexPath = [NSIndexPath indexPathForRow:k inSection:0];
            break;
        }
    }
    
    if (toIndexPath) {
        [self collectionView:self.collectionView cellForItemAtIndexPath:toIndexPath];
        [self.collectionView scrollToItemAtIndexPath:toIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    }
}

@end
