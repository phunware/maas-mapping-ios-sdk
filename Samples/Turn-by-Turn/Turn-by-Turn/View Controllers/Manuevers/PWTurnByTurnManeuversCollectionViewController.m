//
//  PWManeuversCollectionViewController.m
//  Turn-by-Turn
//
//  Created by Phunware on 4/23/15.
//  Copyright (c) 2015 Phunware, Inc. All rights reserved.
//

#import "PWTurnByTurnManeuversCollectionViewController+Private.h"
#import "PWTurnByTurnManeuversCollectionViewCell.h"
#import "PWTurnByTurnManeuverCollectionView.h"
#import "PWTurnByTurnManeuverCollectionViewLayout.h"
#import "AnimationHelper.h"
#import "PWConstants.h"

#define PWTurnByTurnManeuversCurrentFloorIdKey NSStringFromSelector(@selector(currentFloorId))
#define PWTurnByTurnManeuversCurrentIndexKey NSStringFromSelector(@selector(currentIndex))

@interface PWTurnByTurnManeuversCollectionViewController () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>

@property (weak) PWMapView *mapView;
@property (nonatomic) CGFloat currentPageWidth;
@property (nonatomic) NSInteger currentIndex;
@property (nonatomic) PWBuildingFloorIdentifier currentFloorId;
@property (nonatomic) BOOL stopUpdatingManeuverStatusOnDelegateWhenScrolling;
@property (nonatomic) BOOL flatCells;
@property (nonatomic,strong) AnimationHelper *currentAnimationHelper;
@property (nonatomic,strong) NSLayoutConstraint *heightConstraint;
@property (nonatomic,strong) UIColor *flatCellBorderColor;
@property (nonatomic,strong) NSArray *heightArray;
@property (nonatomic) BOOL itemChangeNotTriggeredByUser;

@end

@implementation PWTurnByTurnManeuversCollectionViewController

static NSString * const PWTurnByTurnManeuversCollectionViewCellIdentifier = @"PWTurnByTurnManeuversCollectionViewCellIdentifier";

#pragma mark - Initialization

- (instancetype)initWithMapView:(PWMapView *)mapView {
    NSParameterAssert(mapView);
    NSParameterAssert([mapView isKindOfClass:[PWMapView class]] == YES);
    
    self = [super init];
    
    if (self) {
        _mapView = mapView;
        _flatCells = YES;
        if (_flatCells) {
            _cellSpacing = 0;
        }else{
            _cellSpacing = 10;
        }
        _cellWidthOffset = 20;
        _flatCellBorderColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
        
    }
    return self;
}

#pragma mark - Controller lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildSubviews];
    self.maneuvers = [self maneuversFromMap];
    [[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:PWUnitDisplayTypeUserDefaultsKey options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateScrollViewContentSizeAndReloadingDataIfNeeded:YES];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self updateScrollViewContentSizeAndReloadingData:YES];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self updateScrollViewContentSizeAndReloadingData:YES];
}

-(void)dealloc {
    [[NSUserDefaults standardUserDefaults] removeObserver:self forKeyPath:PWUnitDisplayTypeUserDefaultsKey];
}

#pragma mark - Notifications

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:PWUnitDisplayTypeUserDefaultsKey]) {
        [self updateScrollViewContentSizeAndReloadingData:YES];
    }
}

#pragma mark - Building content

- (void)buildSubviews {
    self.view.clipsToBounds = YES;
    
    if (self.flatCells) {
        self.heightConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[view(==120)]" options:0 metrics:nil views:@{@"view":self.view}].firstObject;
        [self.view addConstraint:self.heightConstraint];
    }else{
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view(==120)]" options:0 metrics:nil views:@{@"view":self.view}]];
    }
    
    PWTurnByTurnManeuverCollectionViewLayout *layout = [PWTurnByTurnManeuverCollectionViewLayout new];
    layout.cellSpacing = self.cellSpacing;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionViewLayout = layout;
    
    PWTurnByTurnManeuverCollectionView *collectionView = [[PWTurnByTurnManeuverCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.collectionViewLayout];
    self.collectionView = collectionView;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.pagingEnabled = YES;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    collectionView.clipsToBounds = NO;
    [collectionView registerNib:[UINib nibWithNibName:@"PWTurnByTurnManeuversCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:PWTurnByTurnManeuversCollectionViewCellIdentifier];
    [self.view addSubview:collectionView];
    
    NSDictionary *views = @{@"collection":collectionView};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[collection(==120)]" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[collection]-0-|" options:0 metrics:nil views:views]];
    
    UIScrollView *hiddenScrollView = [UIScrollView new];
    hiddenScrollView.delegate = self;
    hiddenScrollView.hidden = YES;
    hiddenScrollView.pagingEnabled = YES;
    [self.view addSubview:hiddenScrollView];
    self.hiddenScrollView = hiddenScrollView;
    
    [collectionView removeGestureRecognizer:collectionView.panGestureRecognizer];
    [collectionView addGestureRecognizer:self.hiddenScrollView.panGestureRecognizer];
    [self.hiddenScrollView removeGestureRecognizer:self.hiddenScrollView.panGestureRecognizer];
    
    if (self.flatCells) {
        self.view.backgroundColor = [UIColor whiteColor];
        
        UIView *bottomBorder = [UIView new];
        bottomBorder.backgroundColor = self.flatCellBorderColor;
        [self.view addSubview:bottomBorder];
        bottomBorder.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bottomBorder(==1)]-0-|" options:0 metrics:nil views:@{@"bottomBorder":bottomBorder}]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[bottomBorder]-0-|" options:0 metrics:nil views:@{@"bottomBorder":bottomBorder}]];
        
    }else{
        self.view.backgroundColor = [UIColor clearColor];
    }
}

- (NSArray *)maneuversFromMap {
    NSArray *items = self.mapView.currentRoute.maneuvers;
    
    // Not showing a maneuver card for portal maneuvers
    NSMutableArray *maneuversToShow = @[].mutableCopy;
    for(PWRouteManeuver *maneuver in items)
    {
        if (maneuver.isTurnManeuver) {
            continue;
        }
        [maneuversToShow addObject:maneuver];
    }
    return maneuversToShow.copy;
}

#pragma mark - Public methods

- (void)scrollOutOfScreenAnimated:(BOOL)animated {
    self.itemChangeNotTriggeredByUser = YES;
    [self scrollToPagesOffset:-1.4 animated:animated];
}

- (void)scrollToManeuver:(PWRouteManeuver*)maneuver animated:(BOOL)animated {
    for (PWRouteManeuver *aManeuver in self.maneuvers) {
        if ([aManeuver isEqual:maneuver]) {
            [self scrollToManeuverAtIndex:[self.maneuvers indexOfObject:aManeuver] animated:animated];
        }
    }
}

- (void)scrollToManeuverAtIndex:(NSInteger)index animated:(BOOL)animated {
    if (index < 0) {
        index = 0;
    }
    if (index > (self.maneuvers.count - 1)){
        index = self.maneuvers.count - 1;
    }
    if (index != self.currentIndex) {
        self.itemChangeNotTriggeredByUser  = YES;
        [self scrollToPagesOffset:index animated:animated];
    }
}

#pragma mark - Managing content layout

- (void)scrollToPagesOffset:(CGFloat)pageOffset animated:(BOOL)animated {
    if (pageOffset == -1) {
        pageOffset = -1.4;
    }
    CGFloat xOffset = [self pageWidth]*pageOffset;
    NSInteger indexBeforeScroll = self.currentIndex;
    
    if (animated) {
        
        CGFloat start = self.hiddenScrollView.contentOffset.x;
        CGFloat end = xOffset;
        self.stopUpdatingManeuverStatusOnDelegateWhenScrolling = YES;
        self.currentAnimationHelper = [AnimationHelper animateWithDuration:1 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 tickBlock:^(CGFloat setpoint) {
            self.collectionView.userInteractionEnabled = NO;
            CGFloat currentOffset = start * (1 - setpoint) + end * (setpoint);
            self.hiddenScrollView.contentOffset = CGPointMake(currentOffset, 0);
        } endBlock:^{
            self.hiddenScrollView.contentOffset = CGPointMake(end, 0);
            self.collectionView.userInteractionEnabled = YES;
            self.currentAnimationHelper = nil;
            self.stopUpdatingManeuverStatusOnDelegateWhenScrolling = NO;
            if (indexBeforeScroll != self.currentIndex) {
                [self updateManeuverStatusOnDelegate];
            }
            self.itemChangeNotTriggeredByUser = NO;
        }];
        
    }else{
        self.stopUpdatingManeuverStatusOnDelegateWhenScrolling = YES;
        self.hiddenScrollView.contentOffset = CGPointMake(xOffset, 0);
        [self.collectionView setCustomContentOffset:self.hiddenScrollView.contentOffset];
        self.stopUpdatingManeuverStatusOnDelegateWhenScrolling = NO;
        if (indexBeforeScroll != self.currentIndex) {
            [self updateManeuverStatusOnDelegate];
        }
        self.itemChangeNotTriggeredByUser = NO;
    }
}

- (CGFloat)pageWidth {
    // pageWidth =  The collection view item size plus the spacing between items. This is the amount scrolled in each scrollview paging event.
    CGFloat viewWidth = CGRectGetWidth(self.view.bounds);
    if (viewWidth > 0) {
        return CGRectGetWidth(self.view.bounds) - self.cellWidthOffset*2 + self.cellSpacing;
    }else{
        return 1;
    }
}

- (void)updateScrollViewContentSizeAndReloadingDataIfNeeded:(BOOL)reloadData {
    CGFloat pageWidth = [self pageWidth];
    if (self.currentPageWidth != pageWidth)
    {
        [self updateScrollViewContentSizeAndReloadingData:reloadData];
    }
}

- (void)updateScrollViewContentSizeAndReloadingData:(BOOL)reloadData {
    CGFloat pageWidth = [self pageWidth];
    self.currentPageWidth = pageWidth;
    CGFloat width = pageWidth * self.maneuvers.count;
    
    self.hiddenScrollView.panGestureRecognizer.enabled = NO;
    self.hiddenScrollView.frame = CGRectMake(0, 0, pageWidth, 1);
    self.hiddenScrollView.contentSize = CGSizeMake(width, 1);
    self.hiddenScrollView.panGestureRecognizer.enabled = YES;
    
    if (reloadData) {
        [self.collectionView reloadData];
    }
    [self scrollToPagesOffset:self.currentIndex animated:NO];
    
    [self buildHeightArray];
    if (self.flatCells) {
        [self adjustHeightWithPagePosition:self.currentIndex];
    }
}

- (void)buildHeightArray {
    NSMutableArray *heightArray = [NSMutableArray array];
    for (PWRouteManeuver *maneuver in self.maneuvers) {
        CGFloat itemHeight = [self collectionView:self.collectionView layout:self.collectionViewLayout sizeForItemAtIndexPath:[NSIndexPath indexPathForItem:[self.maneuvers indexOfObject:maneuver] inSection:0]].height;
        [heightArray addObject:@(itemHeight)];
    }
    self.heightArray = heightArray.copy;
}

- (void)updateManeuverStatusOnDelegate {
    if ([self.delegate respondsToSelector:@selector(turnByTurnManeuversViewDidScrollToManeuver:triggeredByUser:)]) {
        [self.delegate turnByTurnManeuversViewDidScrollToManeuver:self.currentManeuver triggeredByUser:!self.itemChangeNotTriggeredByUser];
    }
}

- (void)updateFloorStatusOnDelegate {
    if ([self.delegate respondsToSelector:@selector(turnByTurnManeuversViewDidChangeFloor:triggeredByUser:)]) {
        [self.delegate turnByTurnManeuversViewDidChangeFloor:self.currentFloorId triggeredByUser:!self.itemChangeNotTriggeredByUser];
    }
}


#pragma mark - Overwiting properties

-(void)setManeuvers:(NSArray *)maneuvers {
    NSParameterAssert([maneuvers isKindOfClass:[NSArray class]] == YES);
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
    for (NSObject * maneuver in maneuvers) {
        NSParameterAssert([maneuver isKindOfClass:[PWRouteManeuver class]] == YES);
    }
#pragma clang diagnostic pop
    _maneuvers = maneuvers;
    
    if (self.currentIndex >= 0 && self.maneuvers.count > self.currentIndex) {
        self.currentManeuver = self.maneuvers[self.currentIndex];
    }else{
        self.currentManeuver = nil;
    }
    [self updateScrollViewContentSizeAndReloadingDataIfNeeded:YES];
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    if (currentIndex < -1 || currentIndex >= ((NSInteger)self.maneuvers.count)) {
        return;
    }
    
    [self willChangeValueForKey:PWTurnByTurnManeuversCurrentIndexKey];
    _currentIndex = currentIndex;
    [self didChangeValueForKey:PWTurnByTurnManeuversCurrentIndexKey];
    
    self.currentManeuver = currentIndex >= 0 ? [self.maneuvers objectAtIndex:currentIndex] : nil;
    
    if (self.currentManeuver) {
        self.currentFloorId = [(id<PWDirectionsWaypointProtocol>)self.currentManeuver.points.firstObject floorID];
    }
    
    if (!self.stopUpdatingManeuverStatusOnDelegateWhenScrolling) {
        [self updateManeuverStatusOnDelegate];
    }
}

-(void)setCurrentFloorId:(PWBuildingFloorIdentifier)currentFloorId {
    if (currentFloorId == _currentFloorId) {
        return;
    }
    [self willChangeValueForKey:PWTurnByTurnManeuversCurrentFloorIdKey];
    _currentFloorId = currentFloorId;
    [self didChangeValueForKey:PWTurnByTurnManeuversCurrentFloorIdKey];
    [self updateFloorStatusOnDelegate];
}

+(BOOL)automaticallyNotifiesObserversForKey:(NSString *)key {
    NSArray *manualKeys = @[PWTurnByTurnManeuversCurrentFloorIdKey, PWTurnByTurnManeuversCurrentIndexKey];
    return ![manualKeys containsObject:key];
}

#pragma mark - <UIScrollViewDelegate>

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.hiddenScrollView] && self.hiddenScrollView.panGestureRecognizer.enabled)
    {
        [self.collectionView setCustomContentOffset:self.hiddenScrollView.contentOffset];
        
        CGFloat position = self.hiddenScrollView.contentOffset.x / [self pageWidth];
        
        if (self.flatCells) {
            [self adjustHeightWithPagePosition:position];
        }
        
        NSInteger page = round(position);
        if (page != self.currentIndex) {
            self.currentIndex = page;
        }
        
    }
}

- (void)adjustHeightWithPagePosition:(CGFloat)position {
    CGFloat currentHeight = 0;
    NSInteger lastItemIndex = self.maneuvers.count - 1;
    if (position < 0) {
        if (lastItemIndex > -1) {
            currentHeight =  ((NSNumber*)self.heightArray.firstObject).doubleValue;
            PWRouteManeuver *maneuver = self.maneuvers.firstObject;
            [[NSNotificationCenter defaultCenter] postNotificationName:PWTurnByTurnManeuversAlphaNotification object:nil userInfo:@{PWTurnByTurnManeuversAlphaNotificationManeuverKey:maneuver,PWTurnByTurnManeuversAlphaNotificationAlphaKey:@(1)}];
        }
    } else if (position > lastItemIndex ) {
        if (lastItemIndex > -1) {
            currentHeight =  ((NSNumber*)self.heightArray.lastObject).doubleValue;;
            PWRouteManeuver *maneuver = self.maneuvers.lastObject;
            [[NSNotificationCenter defaultCenter] postNotificationName:PWTurnByTurnManeuversAlphaNotification object:nil userInfo:@{PWTurnByTurnManeuversAlphaNotificationManeuverKey:maneuver,PWTurnByTurnManeuversAlphaNotificationAlphaKey:@(1)}];
        }
    } else {
        
        NSInteger firstItemIndex = floor(position);
        NSInteger secondItemIndex = ceil(position);
        
        if (firstItemIndex == secondItemIndex) {
            currentHeight =  ((NSNumber*)self.heightArray[firstItemIndex]).doubleValue;
            PWRouteManeuver *maneuver = self.maneuvers[firstItemIndex];
            [[NSNotificationCenter defaultCenter] postNotificationName:PWTurnByTurnManeuversAlphaNotification object:nil userInfo:@{PWTurnByTurnManeuversAlphaNotificationManeuverKey:maneuver,PWTurnByTurnManeuversAlphaNotificationAlphaKey:@(1)}];
        } else {
            NSIndexPath *firstIndexPath = [NSIndexPath indexPathForItem:firstItemIndex inSection:0];
            NSIndexPath *secondIndexPath = [NSIndexPath indexPathForItem:secondItemIndex inSection:0];
            
            CGFloat firstItemHeight = ((NSNumber*)self.heightArray[firstItemIndex]).doubleValue;;
            CGFloat secondItemHeight = ((NSNumber*)self.heightArray[secondItemIndex]).doubleValue;;
            
            CGFloat intervalOffset = position - firstItemIndex;
            currentHeight = firstItemHeight * (1 - intervalOffset) + secondItemHeight * (intervalOffset);
            PWRouteManeuver *firstManeuver = self.maneuvers[firstIndexPath.item];
            PWRouteManeuver *secondManeuver = self.maneuvers[secondIndexPath.item];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:PWTurnByTurnManeuversAlphaNotification object:nil userInfo:@{PWTurnByTurnManeuversAlphaNotificationManeuverKey:firstManeuver,PWTurnByTurnManeuversAlphaNotificationAlphaKey:@((1-intervalOffset))}];
            [[NSNotificationCenter defaultCenter] postNotificationName:PWTurnByTurnManeuversAlphaNotification object:nil userInfo:@{PWTurnByTurnManeuversAlphaNotificationManeuverKey:secondManeuver,PWTurnByTurnManeuversAlphaNotificationAlphaKey:@((intervalOffset))}];
        }
    }
    self.heightConstraint.constant = currentHeight;
}

#pragma mark <UICollectionViewDelegateFlowLayout>

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return self.cellSpacing;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0,self.cellWidthOffset, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGRect bounds = self.view.bounds;
    
    static PWTurnByTurnManeuversCollectionViewCell *dummyCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dummyCell = [[NSBundle mainBundle] loadNibNamed:@"PWTurnByTurnManeuversCollectionViewCell"
                                                  owner:self
                                                options:nil].firstObject;
    });
    
    double itemWidth = CGRectGetWidth(bounds) - (self.cellWidthOffset * 2);
    
    PWRouteManeuver *maneuver = self.maneuvers[indexPath.item];
    dummyCell.bounds = CGRectMake(0, 0, itemWidth,CGRectGetHeight(dummyCell.bounds));
    
    
    [dummyCell configureWithManeuver:maneuver inMapView:self.mapView flatAppearance:self.flatCells];
    
    [dummyCell setNeedsLayout];
    [dummyCell layoutIfNeeded];
    
    [dummyCell updatePreferedWidthInLabels];
    
    CGFloat height = [dummyCell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return CGSizeMake(itemWidth, height);
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.maneuvers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PWTurnByTurnManeuversCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PWTurnByTurnManeuversCollectionViewCellIdentifier forIndexPath:indexPath];
    if (self.flatCells) {
        cell.backgroundColor = UIColor.clearColor;
    }else{
        cell.backgroundColor = UIColor.whiteColor;
        cell.clipsToBounds = NO;
        cell.layer.cornerRadius = 2;
        cell.layer.shadowColor = UIColor.blackColor.CGColor;
        cell.layer.shadowRadius = 2;
        cell.layer.shadowOpacity = 0.3;
        cell.layer.shadowOffset = CGSizeMake(0, 1);
        CGSize size = [self collectionView:collectionView layout:self.collectionViewLayout sizeForItemAtIndexPath:indexPath];
        cell.layer.shadowPath = [[UIBezierPath bezierPathWithRect:CGRectMake(0, 0, size.width, size.height)] CGPath];
    }
    
    PWRouteManeuver *maneuver = self.maneuvers[indexPath.item];
    
    [cell configureWithManeuver:maneuver inMapView:self.mapView flatAppearance:self.flatCells];
    cell.rightBorder.backgroundColor = self.flatCellBorderColor;
    
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    [cell updatePreferedWidthInLabels];
    
    return cell;
}

@end
