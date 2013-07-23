//
//  NewAddressViewController.m
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 6/26/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "NewAddressViewController.h"

#import "Address.h"
#import "Address+Manager.h"

#import "Customer.h"
#import "Customer+Manager.h"

#import "CountryState+Manager.h"

#import "EwaterFeaturesAPI.h"

#import "AppDelegate.h"

@interface NewAddressViewController ()

@property (nonatomic, strong)Address *addressModel;

@end

@implementation NewAddressViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.title = @"New Address";
	[self.addNewAddressButton setType:BButtonTypeDefault];
	[self.addNewAddressButton setColor:[AppDelegate appDelegate].color];
}

- (void)setup {
	[super setup];
	
	//	Address *address = [Address addressForCustomer:customer];
	//TODO: if address is null create new address
	//	[self.deliveryAddress setupAddress:address];
	//	[self.deliveryAddressSelectorButton setTitle:address.alias forState:UIControlStateNormal];
	//	[self.billingAddress setupAddress:address];
	
}

- (IBAction)handleAddNewAdressButton:(id)sender {
	
	[self.address unbindAddress];
	
	NSLog(@"%s | %@", __PRETTY_FUNCTION__, self.addressModel);
	
	self.addressModel = self.address.address;
	
	self.addressModel.alias = self.aliasTextField.text;
	
	Customer *customer = [AppDelegate appDelegate].sessionManager.session.customer;
	self.addressModel.id_customer = customer.id_customer;
	//...
	
	//TODO: send new address - if valid back / else display error and stay on the page
	
	
	if ([self.aliasTextField.text length] == 0) {
		[self displayMessage:@"Please set an Alias." andTitle:@"Error"];
//		[self.addressModel deleteEntity];
	}	
	else if ([self.addressModel.firstname length] == 0) {
		[self displayMessage:@"Please set a Firstname." andTitle:@"Error"];
//		[self.addressModel deleteEntity];
	}
	else if ([self.addressModel.lastname length] == 0) {
		[self displayMessage:@"Please set a Lastname." andTitle:@"Error"];
//		[self.addressModel deleteEntity];
	}
	else if ([self.addressModel.address1 length] == 0) {
		[self displayMessage:@"Please set a Address 1." andTitle:@"Error"];
//		[self.addressModel deleteEntity];
	}
	else if ([self.addressModel.postcode length] == 0) {
		[self displayMessage:@"Please set a Post Code." andTitle:@"Error"];
//		[self.addressModel deleteEntity];
	}
	else if ([self.addressModel.city length] == 0) {
		[self displayMessage:@"Please set a City." andTitle:@"Error"];
//		[self.addressModel deleteEntity];
	}
	else if ([self.addressModel.id_state intValue] == 0) {
		[self displayMessage:@"Please set a State." andTitle:@"Error"];
//		[self.addressModel deleteEntity];
	}
	else if ([self.addressModel.id_country intValue] == 0) {
		[self displayMessage:@"Please set a Country." andTitle:@"Error"];
	}
	else if ([self.addressModel.phone_mobile length] == 0) {
		[self displayMessage:@"Please set a Mobile Phone." andTitle:@"Error"];
//		[self.addressModel deleteEntity];
	}
	else
		[self sendAddress];
}

- (void)sendAddress {
	[EwaterFeaturesAPI sendAddress:self.addressModel success:^(NSMutableDictionary *result) {
		
		[self.addressModel deleteEntity];
		
		NSLog(@"%s | Success send Address: %@", __PRETTY_FUNCTION__, result);
		Address *address = [Address addUpdateAddressWhithDictionary:result];
		NSLog(@"%s | address: %@", __PRETTY_FUNCTION__, [address description]);
		
		
		
		//TODO: set default address with the new one
		
		[self.navigationController popViewControllerAnimated:YES];
		
	} failure:^(NSHTTPURLResponse *response, NSError *error) {
		NSLog(@"%s | Fail send Address", __PRETTY_FUNCTION__);
		[self.addressModel deleteEntity];
		
		//INFO: display message
		NSString *message = [[error.userInfo objectForKey:@"prestashop:errors:error:message"] lastObject];
		if (message == nil) {
			message = [error description];
		}
		
		[self displayMessage:message andTitle:@"Error"];
		
		
		//TODO: display error
	}];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField; {
	
	[textField resignFirstResponder];
	
	return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	
}

@end
