//
//  PaymentViewController.m
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 6/21/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "PaymentViewController.h"

#import "EndOrderViewController.h"

#import "Order.h"
#import "Order+Manager.h"

#import "Cart.h"
#import "Cart+Manager.h"

#import "Product+Manager.h"

#import "Address.h"

#import "CartRow.h"

#import "OrderRow.h"

#import "EwaterFeaturesAPI.h"

@interface PaymentViewController ()

@property (nonatomic, strong)Order *order;

@end

@implementation PaymentViewController

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)setup {
	[super setup];
	self.title = @"Payment Methods";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//	[super tableView:tableView didSelectRowAtIndexPath:indexPath];
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	NSLog(@"%s | cart: %@", __PRETTY_FUNCTION__, self.cart);
/*	if (indexPath.row == 1123) {

		[self performSegueWithIdentifier:@"endOrderSegue" sender:self];
	}
	else */

		
		Order *order = [Order createEntity];
		order.id_address_delivery = self.cart.addressDelivery.id_address;
		order.id_address_invoice = self.cart.addressInvoice.id_address;
		order.id_currency = [NSNumber numberWithInt:1];
		order.id_cart = self.cart.id_cart;
		order.id_carrier = self.cart.id_carrier;//INFO: set to 7 by default
		order.id_currency = self.cart.id_currency;//INFO: set to X by default
		order.id_shop = self.cart.id_shop;//INFO: set to 1 by default
		order.id_shop_group = self.cart.id_shop_group;//INFO: set to 1 by default
		
		
		order.id_lang = [NSNumber numberWithInt:1];
		order.id_customer = self.cart.id_customer;
		order.id_carrier = self.cart.id_carrier;
		order.current_state = [NSNumber numberWithInt:1];

		order.secure_key = self.cart.secure_key;

		//TODO: calculate the price
		
		order.total_paid = [NSNumber numberWithDouble:[[Cart cartPrice] intValue] + 11.0];//@([[Cart cartPrice] doubleValue] + 11.0);

		order.total_paid_real = [Cart cartPrice];
		order.total_products = [Cart cartPrice];//@([[Cart cartPrice] doubleValue] + 11.0);//[Cart cartPrice];// --> CALCULATE the prix hors tax
		order.total_products_wt = [Cart cartPrice];
		order.conversion_rate = [NSNumber numberWithDouble:1.0];
		
		for (CartRow *cartRow in self.cart.cartRow) {
			NSNumber *id_product = cartRow.id_product;
			NSNumber *id_product_attribute = cartRow.id_product_attribute;
			NSNumber *quantity = cartRow.quantity;
			NSString *product_name = [Product productWithId:[id_product intValue]].name;
			NSNumber *product_price = cartRow.product.price;
			
			OrderRow *orderRow = [OrderRow createEntity];
			
			orderRow.product_id = id_product;
			orderRow.product_attribute_id = id_product_attribute;
			orderRow.product_quantity = quantity;
			orderRow.product_name = product_name;
			orderRow.product_price = product_price;
			
			[order addOrderRowObject:orderRow];
		}
		//INFO: module selection
		
		if (indexPath.row == 0) {
			order.module = @"paypal";
			order.payment = @"Paypal";
		}
		else if (indexPath.row == 1) {
			order.module = @"cheque";
			order.payment = @"Payment by check";
		}
		else if (indexPath.row == 2) {
			order.module = @"bankwire";
			order.payment = @"Bank Wire";
		}

		[EwaterFeaturesAPI sendOrder:order success:^(NSMutableDictionary *result) {
			NSLog(@"%s | Success send Order: %@", __PRETTY_FUNCTION__, result);
			[order deleteEntity];
			self.order = [Order addUpdateOrderWhithDictionary:result];
			NSLog(@"%s | order: %@", __PRETTY_FUNCTION__, [order description]);
			
			[self performSegueWithIdentifier:@"endOrderSegue" sender:self];
			
		} failure:^(NSHTTPURLResponse *response, NSError *error) {
			NSLog(@"%s | Fail send Order", __PRETTY_FUNCTION__);
			[order deleteEntity];
			NSString *message = [[error.userInfo objectForKey:@"prestashop:errors:error:message"] lastObject];
			if (message == nil) {
				message = [error description];
			}
		}];

}


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"endOrderSegue"]) {
		EndOrderViewController *endOrderViewController = (EndOrderViewController *)[segue destinationViewController];
		endOrderViewController.order = self.order;
	}
}

 

@end
