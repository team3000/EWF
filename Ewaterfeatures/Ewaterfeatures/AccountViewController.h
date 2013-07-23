//
//  AccountViewController.h
//  Eva
//
//  Created by Adrien Guffens on 5/19/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCAddress.h"
#import "BaseTableViewController.h"
#import "BButton.h"
#import "CustomCell.h"

@class Customer;
@class Employee;

@interface AccountViewController : BaseTableViewController <UITextFieldDelegate, QuantityPickerViewDelegate>

@property (nonatomic, assign)BOOL isSignup;

//
@property (strong, nonatomic) IBOutlet UITextField *genderTextField;

@property (strong, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UISwitch *newsletterSwitch;

@property (strong, nonatomic) IBOutlet UCAddress *billAddress;//INFO: main address
@property (strong, nonatomic) IBOutlet BButton *signupButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *signupIndicator;

@property (strong, nonatomic) IBOutlet CustomCell *passwordCell;
@property (strong, nonatomic) IBOutlet CustomCell *submitCell;
@property (strong, nonatomic) IBOutlet CustomCell *addressCell;


- (void)setupAccountWithCustomer:(Customer *)customer;
- (void)setupAccountWithEmployee:(Employee *)employee;

- (IBAction)handleSignupButton:(id)sender;

@end
