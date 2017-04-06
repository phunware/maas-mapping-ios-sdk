//
//  PWRouteInstructionCollectionViewCell.m
//  PWMapKit
//
//  Created by Steven Spry on 5/23/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <PWMapKit/PWMapKit.h>

#import "RouteInstructionCollectionViewCell.h"
#import "CommonSettings.h"

@interface RouteInstructionCollectionViewCell ()

@property (strong,nonatomic) UIImageView *imageMovement;
@property (strong,nonatomic) UILabel *labelMovement;
@property (strong,nonatomic) UILabel *labelNext;

@property (strong,nonatomic) UIImageView *imageTurn;
@property (strong,nonatomic) UILabel *labelTurn;

@end

@implementation RouteInstructionCollectionViewCell

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        self.backgroundColor = [UIColor clearColor];
        _imageMovement = [[UIImageView alloc] init];
        _imageMovement.frame = CGRectMake(10, 18, 40, 40);
        [self.contentView addSubview:_imageMovement];
        
        
        _labelMovement = [[UILabel alloc] initWithFrame:CGRectMake(60, 15, self.bounds.size.width-60, 25)];
        _labelMovement.numberOfLines = 0;
        _labelMovement.lineBreakMode = NSLineBreakByWordWrapping;
        _labelMovement.font = [UIFont boldSystemFontOfSize:15];
        _labelMovement.textColor = [UIColor darkGrayColor];
        _labelMovement.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:_labelMovement];

        _labelNext = [[UILabel alloc] initWithFrame:CGRectMake(60, 35, self.bounds.size.width-60, 25)];
        _labelNext.numberOfLines = 0;
        _labelNext.lineBreakMode = NSLineBreakByWordWrapping;
        _labelNext.font = [UIFont boldSystemFontOfSize:14];
        _labelNext.text = @"Next: ";
        _labelNext.textColor = [UIColor darkGrayColor];
        _labelNext.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:_labelNext];
        
        _imageTurn = [[UIImageView alloc] init];
        _imageTurn.frame = CGRectMake(105, 38, 20, 20);
        [self.contentView addSubview:_imageTurn];
        
        _labelTurn = [[UILabel alloc] initWithFrame:CGRectMake(130, 35, self.bounds.size.width-130, 25)];
        _labelTurn.numberOfLines = 0;
        _labelTurn.lineBreakMode = NSLineBreakByWordWrapping;
        _labelTurn.font = [UIFont systemFontOfSize:12];
        _labelTurn.textColor = [UIColor darkGrayColor];
        _labelTurn.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:_labelTurn];
    }
    return self;
}


- (void)setInstruction:(PWRouteInstruction *)instruction {
    _instruction = instruction;
    
    PWRoute *route = instruction.route;
    NSInteger idx = [route.routeInstructions indexOfObject:instruction];
    NSInteger countInstructions = [route.routeInstructions count];
    
    self.imageMovement.image = [CommonSettings imageFromDirection:instruction.movementDirection];
    self.labelMovement.text = instruction.movement;
    if (idx == countInstructions - 1) {
        self.imageTurn.image = nil;
        self.labelTurn.text = nil;
        self.labelNext.alpha = 0.0;
        
        self.labelMovement.frame = CGRectMake(60, 20, self.bounds.size.width - 60, 25);
        self.labelMovement.numberOfLines = 0;
        self.labelMovement.lineBreakMode = NSLineBreakByWordWrapping;
        self.labelMovement.text = instruction.movement;
        [self.labelMovement sizeToFit];
    } else {
        self.imageTurn.image = [CommonSettings imageFromDirection:instruction.turnDirection];
        self.labelTurn.text = instruction.turn;
        self.labelNext.alpha = 1.0;
        
        self.labelMovement.frame = CGRectMake(60, 15, self.bounds.size.width - 60, 25);
        self.labelMovement.numberOfLines = 1;
        self.labelMovement.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.labelMovement sizeToFit];
    }
}

@end
