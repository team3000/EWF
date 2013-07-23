//
//  BaseTableViewController.m
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 5/30/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "BaseTableViewController.h"
#import "AppDelegate.h"
#import "Product+Manager.h"

#import "AccountViewController.h"

#import "MyCartViewController.h"
#import "AddressViewController.h"

#import "OrdersViewController.h"

#import "Customer.h"
#import "Customer+Manager.h"

#import "HelperView.h"

@interface BaseTableViewController ()

@property (nonatomic, strong) Customer *selectedCustomer;

@end

@implementation BaseTableViewController

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
	self.userType = [AppDelegate appDelegate].userType;
	
    [super viewDidLoad];
	
	[self setup];
	
	//INFO: if logged as Seller display button
	if (self.userType == UserTypeSeller) {
		//TODO: change @"AG" by real name
//		NSString *userButtonText = [NSString stringWithFormat:@"Logged as %@", @"AG"];
		
		UIBarButtonItem *userButton = [[UIBarButtonItem alloc] initWithTitle:@"No Customer Selected" style:UIBarButtonItemStylePlain target:self action:@selector(handleUser:)];
		self.navigationItem.rightBarButtonItem = userButton;
		
		[self updateLoggedCustomer];
		
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	if (self.userType == UserTypeSeller) {
		[self updateLoggedCustomer];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Setup (when view is loaded)

- (void)setup {
	//INFO: setup background
	UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.height, self.view.bounds.size.width)];
    [backgroundView setBackgroundColor:[UIColor colorWithRed:227.0 / 255.0 green:227.0 / 255.0 blue:227.0 / 255.0 alpha:1.0]];
    [self.tableView setBackgroundView:backgroundView];
	
	[self updateBadgeCartValue];
}

- (void)updateBadgeCartValue {
	int quantityOfProductsInCart = [Product quantityOfProductsInCart];
	
	[[[[[self tabBarController] viewControllers] objectAtIndex:1] tabBarItem] setBadgeValue:[NSString stringWithFormat:@"%d", quantityOfProductsInCart]];
}

#pragma mark - handler

- (void)handleUser:(id)sender {
	NSLog(@"%s User button pressed", __PRETTY_FUNCTION__);
	//TODO: do what ever you want
	[self displayUserSelector];
}
//

- (void)displayUserSelector {
	
	QuantityPickerView *quantityPickerView = [[QuantityPickerView alloc] initWithFrame:CGRectMake(0, 0, 100, 300)];
	quantityPickerView.quantityPickerViewDelegate = self;
	
	NSArray *customerList = [Customer findByAttribute:@"active" withValue:[NSNumber numberWithBool:YES] andOrderBy:@"firstname" ascending:YES];
	if ([customerList count] == 0) {
		[EwaterFeaturesAPI updateCustomers:^(NSMutableDictionary *result) {
			Customer *customer = [Customer addUpdateCustomerWithDictionary:result];
			[quantityPickerView.itemList addObject:customer];
			[quantityPickerView setSelectedObject:customer];
			[quantityPickerView reloadAllComponents];
		} failure:^(NSHTTPURLResponse *response, NSError *error) {
			
		}];
	}
	quantityPickerView.itemList = [[NSMutableArray alloc] initWithArray:customerList];

	Customer *customer = [AppDelegate appDelegate].sessionManager.session.customer;
	if (customer)
		[quantityPickerView setSelectedObject:customer];
	else
		[quantityPickerView setSelectedRow:0];
	
	
	
	HelperView *helperView = [[HelperView alloc] initWithTitle:@"Select User" andView:quantityPickerView];
	
	[helperView addButtonWithTitle:@"Cancel"
							  type:HelperViewButtonTypeCancel
						   handler:^(HelperView *helperView) {
							   NSLog(@"Cancel Clicked");
							   self.selectedCustomer = nil;
						   }];
	
    [helperView addButtonWithTitle:@"Validate"
							  type:HelperViewButtonTypeDefault
						   handler:^(HelperView *helperView) {
							   NSLog(@"Validate Button Clicked");
							   
							   if (self.selectedCustomer == nil) {
								   self.selectedCustomer = [quantityPickerView.itemList objectAtIndex:quantityPickerView.selectedRow]; //
							   }
							   [[AppDelegate appDelegate].sessionManager setupSessionWithCustomer:self.selectedCustomer];
							   
							   [self updateLoggedCustomer];
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

- (void)updateLoggedCustomer {
	if ([self isKindOfClass:[AddressViewController class]]) {
		[self.navigationItem.rightBarButtonItem setTitle:@""];
		return;
	}
	Customer *customer = [AppDelegate appDelegate].sessionManager.session.customer;
	if (customer) {
		NSString *first = [customer.firstname substringToIndex:1];
		NSString *last = [customer.lastname substringToIndex:1];
		NSString *name = [NSString stringWithFormat:@"%@%@", first, last];
		if (![self isKindOfClass:[MyCartViewController class]]) {
			
			[self.navigationItem.rightBarButtonItem setTitle:[NSString stringWithFormat:@"Logged as %@", name]];
			if ([self isKindOfClass:[AccountViewController class]]) {
				[self setup];
			}
			if ([self isKindOfClass:[OrdersViewController class]]) {
#warning setup is called multple times
				OrdersViewController *ordersViewController = (OrdersViewController *)self;
				[ordersViewController refreshControlRequest];
			}
		}
		else {
			[self.navigationItem.rightBarButtonItem setTitle:[NSString stringWithFormat:@"Order as %@", name]];
		}
	}
}

- (void)quantityPickerDidChange:(QuantityPickerView *)sender atRow:(NSInteger)row {
	NSLog(@"%s - %d", __PRETTY_FUNCTION__, sender.quantity);
	
	
//	NSArray *customerList = [Customer findByAttribute:@"active" withValue:[NSNumber numberWithBool:YES] andOrderBy:@"firstname" ascending:YES];
	
	self.selectedCustomer = [sender.itemList objectAtIndex:row];//[customerList objectAtIndex:row];
	/*
	Customer *customer = [sender.itemList objectAtIndex:row];//[customerList objectAtIndex:row];
	
	[[AppDelegate appDelegate].sessionManager setupSessionWithCustomer:customer];
	
	[self updateLoggedCustomer];
	 */
}

- (NSString *)quantityPicker:(QuantityPickerView *)sender stringAtRow:(NSInteger)row {
	Customer *customer = [sender.itemList objectAtIndex:row];
	return [NSString stringWithFormat:@"%@ %@", customer.firstname, customer.lastname];
}

#pragma mark - Message

- (void)displayMessage:(NSString *)message andTitle:(NSString *)title {
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
	view.backgroundColor = [UIColor clearColor];
	
	UILabel *mainLabel = [[UILabel alloc] initWithFrame:view.bounds];
	
	mainLabel.textAlignment = NSTextAlignmentCenter;
//	mainLabel.textAlignment = NSTextAlignmentNatural;
	mainLabel.backgroundColor = [UIColor clearColor];
	mainLabel.font = [UIFont systemFontOfSize:15];
	mainLabel.textColor = [UIColor darkGrayColor];
	mainLabel.adjustsFontSizeToFitWidth = YES;
	mainLabel.minimumScaleFactor = 0.75;
	mainLabel.numberOfLines = 4;

	
	//INFO: setting message
	mainLabel.text = message;
	
	[view addSubview:mainLabel];
	
	//INFO: setting title
	HelperView *helperView = [[HelperView alloc] initWithTitle:title andView:view];
	
	[helperView addButtonWithTitle:@"OK"
							  type:HelperViewButtonTypeDefault
						   handler:^(HelperView *helperView) {
							   NSLog(@"Scan Product Button Clicked");
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

@end
