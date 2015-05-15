//
//  animationHelper.m
//  Turn-by-Turn
//
//  Created by Phunware on 4/27/15.
//  Copyright (c) 2015 Phunware, Inc. All rights reserved.
//

#import "AnimationHelper.h"

@interface AnimationHelper()


@property (nonatomic, strong) UIView *helperView;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) NSTimeInterval delay;
@property (nonatomic, assign) CGFloat velocity;
@property (nonatomic, assign) CGFloat dampingRatio;

@property (nonatomic, copy) AnimationHelperEnd endBlock;
@property (nonatomic, copy) AnimationHelperTick tickBlock;

@end

@implementation AnimationHelper

+(instancetype)animateWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay usingSpringWithDamping:(CGFloat)dampingRatio initialSpringVelocity:(CGFloat)velocity tickBlock:(AnimationHelperTick)tickBlock endBlock:(AnimationHelperEnd)endBlock {
    AnimationHelper *animationHelper = [AnimationHelper new];
    animationHelper.duration = duration>0?duration:0.001;
    animationHelper.delay = delay;
    animationHelper.velocity = velocity;
    animationHelper.dampingRatio = dampingRatio;
    animationHelper.tickBlock = tickBlock;
    animationHelper.endBlock = endBlock;
    [animationHelper beginAnimation];
    return animationHelper;
}

- (void)cancel{
    [self.displayLink invalidate];
    self.displayLink = nil;
}

-(void)beginAnimation {
    self.helperView = [UIView new];
    self.helperView.hidden = YES;
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self.helperView];
    self.helperView.alpha = 0;
    
    [self beginLink];
    [UIView animateWithDuration:self.duration delay:self.delay usingSpringWithDamping:self.dampingRatio initialSpringVelocity:self.velocity options:0 animations:^{
        self.helperView.alpha = 1;
    } completion:^(BOOL finished) {
        [self endLink];
        [self.helperView removeFromSuperview];
    }];
}


-(void)beginLink {
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkTick)];
    [self.displayLink setFrameInterval:1];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

-(void)endLink {
    if (self.displayLink) {
        [self.displayLink invalidate];
        self.displayLink = nil;
        if (self.endBlock) {
            self.endBlock();
        }
    }
}

-(void)displayLinkTick {
    CGFloat percentValue =  [self.helperView.layer.presentationLayer opacity];
    if (self.tickBlock) {
        self.tickBlock(percentValue);
    }
}



@end
