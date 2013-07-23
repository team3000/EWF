//
//  AddressViewController.m
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 6/21/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "AddressViewController.h"
#import "Cart+Manager.h"
#import "EwaterFeaturesAPI.h"

#import "Customer.h"
#import "Product.h"

#import "CartRow.h"

#import "AppDelegate.h"

#import "PaymentViewController.h"

#import "HelperView.h"


#import "Address+Manager.h"
#import "Address.h"

#import "CountryState.h"
#import "CountryState+Manager.h"


@interface AddressViewController ()

@property (nonatomic, strong)Address *selectedAddress;
@property (nonatomic, assign)BOOL isAddingBillingAddress;
@property (nonatomic, assign)BOOL isAddingDeliveryAddress;

@end

@implementation AddressViewController

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
}

- (void)setup {
	[super setup];
	
	self.title = @"Address";
	self.isAddingBillingAddress = NO;
	self.isAddingDeliveryAddress = NO;
	[self.nextButton setType:BButtonTypeDefault];
	[self.nextButton setColor:[AppDelegate appDelegate].color];
	
	self.mainLabel.text =  [NSString stringWithFormat:@"Total products (tax incl.): $ %.2f", [[Cart cartPrice] doubleValue]];

	self.navigationItem.rightBarButtonItem = nil;
	
	[self setupDeliveryAddress];
}

- (void)setupDeliveryAddress {
	Customer *customer = [AppDelegate appDelegate].sessionManager.session.customer;
	
	//INFO: setup address
	Address *address = [Address addressForCustomer:customer];
	if (address == nil) {
		self.deliveryAddress.isEditable = NO;
		
		[EwaterFeaturesAPI updateAddresses:^(NSMutableDictionary *result) {
			Address *address = [Address addUpdateAddressWhithDictionary:result];
			[self.deliveryAddress setupAddress:address];
			[self.deliveryAddressSelectorButton setTitle:(address.alias == nil ? @"Add new Address" : address.alias) forState:UIControlStateNormal];
			
		} failure:^(NSHTTPURLResponse *response, NSError *error) {
			[self.deliveryAddressSelectorButton setTitle:@"Add new Address" forState:UIControlStateNormal];
		}];
		
	}
	else {
		[self.deliveryAddress setupAddress:address];
		[self.deliveryAddressSelectorButton setTitle:(address.alias == nil ? @"Add new Address" : address.alias) forState:UIControlStateNormal];
	}
}

- (void)setupBillingAddress {
	Customer *customer = [AppDelegate appDelegate].sessionManager.session.customer;
	
	//INFO: setup address
	Address *address = [Address addressForCustomer:customer];
	if (address == nil) {
		self.billingAddress.isEditable = NO;
		
		[EwaterFeaturesAPI updateAddresses:^(NSMutableDictionary *result) {
			Address *address = [Address addUpdateAddressWhithDictionary:result];
			[self.billingAddress setupAddress:address];
			[self.billingAddressSelectorButton setTitle:(address.alias == nil ? @"Add new Address" : address.alias) forState:UIControlStateNormal];
			
		} failure:^(NSHTTPURLResponse *response, NSError *error) {
			[self.billingAddressSelectorButton setTitle:@"Add new Address" forState:UIControlStateNormal];
		}];
		
	}
	else {
		[self.billingAddress setupAddress:address];
		[self.billingAddressSelectorButton setTitle:(address.alias == nil ? @"Add new Address" : address.alias) forState:UIControlStateNormal];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	//INFO: update Address controls
	if (self.isAddingDeliveryAddress) {
		[self setupDeliveryAddress];
		self.isAddingDeliveryAddress = NO;
	}
	else if (self.isAddingBillingAddress) {
		[self setupBillingAddress];
		self.isAddingBillingAddress = NO;
	}
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"paymentSegue"]) {
	
		
		PaymentViewController *paymentViewController = [segue destinationViewController];
		paymentViewController.cart = self.cart;
		
		//TODO: set the payment if neded
	}
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSInteger height;
	
	//INFO: hide signup cell
	if ((indexPath.row == 3 && self.sameAddressSwitch.isOn == YES) ) {
		self.billingAddressCell.hidden = YES;
		height = 0;
	}
	else
		height = [super tableView:tableView heightForRowAtIndexPath:indexPath];
	return height;
}

- (IBAction)sameAddressSwitchChanged:(id)sender {
//	UISwitch *switch_ = (UISwitch *)sender;

	[self tableView:self.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
	if (self.sameAddressSwitch.isOn == NO)
		self.billingAddressCell.hidden = NO;

	[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
	[self.tableView reloadData];
}

- (IBAction)handleNextButton:(id)sender {
	
	
	self.nextButton.hidden = YES;
	[self.nextActivityIndicator startAnimating];
	
	if (self.sameAddressSwitch.isOn) {
		self.billingAddress.address = self.deliveryAddress.address;
	}
	
	
#warning TODO: check fields: if fields are not well set display a message error
	
	[self sendCart];
}

#pragma mark - Send Cart

- (void)sendCart {
	
	Cart *cart = [Cart createEntity];
	
	cart.id_address_delivery = self.deliveryAddress.address.id_address;
	cart.id_address_invoice = self.billingAddress.address.id_address;
	cart.id_currency = [NSNumber numberWithInt:1];
	cart.id_shop_group =[NSNumber numberWithInt:1];
	cart.id_shop = [NSNumber numberWithInt:1];
	cart.id_carrier = [NSNumber numberWithInt:7];//0 ----- TODO: set carier at next step
	cart.secure_key = [AppDelegate appDelegate].sessionManager.session.customer.secure_key;
	NSNumber *id_customer = [AppDelegate appDelegate].sessionManager.session.customer.id_customer;
	cart.id_customer = id_customer;
	
	for (Product *product in [Product findByAttribute:@"is_in_cart" withValue:@(YES) andOrderBy:@"price" ascending:YES]) {
		CartRow *cartRow = [CartRow createEntity];
		cartRow.id_product = product.id_product;
		cartRow.quantity = product.quantity;
		cartRow.id_product_attribute = [NSNumber numberWithInt:0];
		[cart addCartRowObject:cartRow];
	}
	
	[[NSManagedObjectContext contextForCurrentThread] saveToPersistentStoreAndWait];//save:nil];
	
	[EwaterFeaturesAPI sendCart:cart success:^(NSMutableDictionary *result) {
		self.nextButton.hidden = NO;
		[self.nextActivityIndicator stopAnimating];

		NSLog(@"%s | Success send Cart: %@", __PRETTY_FUNCTION__, result);
		self.cart = [Cart addUpdateCartWhithDictionary:result];
		NSLog(@"%s | cart: %@", __PRETTY_FUNCTION__, [self.cart description]);
		

		[self performSegueWithIdentifier:@"paymentSegue" sender:self];
		
		
		
	} failure:^(NSHTTPURLResponse *response, NSError *error) {
	
		NSLog(@"%s | Fail send Cart", __PRETTY_FUNCTION__);

		//INFO: display message
		NSString *message = [[error.userInfo objectForKey:@"prestashop:errors:error:message"] lastObject];
		if (message == nil) {
			message = [error description];
		}
		
		[self displayMessage:message andTitle:@"Error"];
		
		self.nextButton.hidden = NO;
		[self.nextActivityIndicator stopAnimating];
		
#warning TODO display message error

	}];
}

- (IBAction)handleDeliveryAdressSelector:(id)sender {
	[self displayAddressSelector:^{
		if (self.selectedAddress) {
			[self.deliveryAddress setupAddress:self.selectedAddress];
			[self.deliveryAddressSelectorButton setTitle:(self.selectedAddress.alias == nil ? @"Add new Address" : self.selectedAddress.alias) forState:UIControlStateNormal];

		}
		else {
			self.isAddingDeliveryAddress = YES;

			[self performSegueWithIdentifier:@"newAddressSegue" sender:self];
		}
	} fail:^{
		 NSLog(@"Cancel Clicked");
	}];
}

- (IBAction)handleBillingAddressSelector:(id)sender {
	[self displayAddressSelector:^{
		if (self.selectedAddress) {
			[self.billingAddress setupAddress:self.selectedAddress];
			[self.billingAddressSelectorButton setTitle:(self.selectedAddress.alias == nil ? @"Add new Address" : self.selectedAddress.alias) forState:UIControlStateNormal];
		}
		else {
			self.isAddingBillingAddress = YES;

			[self performSegueWithIdentifier:@"newAddressSegue" sender:self];
		}
	} fail:^{
		NSLog(@"Cancel Clicked");
	}];
}

- (void)displayAddressSelector:(void (^)())success fail:(void (^)())fail {
	QuantityPickerView *quantityPickerView = [[QuantityPickerView alloc] initWithFrame:CGRectMake(0, 0, 100, 300)];
	quantityPickerView.quantityPickerViewDelegate = self;
	
	Customer *customer = [AppDelegate appDelegate].sessionManager.session.customer;
	
	NSArray *addressList = [Address findByAttribute:@"id_customer" withValue:customer.id_customer andOrderBy:@"id_address" ascending:YES];
	quantityPickerView.itemList = [[NSMutableArray alloc] initWithArray:addressList];
	[quantityPickerView.itemList addObject:@"Add new address"];
	

	Address *defaultAddress = [Address addressForCustomer:[AppDelegate appDelegate].sessionManager.session.customer];
	[quantityPickerView setSelectedObject:defaultAddress];

	//INFO: set selected address
	
	self.selectedAddress = defaultAddress;
	
	
	HelperView *helperView = [[HelperView alloc] initWithTitle:@"Select Address" andView:quantityPickerView];
	
	[helperView addButtonWithTitle:@"Cancel"
							  type:HelperViewButtonTypeCancel
						   handler:^(HelperView *helperView) {
							   fail();
						   }];
	
    [helperView addButtonWithTitle:@"Validate"
							  type:HelperViewButtonTypeDefault
						   handler:^(HelperView *helperView) {
							   NSLog(@"Validate Button Clicked");
							   success();   
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
	NSLog(@"%s - %d", __PRETTY_FUNCTION__, sender.quantity);
	
	
	//	NSArray *customerList = [Customer findByAttribute:@"active" withValue:[NSNumber numberWithBool:YES] andOrderBy:@"firstname" ascending:YES];
	
	Address *address = [sender.itemList objectAtIndex:row];
	if ([address isKindOfClass:[Address class]])
		self.selectedAddress = address;
	else
		self.selectedAddress = nil;
	
	//TODO: updates Address control
}

- (NSString *)quantityPicker:(QuantityPickerView *)sender stringAtRow:(NSInteger)row {
	if ([[sender.itemList objectAtIndex:row] isKindOfClass:[Address class]]) {
		Address *address = [sender.itemList objectAtIndex:row];
	
		return [NSString stringWithFormat:@"%@", address.alias];
	}
	else if ([[sender.itemList objectAtIndex:row] isKindOfClass:[NSString class]]) {
		NSString *field = [sender.itemList objectAtIndex:row];
		
		return [NSString stringWithFormat:@"%@", field];
	}
	return @"";
}

@end
