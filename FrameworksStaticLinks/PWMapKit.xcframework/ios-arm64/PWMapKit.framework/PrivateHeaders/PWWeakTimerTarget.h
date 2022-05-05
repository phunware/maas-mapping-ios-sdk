//
//  PWWeakTimerTarger.h
//  LocationDiagnostic
//
//  Created by Chesley Stephens on 5/23/17.
//  Copyright © 2017 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PWWeakTimerTarget : NSObject

- (instancetype)initWithTarget:(id)target selector:(SEL)selector;
- (void)timerDidFire:(NSTimer *)timer;

@end
