//
//  ConfirmVoiceOverViewController.m
//  PWMapKit
//
//  Created on 8/9/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <PureLayout/PureLayout.h>

#import "ConfirmVoiceOverViewController.h"
#import "MapViewController.h"
#import "SimpleConfiguration.h"
#import "CommonSettings.h"

NSString * const VoiceOverConfirmedKey = @"VoiceOverConfirmedKey";

static CGFloat const ButtonHeight = 60.0;
static CGFloat const ConfirmButtonBorderWidth = 1.5;
static CGFloat const RightLeftInset = 10.0;

@interface ConfirmVoiceOverViewController ()

@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIButton *settingsButton;
@property (nonatomic, strong) UILabel *confirmationTextLabel;

@end

@implementation ConfirmVoiceOverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [CommonSettings commonNavigationBarBackgroundColor];
    
    [self initializeAndAddAllSubviews];
    [self configureConfirmationTextLabel];
    [self configureConfirmButton];
    [self configureSettingsButton];
}

#pragma mark - UI Configuration

- (void)initializeAndAddAllSubviews {
    self.confirmationTextLabel = [[UILabel alloc] init];
    [self.view addSubview:self.confirmationTextLabel];
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.confirmButton];
    self.settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.settingsButton];
}

- (void)configureConfirmButton {
    self.confirmButton.backgroundColor = self.view.backgroundColor;
    self.confirmButton.layer.borderWidth = ConfirmButtonBorderWidth;
    self.confirmButton.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4].CGColor;
    [self.confirmButton setTitle:PWLocalizedString(@"ConfirmVoiceOver", @"Confirm VoiceOver") forState:UIControlStateNormal];
    [self.confirmButton.titleLabel setFont:[UIFont boldSystemFontOfSize:20.0]];
    [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.confirmButton addTarget:self action:@selector(confirmButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    [self.confirmButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.settingsButton];
    [self.confirmButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:RightLeftInset];
    [self.confirmButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:RightLeftInset];
    [self.confirmButton autoSetDimension:ALDimensionHeight toSize:ButtonHeight];
}

- (void)configureSettingsButton {
    self.settingsButton.backgroundColor = self.view.backgroundColor;
    [self.settingsButton setTitle:PWLocalizedString(@"SettingsButton", @"Settings") forState:UIControlStateNormal];
    [self.settingsButton.titleLabel setFont:[UIFont boldSystemFontOfSize:19.0]];
    [self.settingsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.settingsButton addTarget:self action:@selector(settingsButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    [self.settingsButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.settingsButton autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [self.settingsButton autoSetDimension:ALDimensionHeight toSize:ButtonHeight];
}

- (void)configureConfirmationTextLabel {
    self.confirmationTextLabel.backgroundColor = self.view.backgroundColor;
    self.confirmationTextLabel.textColor = [UIColor whiteColor];
    self.confirmationTextLabel.numberOfLines = 0;
    [self.confirmationTextLabel setAttributedText:[self textForConfirmationTextLabel]];
    
    [self.confirmationTextLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:RightLeftInset];
    [self.confirmationTextLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:RightLeftInset];
    [self.confirmationTextLabel autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.confirmationTextLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.confirmButton];
}

- (NSAttributedString *)textForConfirmationTextLabel {
    // Header
    NSString *headerText = PWLocalizedString(@"LooksLikeYouHaveVoiceOverOn", @"Looks like you have VoiceOver turned on.");
    headerText = [NSString stringWithFormat:@"%@\n%@", headerText, PWLocalizedString(@"YouWillBeAskedToUseVoiceOver", @"You will be asked to use the features for VoiceOver:")];
    NSDictionary *headerAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],
                                       NSFontAttributeName:[UIFont boldSystemFontOfSize:20.0]};
    NSAttributedString *header = [[NSAttributedString alloc] initWithString:headerText attributes:headerAttributes];
    
    // Bullet points
    NSDictionary *bulletPointAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],
                                            NSFontAttributeName:[UIFont boldSystemFontOfSize:17.0]};
    NSString *speakItemsBulletText = [NSString stringWithFormat:@"%@", PWLocalizedString(@"WillSpeakItemsOnScreen", @"Will Speak Items on the Screen.")];
    NSAttributedString *speakItemsBullet = [[NSAttributedString alloc] initWithString:speakItemsBulletText attributes:bulletPointAttributes];
    NSString *clockfaceOrientationBulletText = [NSString stringWithFormat:@"%@", PWLocalizedString(@"WillGiveDirectionsClockface", @"Will give directions using clockface orientation.")];
    NSAttributedString *clockfaceOrientationBullet = [[NSAttributedString alloc] initWithString:clockfaceOrientationBulletText attributes:bulletPointAttributes];
    NSString *wayfindingQueuesBulletText = [NSString stringWithFormat:@"%@", PWLocalizedString(@"DifferentWayfindingQueuesToDirect", @"Different Wayfinding Queues to help direct you.")];
    NSAttributedString *wayfindingQueuesBullet = [[NSAttributedString alloc] initWithString:wayfindingQueuesBulletText attributes:bulletPointAttributes];
    NSString *enableBluetoothBulletText = PWLocalizedString(@"PleaseEnableBluetooth", @"Please enable Bluetooth on your device to use this app.");
    NSAttributedString *enableBluetoothBullet = [[NSAttributedString alloc] initWithString:enableBluetoothBulletText attributes:bulletPointAttributes];
    
    // Construct final attributed string
    NSAttributedString *doubleNewlineAttributedString = [[NSAttributedString alloc] initWithString:@"\n\n"];
    NSMutableAttributedString *confirmationText = [[NSMutableAttributedString alloc] initWithAttributedString:header];
    [confirmationText appendAttributedString:doubleNewlineAttributedString];
    [confirmationText appendAttributedString:speakItemsBullet];
    [confirmationText appendAttributedString:doubleNewlineAttributedString];
    [confirmationText appendAttributedString:clockfaceOrientationBullet];
    [confirmationText appendAttributedString:doubleNewlineAttributedString];
    [confirmationText appendAttributedString:wayfindingQueuesBullet];
    [confirmationText appendAttributedString:doubleNewlineAttributedString];
    [confirmationText appendAttributedString:enableBluetoothBullet];
    
    return confirmationText;
}

#pragma mark - UI Actions

- (void)confirmButtonTapped {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:VoiceOverConfirmedKey];
    [[SimpleConfiguration sharedInstance] fetchConfiguration:^(NSDictionary *conf, NSError *error) {
        MapViewController *mapKitController = [[MapViewController alloc] initWithBuildingConfiguration:conf[@"buildings"][0]];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mapKitController];
        [self showViewController:navigationController sender:self];
    }];
}

- (void)settingsButtonTapped {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

@end
