//
//  AccountViewController.m
//  Eva
//
//  Created by Adrien Guffens on 5/19/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "AccountViewController.h"
#import "AppDelegate.h"
#import "Customer.h"
#import "Address.h"
#import "Address+Manager.h"

#import "Customer+Manager.h"

#import "HelperView.h"
#import "QuantityPickerView.h"

#import "Employee.h"

//TODO: add button on bottom to update account

@interface AccountViewController ()

@property (nonatomic, strong)NSMutableArray *genderList;
@property (nonatomic, assign)NSNumber *selectedGender;

@property (nonatomic, strong)QuantityPickerView *genderQuantityPickerView;

@end

@implementation AccountViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)awakeFromNib {
	self.genderList = [[NSMutableArray alloc] initWithObjects:@"Mr.", @"Ms.", @"Miss.", nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setup {
    [super setup];
	//INFO: do additional stuff
	
	if (self.isSignup == YES) {
		self.title = @"Signup";
	}
	
	[self.signupButton setColor:[AppDelegate appDelegate].color];
	
	UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
	[self.tableView addGestureRecognizer:gestureRecognizer];
	
	self.navigationItem.rightBarButtonItem = nil;
	
	Customer *customer = [AppDelegate appDelegate].sessionManager.session.customer;
	if (customer)
		[self setupAccountWithCustomer:customer];
	else {
		Employee *employee = [AppDelegate appDelegate].sessionManager.session.employee;
		[self setupAccountWithEmployee:employee];
	}
}

//

- (void)setupAccountWithCustomer:(Customer *)customer {
	if (customer) {
		//Customer *customer = [AppDelegate appDelegate].sessionManager.session.customer;
		if ([customer.id_gender intValue] > 0)
			self.genderTextField.text = [self.genderList objectAtIndex:[customer.id_gender intValue] - 1];
		else
			self.genderTextField.text = [self.genderList objectAtIndex:0];
		self.firstNameTextField.text = customer.firstname;
		self.lastNameTextField.text = customer.lastname;
		self.emailTextField.text = customer.email;
		//		self.passwordTextField.text = customer.passwd;
		self.newsletterSwitch.on = [customer.newsletter boolValue];
		
		Address *address = [Address addressForCustomer:customer];
		[self.billAddress setupAddress:address];
	}
}

- (void)setupAccountWithEmployee:(Employee *)employee {
	if (employee) {
		//Customer *customer = [AppDelegate appDelegate].sessionManager.session.customer;
		self.firstNameTextField.text = employee.firstname;
		self.lastNameTextField.text = employee.lastname;
		self.emailTextField.text = employee.email;
		//		self.passwordTextField.text = customer.passwd;
		//		Address *address = [Address addressForEmployee:employee];
		[self.billAddress setupAddress:nil];
	}
}

//

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)hideKeyboard:(NSNotification *)notification {
	if ([self.firstNameTextField isFirstResponder])
		[self.firstNameTextField resignFirstResponder];
	else if ([self.lastNameTextField isFirstResponder])
		[self.lastNameTextField resignFirstResponder];
	else if ([self.emailTextField isFirstResponder])
		[self.emailTextField resignFirstResponder];
	[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:0 animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    //Change the selected background view of the cell.
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)handleSignupButton:(id)sender {
	
	//INFO: check fields and display error
	
	if ([self.genderTextField.text length] == 0) {
		[self displayMessage:@"Please set a Gender." andTitle:@"Error"];
		return;
	}
	else if ([self.firstNameTextField.text length] == 0) {
		[self displayMessage:@"Please set a Firstname." andTitle:@"Error"];
		return;
	}
	else if ([self.lastNameTextField.text length] == 0) {
		[self displayMessage:@"Please set a LastName." andTitle:@"Error"];
		return;
	}
	else if ([self.emailTextField.text length] == 0) {
		[self displayMessage:@"Please set an Email." andTitle:@"Error"];
		return;
	}
	else if ([self.passwordTextField.text length] < 6) {
		[self displayMessage:@"Please set a password with at least 6 characters long." andTitle:@"Error"];
		return;
	}
	
	//
	self.signupButton.hidden = YES;
	[self.signupIndicator startAnimating];
	
	
	Customer *customer = [Customer createEntity];
	
	customer.passwd =  self.passwordTextField.text;//@"12345678";
	customer.lastname = self.lastNameTextField.text;//@"Test";
	customer.firstname = self.firstNameTextField.text;//@"Adril";
	customer.email = self.emailTextField.text;//@"test@43.com";
	
	NSInteger selectedGender = 0;
	if ([self.genderTextField.text isEqualToString:@"Mr."])
		selectedGender = 0;
	else if ([self.genderTextField.text isEqualToString:@"Ms."])
		selectedGender = 1;
	else if ([self.genderTextField.text isEqualToString:@"Miss."])
		selectedGender = 2;
	
	
	customer.id_gender = @(selectedGender);
	customer.newsletter = @(self.newsletterSwitch.on);
	customer.optin = @(NO);
	
	[EwaterFeaturesAPI sendCustomer:customer success:^(NSMutableDictionary *result) {
		[customer deleteEntity];
		NSLog(@"%s | Success send Customer: %@", __PRETTY_FUNCTION__, result);
		
		Customer *customer = [Customer addUpdateCustomerWithDictionary:result];
		
		[[AppDelegate appDelegate].sessionManager setupSessionWithLogin:customer.email password:customer.passwd];
		
		[AppDelegate appDelegate].sessionManager.session.employee = nil;
		[AppDelegate appDelegate].sessionManager.session.customer = customer;
		
		[AppDelegate appDelegate].userType = UserTypeClient;
		/*
		[EwaterFeaturesAPI updateForCustomer:^{
#warning TO COMPLETE
			NSLog(@"END updateForCustomer -- TO COMPLETE");
			
		}];
		 */
		
		
		[self performSegueWithIdentifier:@"loginSegue" sender:self];
		
		NSLog(@"%s | %@", __PRETTY_FUNCTION__, [customer description]);
		
	} failure:^(NSHTTPURLResponse *response, NSError *error) {
		NSLog(@"%s | Fail send Customer", __PRETTY_FUNCTION__);
		
		[customer deleteEntity];
		
		NSString *message = [[error.userInfo objectForKey:@"prestashop:errors:error:message"] lastObject];
		if (message == nil) {
			message = [error description];
		}
		
		[self displayMessage:message andTitle:@"Error"];
		
		self.signupButton.hidden = NO;
		[self.signupIndicator stopAnimating];
		
	}];
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSInteger height;
	
	//INFO: hide signup cell
	if ((indexPath.row == 4 || indexPath.row == 7) && self.isSignup == NO) {
		self.passwordCell.hidden = YES;
		self.submitCell.hidden = YES;
		height = 0;
	}
	else if ((indexPath.row == 6) && self.isSignup == YES) {
		self.addressCell.hidden = YES;
		height = 0;
	}
	else
		height = [super tableView:tableView heightForRowAtIndexPath:indexPath];
	return height;
}

#pragma mark - TextFields delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	if ([textField isEqual:self.genderTextField]) {
		[textField resignFirstResponder];
		[self displayGenderSelector];
		return NO;
	}
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
	[textField resignFirstResponder];
	//INFO: We do not want UITextField to insert line-breaks
	return NO;
}

//

- (void)displayGenderSelector {
	self.genderQuantityPickerView = [[QuantityPickerView alloc] initWithFrame:CGRectMake(0, 0, 100, 300)];
	self.genderQuantityPickerView.quantityPickerViewDelegate = self;
	
	self.genderQuantityPickerView.itemList = self.genderList;
	NSInteger selectedRow = 0;
	if ([self.genderTextField.text isEqualToString:@"Mr."])
		selectedRow = 0;
	else if ([self.genderTextField.text isEqualToString:@"Ms."])
		selectedRow = 1;
	else if ([self.genderTextField.text isEqualToString:@"Miss."])
		selectedRow = 2;
	
	[self.genderQuantityPickerView setSelectedRow:selectedRow];
	self.selectedGender = @(selectedRow + 1);
	
	HelperView *helperView = [[HelperView alloc] initWithTitle:@"Select Gender" andView:self.genderQuantityPickerView];
	
	[helperView addButtonWithTitle:@"Cancel"
							  type:HelperViewButtonTypeCancel
						   handler:^(HelperView *helperView) {
							   NSLog(@"Cancel Clicked");
							   self.selectedGender = nil;
						   }];
	
    [helperView addButtonWithTitle:@"Validate"
							  type:HelperViewButtonTypeDefault
						   handler:^(HelperView *helperView) {
							   NSLog(@"Validate Button Clicked");
							   
							   if (self.selectedGender) {
								   if ([self.selectedGender intValue] > 0 && [self.selectedGender intValue] < 4)
									   self.genderTextField.text = [self.genderList objectAtIndex:[self.selectedGender intValue] - 1];
							   }
						   }];
	
    
    helperView.willShowHandler = ^(HelperView *helperView) {
        NSLog(@"%@, willShowHandler", helperView);
    };
    helperView.didShowHandler = ^(HelperView *helperView) {
        NSLog(@"%@, didShowHandler", helperView);
    };
    helperView.willDismissHandler = ^(HelperView *helperView) {
        NSLog(@"%@, willDismissHandler", helperView);
    };
    helperView.didDismissHandler = ^(HelperView *helperView) {
        NSLog(@"%@, didDismissHandler", helperView);
    };
    
    [helperView show];
}

//

- (void)quantityPickerDidChange:(QuantityPickerView *)sender atRow:(NSInteger)row {
	
	self.selectedGender = @(row + 1);
}

- (NSString *)quantityPicker:(QuantityPickerView *)sender stringAtRow:(NSInteger)row {
	
	return [NSString stringWithFormat:@"%@", [self.genderList objectAtIndex:row]];
}

@end
