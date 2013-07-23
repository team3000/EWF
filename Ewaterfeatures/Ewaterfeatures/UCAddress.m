//
//  UCAddress.m
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 6/6/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UITextField+Extended.h"
#import "UCAddress.h"
#import "AddressCell.h"

#import "QuantityPickerView.h"
#import "HelperView.h"

#import "Country.h"
#import "CountryState.h"

#import "AppDelegate.h"

//TODO: set with address object

@interface UCAddress ()

@property (nonatomic, strong) Country *selectedCountry;
@property (nonatomic, strong) CountryState *selectedState;

@property (nonatomic, strong)QuantityPickerView *countryQuantityPickerView;
@property (nonatomic, strong)QuantityPickerView *stateQuantityPickerView;

@end

@implementation UCAddress

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
	[super awakeFromNib];
	
	self.delegate = self;
	self.dataSource = self;
	
	self.isEditable = YES;
	
	self.layer.borderWidth = 1;
	self.layer.borderColor = [[UIColor colorWithRed:231/255.0 green:238.0/255.0 blue:245.0/255.0 alpha:1.0] CGColor];
	
	self.placeholderList = [[NSMutableArray alloc] initWithObjects:@"Firstname", @"Lastname", @"Compagny", @"Address 1", @"Address 2", @"Post code", @"City", @"State", @"Country", @"Phone", @"Mobile Phone", nil];
	self.addressList = [[NSMutableDictionary alloc] init];

}

- (void)setupAddress:(Address *)address {
	if (address) {
		self.isEditable = YES;
		self.address = address;
		[self.addressList setObject:self.address.firstname == nil ? @"" : self.address.firstname forKey:@"Firstname"];
		[self.addressList setObject:self.address.lastname == nil ? @"" : self.address.lastname forKey:@"Lastname"];
		[self.addressList setObject:self.address.compagny == nil ? @"" : self.address.compagny forKey:@"Compagny"];
		[self.addressList setObject:self.address.address1 == nil ? @"" : self.address.address1 forKey:@"Address 1"];
		[self.addressList setObject:self.address.address2 == nil ? @"" : self.address.address2 forKey:@"Address 2"];
		[self.addressList setObject:self.address.postcode == nil ? @"" : self.address.postcode forKey:@"Post code"];
		[self.addressList setObject:self.address.city == nil ? @"" : self.address.city forKey:@"City"];
		[self.addressList setObject:self.address.countryState.name == nil ? @"" : self.address.countryState.name forKey:@"State"];
		[self.addressList setObject:self.address.country.name == nil ? @"" : self.address.country.name forKey:@"Country"];
		[self.addressList setObject:self.address.phone == nil ? @"" : self.address.phone forKey:@"Phone"];
		[self.addressList setObject:self.address.phone_mobile == nil ? @"" : self.address.phone_mobile forKey:@"Mobile Phone"];
		
		//
		
		Country *country = [[Country findByAttribute:@"id_country" withValue:self.address.id_country] lastObject];
		if (country && country.name) {
			[self.addressList setObject:country.name forKey:@"Country"];
		}
		CountryState *state = [[CountryState findByAttribute:@"id_state" withValue:self.address.id_state] lastObject];
		if (state && state.name) {
			[self.addressList setObject:state.name forKey:@"State"];
		}
		
	}
	else {
		self.isEditable = NO;
		[self.addressList setObject:@"" forKey:@"Firstname"];
		[self.addressList setObject:@"" forKey:@"Lastname"];
		[self.addressList setObject:@"" forKey:@"Compagny"];
		[self.addressList setObject:@"" forKey:@"Address 1"];
		[self.addressList setObject:@"" forKey:@"Address 2"];
		[self.addressList setObject:@"" forKey:@"Post code"];
		[self.addressList setObject:@"" forKey:@"City"];
		//[self.addressList setObject:self.address.state.name forKey:@"State"];
		//[self.addressList setObject:self.address.country.name forKey:@"Country"];
		[self.addressList setObject:@"" forKey:@"Phone"];
		[self.addressList setObject:@"" forKey:@"Mobile Phone"];
	}
	[self reloadData];
	
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    // Usually the number of items in your array (the one that holds your list)
    return [self.placeholderList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //Where we configure the cell in each row
	
    static NSString *CellIdentifier = @"TextCell";
    AddressCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[AddressCell alloc] init];
    }
    // Configure the cell... setting the text of our cell's label
    cell.textField.placeholder = [self.placeholderList objectAtIndex:indexPath.row];
	cell.textField.tag = indexPath.row;
	NSString *addressField = [self.addressList objectForKey:cell.textField.placeholder];
	NSLog(@"addressField: <%@>", addressField);
	if ([addressField isEqualToString:@"\n"] || [addressField isEqualToString:@"\n\t"])
		addressField = @"";
	cell.textField.text = addressField;
	
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	//UITextField *next = textField.nextTextField;
	//if (next) {
	//		[next becomeFirstResponder];
	//INFO: to CHECK
	//	[self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0] atScrollPosition:0 animated:YES];//2
	//	} else {
	[textField resignFirstResponder];
	//		if (textField == self.passwordTextField)
	//			[self loginButton:nil];
	//	}
	//INFO: We do not want UITextField to insert line-breaks
	return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	if (self.isEditable == NO) {
		[textField resignFirstResponder];
		return;
	}
	
	if ([textField.placeholder isEqualToString:@"Country"]) {
		[textField resignFirstResponder];
		//TODO: show country selector
		[self displayCountrySelector];
	}
	else if ([textField.placeholder isEqualToString:@"State"]) {
		[textField resignFirstResponder];
		//TODO: show country selector
		[self displayStateSelector];
	}
	/*
	 if ([self.addressDelegate respondsToSelector:@selector(textFieldDidBeginEditing:forKey:)]) {
	 [self.addressDelegate textFieldDidBeginEditing:textField forKey:textField.placeholder];
	 }
	 */
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	
	[self.addressList setObject:textField.text forKey:textField.placeholder];
	
	NSString *addressField = [self.addressList objectForKey:textField.placeholder];
	
	
	NSLog(@"%s | addressField[%@] = %@", __PRETTY_FUNCTION__, textField.placeholder, addressField);
}

- (void)unbindAddress {
	if (self.address == nil)
		self.address = [Address createEntity];
	self.address.firstname = [self.addressList objectForKey:@"Firstname"] == nil ? @"" : [self.addressList objectForKey:@"Firstname"];
	self.address.lastname = [self.addressList objectForKey:@"Lastname"] == nil ? @"" : [self.addressList objectForKey:@"Lastname"];
	self.address.compagny = [self.addressList objectForKey:@"Compagny"] == nil ? @"" : [self.addressList objectForKey:@"Compagny"];
	self.address.address1 = [self.addressList objectForKey:@"Address 1"] == nil ? @"" : [self.addressList objectForKey:@"Address 1"];
	self.address.address2 = [self.addressList objectForKey:@"Address 2"] == nil ? @"" : [self.addressList objectForKey:@"Address 2"];
	self.address.postcode = [self.addressList objectForKey:@"Post code"] == nil ? @"" : [self.addressList objectForKey:@"Post code"];
	self.address.city = [self.addressList objectForKey:@"City"] == nil ? @"" : [self.addressList objectForKey:@"City"];
	
	//TODO: get the state for the selected id or oposit
	//	self.address.id_state = [self.addressList objectForKey:@"State"] == nil ? @"" : [self.addressList objectForKey:@"State"];
	NSString *countryName = [self.addressList objectForKey:@"Country"];
	if (countryName) {
		Country *country = [[Country findByAttribute:@"name" withValue:countryName] lastObject];
		if (country) {
			self.address.id_country = country.id_country;
			self.address.country = country;
		}
	}
	
	NSString *stateName = [self.addressList objectForKey:@"State"];
	if (stateName) {
		CountryState *state = [[CountryState findByAttribute:@"name" withValue:stateName] lastObject];
		if (state) {
			self.address.id_state = state.id_state;
			self.address.countryState = state;
		}
	}
	
	//
	self.address.phone = [self.addressList objectForKey:@"Phone"] == nil ? @"" : [self.addressList objectForKey:@"Phone"];
	self.address.phone_mobile = [self.addressList objectForKey:@"Mobile Phone"] == nil ? @"" : [self.addressList objectForKey:@"Mobile Phone"];
	
	
	self.address.other =  @"";
	
}

//

/*
 
 NSString *stateName = [self.addressList objectForKey:@"State"];
 if (stateName) {
 CountryState *state = [[CountryState findByAttribute:@"name" withValue:stateName] lastObject];
 if (state) {
 self.address.id_state = state.id_state;
 self.address.countryState = state;
 }
 }
 
 */

- (void)displayCountrySelector {
	self.countryQuantityPickerView = [[QuantityPickerView alloc] initWithFrame:CGRectMake(0, 0, 100, 300)];
	self.countryQuantityPickerView.quantityPickerViewDelegate = self;
	
	//	Customer *customer = [AppDelegate appDelegate].sessionManager.session.customer;
	
	NSArray *countryList = [Country findByAttribute:@"id_zone" withValue:[NSNumber numberWithInt:5] andOrderBy:@"name" ascending:YES];
	self.countryQuantityPickerView.itemList = [[NSMutableArray alloc] initWithArray:countryList];
	
	
	//INFO: select item
	NSString *countryName = [self.addressList objectForKey:@"Country"];
	Country *country = [[Country findByAttribute:@"name" withValue:countryName] lastObject];
	if (!country) {
		country = [[Country findByAttribute:@"name" withValue:@"Australia"] lastObject];
	}
	
	[self.countryQuantityPickerView setSelectedObject:country];
	self.selectedCountry = country;
	

	HelperView *helperView = [[HelperView alloc] initWithTitle:@"Select Country" andView:self.countryQuantityPickerView];
	
	[helperView addButtonWithTitle:@"Cancel"
							  type:HelperViewButtonTypeCancel
						   handler:^(HelperView *helperView) {
							   NSLog(@"Cancel Clicked");
							   self.selectedCountry = nil;
						   }];
	
    [helperView addButtonWithTitle:@"Validate"
							  type:HelperViewButtonTypeDefault
						   handler:^(HelperView *helperView) {
							   NSLog(@"Validate Button Clicked");
							   
							   if (self.selectedCountry) {
								   [self.addressList setObject:self.selectedCountry.name forKey:@"Country"];
								   //self.address.id_country = self.selectedCountry.id_country;
								   self.address.country = self.selectedCountry;
								   
								   [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
								   
								   [self reloadData];
								   //UPDATE DATA
								   //								   [self.deliveryAddress setupAddress:self.selectedAddress];
							   }
							   else {
								   //								   [self performSegueWithIdentifier:@"newAddressSegue" sender:self];
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

- (void)displayStateSelector {
	self.stateQuantityPickerView = [[QuantityPickerView alloc] initWithFrame:CGRectMake(0, 0, 100, 300)];
	self.stateQuantityPickerView.quantityPickerViewDelegate = self;
	
	//	Customer *customer = [AppDelegate appDelegate].sessionManager.session.customer;
	
	NSArray *stateList = [CountryState findByAttribute:@"id_zone" withValue:[NSNumber numberWithInt:5] andOrderBy:@"name" ascending:YES];
	self.stateQuantityPickerView.itemList = [[NSMutableArray alloc] initWithArray:stateList];
	
	//INFO: select item
	NSString *stateName = [self.addressList objectForKey:@"State"];
	CountryState *state = [[CountryState findByAttribute:@"name" withValue:stateName] lastObject];
	if (!state) {
		state = [[CountryState findByAttribute:@"name" withValue:@"Australian Capital Territory"] lastObject];
	}
	
	
	[self.stateQuantityPickerView setSelectedObject:state];
	
	self.selectedState = state;
	
	HelperView *helperView = [[HelperView alloc] initWithTitle:@"Select State" andView:self.stateQuantityPickerView];
	
	[helperView addButtonWithTitle:@"Cancel"
							  type:HelperViewButtonTypeCancel
						   handler:^(HelperView *helperView) {
							   NSLog(@"Cancel Clicked");
							   self.selectedState = nil;
						   }];
	
    [helperView addButtonWithTitle:@"Validate"
							  type:HelperViewButtonTypeDefault
						   handler:^(HelperView *helperView) {
							   NSLog(@"Validate Button Clicked");
							   
							   if (self.selectedState) {
								   if (self.selectedState.name) {
									   [self.addressList setObject:self.selectedState.name forKey:@"State"];
									   //self.address.id_country = self.selectedCountry.id_country;
									   self.address.countryState = self.selectedState;
								   }
								   [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
								   
								   [self reloadData];
								   //								   [self.deliveryAddress setupAddress:self.selectedAddress];
							   }
							   else {
								   //								   [self performSegueWithIdentifier:@"newAddressSegue" sender:self];
							   }
							   
						   }];
	
    
    helperView.willShowHandler = ^(HelperView *helperView) {
        NSLog(@"%@, willShowHandler", helperView);
    };
    helperView.didShowHandler = ^(HelperView *helperView) {
        NSLog(@"%@, didShowHandler", helperView);
		//		[quantityPickerView setSelectedRow:quantityPickerView.quantity - 1];
    };
    helperView.willDismissHandler = ^(HelperView *helperView) {
        NSLog(@"%@, willDismissHandler", helperView);
    };
    helperView.didDismissHandler = ^(HelperView *helperView) {
        NSLog(@"%@, didDismissHandler", helperView);
    };
    
    [helperView show];
}


- (void)quantityPickerDidChange:(QuantityPickerView *)sender atRow:(NSInteger)row {
	
	//	NSArray *customerList = [Customer findByAttribute:@"active" withValue:[NSNumber numberWithBool:YES] andOrderBy:@"firstname" ascending:YES];
	if ([sender isEqual:self.stateQuantityPickerView]) {
		CountryState *state = [sender.itemList objectAtIndex:row];
		if ([state isKindOfClass:[CountryState class]])
			self.selectedState = state;
		else
			self.selectedState = nil;
	}
	else if ([sender isEqual:self.countryQuantityPickerView]) {
		Country *country = [sender.itemList objectAtIndex:row];
		if ([country isKindOfClass:[Country class]])
			self.selectedCountry = country;
		else
			self.selectedCountry = nil;
	}
	
	
	//TODO: updates Address control
}

- (NSString *)quantityPicker:(QuantityPickerView *)sender stringAtRow:(NSInteger)row {
	if ([[sender.itemList objectAtIndex:row] isKindOfClass:[CountryState class]]) {
		CountryState *state = [sender.itemList objectAtIndex:row];
		
		return [NSString stringWithFormat:@"%@", state.name];
	}
	else if ([[sender.itemList objectAtIndex:row] isKindOfClass:[Country class]]) {
		Country *country = [sender.itemList objectAtIndex:row];
		
		return [NSString stringWithFormat:@"%@", country.name];
	}
	else if ([[sender.itemList objectAtIndex:row] isKindOfClass:[NSString class]]) {
		NSString *field = [sender.itemList objectAtIndex:row];
		
		return [NSString stringWithFormat:@"%@", field];
	}
	return @"";
}

@end
