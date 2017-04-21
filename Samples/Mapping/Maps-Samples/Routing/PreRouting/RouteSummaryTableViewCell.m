//
//  RouteSummaryTableViewCell.m
//  PWMapKit
//
//  Created on 8/11/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <PWMapKit/PWMapKit.h>
#import <PureLayout/PureLayout.h>

#import "RouteSummaryTableViewCell.h"
#import "RouteAccessibilityManager.h"
#import "CommonSettings.h"

NSString * const RouteSummaryTableViewCellReuseIdentifier = @"RouteSummaryReuseIdentifier";

static CGFloat const HeaderLabelTopInset = 10.0;
static CGFloat const HeaderLabelLeftInset = 15.0;
static CGFloat const HeaderLabelRightInset = 15.0;
static CGFloat const HeaderLabelBottomInset = 10.0;

@interface RouteSummaryTableViewCell ()

@property (nonatomic, strong) PWRoute *route;
@property (nonatomic, strong) UILabel *summaryLabel;

@end

@implementation RouteSummaryTableViewCell

- (void)configureForRoute:(PWRoute *)route {
    self.route = route;
    self.backgroundColor = [CommonSettings commonNavigationBarBackgroundColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self initializeAndAddAllSubviews];
    [self configureSummaryLabel];
}

- (void)initializeAndAddAllSubviews {
    if (self.summaryLabel == nil || ![self.summaryLabel isDescendantOfView:self]) {
        self.summaryLabel = [UILabel new];
        [self addSubview:self.summaryLabel];
    }
}

- (void)configureSummaryLabel {
    self.summaryLabel.attributedText = [self routeSummaryText];
    self.summaryLabel.backgroundColor = [UIColor clearColor];
    self.summaryLabel.numberOfLines = 0;
    
    [self.summaryLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:HeaderLabelTopInset];
    [self.summaryLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:HeaderLabelBottomInset];
    [self.summaryLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:HeaderLabelLeftInset];
    [self.summaryLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:HeaderLabelRightInset];
}

- (NSAttributedString *)routeSummaryText {
    NSNumberFormatter *numberFormatter = [self numberFormatter];
    // Keys
    NSDictionary *keyTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],
                                        NSFontAttributeName:[UIFont systemFontOfSize:18.0]};
    NSString *currentFloorKeyText = PWLocalizedString(@"CurrentlyOn", @"Currently on");
    NSAttributedString *currentFloorKey = [[NSAttributedString alloc] initWithString:currentFloorKeyText attributes:keyTextAttributes];
    NSString *destinationPOIKeyText = PWLocalizedString(@"WillNavigateYouTo", @"Will navigate you to");
    NSAttributedString *destinationPOIKey = [[NSAttributedString alloc] initWithString:destinationPOIKeyText attributes:keyTextAttributes];
    NSString *travelTimeKeyText = PWLocalizedString(@"ApproximateTravelTimeIs", @"Approximate travel time is");
    NSAttributedString *travelTimeKey = [[NSAttributedString alloc] initWithString:travelTimeKeyText attributes:keyTextAttributes];
    NSString *distanceKeyText = PWLocalizedString(@"Going", @"Going");
    NSAttributedString *distanceKey = [[NSAttributedString alloc] initWithString:distanceKeyText attributes:keyTextAttributes];
    NSString *floorsToTravelKeyText = PWLocalizedString(@"Past", @"Past");
    NSAttributedString *floorsToTravelKey = [[NSAttributedString alloc] initWithString:floorsToTravelKeyText attributes:keyTextAttributes];
    
    // Values
    NSDictionary *valueTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],
                                          NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0]};
    
    PWFloor *startPointFloor = [self.route.building getFloorByFloorId:self.route.startPoint.floorID];
    PWFloor *endPointFloor = [self.route.building getFloorByFloorId:self.route.endPoint.floorID];
    
    NSAttributedString *currentFloorValue = [[NSAttributedString alloc] initWithString:startPointFloor.name?:PWLocalizedString(@"Unknown", @"Unknown") attributes:valueTextAttributes];
    NSAttributedString *destinationPOIValue = [[NSAttributedString alloc] initWithString:self.route.endPoint.title?:PWLocalizedString(@"Unknown", @"Unknown") attributes:valueTextAttributes];
    NSString *estimatedTimeString = [numberFormatter stringFromNumber:@(self.route.estimatedTime)];
    NSString *travelTimeValueText = [NSString stringWithFormat:PWLocalizedString(@"XPluralMinutes", @"%@ minutes"), estimatedTimeString];
    if ([estimatedTimeString isEqualToString:@"1"]) {
        travelTimeValueText = [NSString stringWithFormat:PWLocalizedString(@"XSingleMinute", @"%@ minute"), estimatedTimeString];
    }
    NSAttributedString *travelTimeValue = [[NSAttributedString alloc] initWithString:travelTimeValueText attributes:valueTextAttributes];
    NSString *distanceValueText = [[RouteAccessibilityManager sharedInstance] distanceFormat:self.route.distance];
    NSAttributedString *distanceValue = [[NSAttributedString alloc] initWithString:distanceValueText attributes:valueTextAttributes];
    long floors = labs(startPointFloor.level - endPointFloor.level);
    NSString *floorsToTravelValueText = [NSString stringWithFormat:PWLocalizedString(@"XPluralFloors", @"%li floors"), floors];
    if (floors == 1) {
        floorsToTravelValueText = [NSString stringWithFormat:PWLocalizedString(@"XSingleFloor", @"%li floor"), floors];
    }
    NSAttributedString *floorsToTravelValue = [[NSAttributedString alloc] initWithString:floorsToTravelValueText attributes:valueTextAttributes];
    
    
    // Construct final attributed string
    NSMutableAttributedString *summary = [NSMutableAttributedString new];
    [self addKey:currentFloorKey value:currentFloorValue toString:summary isLastLine:NO];
    [self addKey:destinationPOIKey value:destinationPOIValue toString:summary isLastLine:NO];
    [self addKey:travelTimeKey value:travelTimeValue toString:summary isLastLine:NO];
    [self addKey:distanceKey value:distanceValue toString:summary isLastLine:NO];
    [self addKey:floorsToTravelKey value:floorsToTravelValue toString:summary isLastLine:YES];
    
    return summary;
}

- (void)addKey:(NSAttributedString *)keyString value:(NSAttributedString *)valueString toString:(NSMutableAttributedString *)summary isLastLine:(BOOL)isLastLine {
    NSDictionary *newlineAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],
                                        NSFontAttributeName:[UIFont systemFontOfSize:14.0]};
    NSAttributedString *newlineAttributedString = [[NSAttributedString alloc] initWithString:@"\n" attributes:newlineAttributes];
    
    [summary appendAttributedString:keyString];
    [summary appendAttributedString:newlineAttributedString];
    [summary appendAttributedString:valueString];
    if (!isLastLine) {
        [summary appendAttributedString:newlineAttributedString];
        [summary appendAttributedString:newlineAttributedString];
    }
}

- (NSNumberFormatter *)numberFormatter {
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    formatter.formatterBehavior = NSNumberFormatterBehavior10_4;
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.roundingMode = NSNumberFormatterRoundCeiling;
    formatter.maximumFractionDigits = 0;
    return formatter;
}

@end
