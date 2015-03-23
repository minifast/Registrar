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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.requestCachePolicy = NSURLRequestReloadIgnoringCacheData;
    
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://localhost:3000/"] sessionConfiguration:config];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.sessionManager = sessionManager;
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
