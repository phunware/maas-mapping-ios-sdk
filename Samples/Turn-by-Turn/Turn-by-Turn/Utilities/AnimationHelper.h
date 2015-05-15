//
//  AnimationUnit.h
//  Turn-by-Turn
//
//  Created by Phunware on 4/27/15.
//  Copyright (c) 2015 Phunware, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

/**
 * A block that will be called several times throughout the animation while the animation is active.
 * @param setpointPercent The current setpoint of the animation. A setpoint percent of 0 will simbolize the initial state of the animation and a setpoint percent of 1 wil simbolize the end state of the animation. Depdending on the damping factor, the animation might go over 1 and oscilate but will eventually stabilize at 1.
 */
typedef void (^AnimationHelperTick)(CGFloat setpoint);
/**
 * A block that will be called then the animation is complete.
 */
typedef void (^AnimationHelperEnd)(void);

/**
 * Class that will help create an animation leveraging the UIView spring animation curve. The animation logic can be executed in the 'tickBlock' and any cleanup logic after the animation can be executed in the 'endBlock'.
 */
@interface AnimationHelper: NSObject

+(instancetype)animateWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay usingSpringWithDamping:(CGFloat)dampingRatio initialSpringVelocity:(CGFloat)velocity tickBlock:(AnimationHelperTick)tickBlock endBlock:(AnimationHelperEnd)endBlock;

- (void)cancel;

@end
