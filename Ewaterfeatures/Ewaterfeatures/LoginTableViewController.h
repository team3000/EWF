//
//  LoginTableViewController.h
//  AB
//
//  Created by Adrien Guffens on 1/10/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SessionDelegate.h"
#import "BaseTableViewController.h"

@class BButton;

@interface LoginTableViewController : UITableViewController <UISearchBarDelegate, UITextFieldDelegate, SessionDelegate/*, QuantityPickerViewDelegate*/>

@property (strong, nonatomic) IBOutlet BButton *loginButton;
@property (strong, nonatomic) IBOutlet BButton *signupButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loginAcivityIndicator;

@property (strong, nonatomic) IBOutlet UITextField *loginTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIView *waitingView;



- (IBAction)loginButton:(id)sender;
- (IBAction)signupButton:(id)sender;

@end
