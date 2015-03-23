//
//  ViewController.h
//  Registrar
//
//  Created by Doc Ritezel on 3/22/15.
//  Copyright (c) 2015 Ministry of Velocity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *bandField;

@property (weak, nonatomic) UIButton *currentlySelectedGender;
@property (weak, nonatomic) UIButton *currentlySelectedAge;

- (NSString *)getAccessibilityValue:(UIButton *)button;
- (NSDictionary *)toParams;
- (void)resetForm;
@end

