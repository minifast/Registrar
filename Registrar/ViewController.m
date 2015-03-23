//
//  ViewController.m
//  Registrar
//
//  Created by Doc Ritezel on 3/22/15.
//  Copyright (c) 2015 Ministry of Velocity. All rights reserved.
//

#import "ViewController.h"
#import "QuartzCore/QuartzCore.h"

#import "AFNetworking.h"
#import "MRProgressOverlayView+AFNetworking.h"

@interface ViewController ()

- (IBAction)selectGender:(id)sender;
- (IBAction)selectAge:(id)sender;
- (IBAction)submit:(id)sender;

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property (nonatomic, strong) CAGradientLayer *gradient;
@property (assign) NSInteger cycle;

- (void) animateLayerWithTop:(UIColor *)top bottom:(UIColor *)bottom;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.requestCachePolicy = NSURLRequestReloadIgnoringCacheData;
    
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://localhost:3000/"] sessionConfiguration:config];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.sessionManager = sessionManager;
    
    self.cycle = 0;
    self.gradient = [CAGradientLayer layer];
    self.gradient.frame = self.view.bounds;
    self.gradient.colors = @[(id)[UIColor purpleColor].CGColor,
                             (id)[UIColor blueColor].CGColor];
    self.gradient.startPoint = CGPointMake(0, 0);
    self.gradient.endPoint = CGPointMake(1, 1);
    
    [self.view.layer insertSublayer:self.gradient atIndex:0];
    
    [self animateLayerWithTop:[UIColor redColor] bottom:[UIColor purpleColor]];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.gradient.frame = self.view.bounds;
}

- (void) animateLayerWithTop:(UIColor *)top bottom:(UIColor *)bottom {
    NSArray *fromColors = self.gradient.colors;
    NSArray *toColors = @[(id)top.CGColor, (id)bottom.CGColor];
    
    [self.gradient setColors:toColors];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"colors"];
    
    animation.fromValue             = fromColors;
    animation.toValue               = toColors;
    animation.duration              = 3.00;
    animation.removedOnCompletion   = YES;
    animation.fillMode              = kCAFillModeForwards;
    animation.timingFunction        = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.delegate              = self;
    
    [self.gradient addAnimation:animation forKey:@"animateGradient"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag == NO) { return; }
    switch (self.cycle++ % 4) {
        case 0: [self animateLayerWithTop:[UIColor purpleColor] bottom:[UIColor redColor]]; break;
        case 1: [self animateLayerWithTop:[UIColor blueColor] bottom:[UIColor purpleColor]]; break;
        case 2: [self animateLayerWithTop:[UIColor purpleColor] bottom:[UIColor blueColor]]; break;
        case 3: [self animateLayerWithTop:[UIColor redColor] bottom:[UIColor purpleColor]]; break;
    }
}

- (IBAction) selectGender:(id)sender {
    UIButton *selectedGender = (UIButton*) sender;
    
    [self performSelector:@selector(flipButton:) withObject:sender afterDelay:0.0];
    
    if(_currentlySelectedGender != nil) {
        [self flipButton:_currentlySelectedGender];
    }
    
    _currentlySelectedGender = selectedGender;
}

- (IBAction) selectAge:(id)sender {
    UIButton *selectedAge = (UIButton*)sender;
    
    [self performSelector:@selector(flipButton:) withObject:sender afterDelay:0.0];
    
    if(_currentlySelectedAge != nil) {
        [self flipButton:_currentlySelectedAge];
    }

    _currentlySelectedAge = selectedAge;
}

- (void) flipButton:(UIButton*) button {
    if (button.selected) {
        [button setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:0.6f]];
        [button setSelected:NO];
    } else {
        [button setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:0.9f]];
        [button setSelected:YES];
    }
}

- (IBAction)submit:(id)sender {
    NSURLSessionDataTask *task = [self.sessionManager POST:@"/users"
                                               parameters:self.toParams
                                                  success:^(NSURLSessionDataTask *task, id responseObject) {
                                                      [self resetForm];
                                                      [self.view endEditing:YES];
                                                  }
                                                  failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                      NSLog(@"Task %@ failed with error: %@", task, error);
                                                  }];

    MRProgressOverlayView *overlayView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    [overlayView setModeAndProgressWithStateOfTask:task];
    [overlayView setStopBlockForTask:task];
}

- (NSDictionary *)toParams {
    NSString *age = [_currentlySelectedAge accessibilityLabel];
    NSString *gender = [_currentlySelectedGender accessibilityLabel];
    
    NSDictionary *params = @{
                             @"user": @{
                                     @"name": _nameField.text,
                                     @"email": _emailField.text,
                                     @"device": _bandField.text,
                                     @"ageRange": (age == nil ? @"" : age),
                                     @"gender": (gender == nil ? @"" : gender),
                                     }
                             };
    return params;
}

- (NSString *)getAccessibilityValue:(UIButton *)button {
    if (button == nil) {
        return @"";
    }
    
    return button.accessibilityLabel;
}

- (void)resetForm {
    _nameField.text = @"";
    _emailField.text = @"";
    _bandField.text = @"";

    if (_currentlySelectedAge != nil) {
        [self flipButton:_currentlySelectedAge];
        _currentlySelectedAge = nil;
    }
    
    if (_currentlySelectedGender != nil) {
        [self flipButton:_currentlySelectedGender];
        _currentlySelectedGender = nil;
    }
}

@end
