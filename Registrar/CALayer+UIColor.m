//
//  CALayer+UIColor.m
//  Registrar
//
//  Created by Doc Ritezel on 3/22/15.
//  Copyright (c) 2015 Ministry of Velocity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@implementation CALayer(UIColor)

- (void)setBorderColorFromUIColor:(UIColor *)color {
    self.borderColor = color.CGColor;
}

@end