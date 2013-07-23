//
//  EndOrderViewController.m
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 6/21/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "EndOrderViewController.h"
#import "Cart+Manager.h"

#import "Order+Manager.h"

#import "Customer.h"

#import "AppDelegate.h"


#define kPayPalClientId @"sales_api1.ewaterfeatures.com.au"
#define kPayPalReceiverEmail @"sales@ewaterfeatures.com.au"

@interface EndOrderViewController ()

@end

@implementation EndOrderViewController

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
	
	[Cart clearCart];
	self.title = @"Validation";
	
	
	[self.backButton setType:BButtonTypeDefault];
	[self.backButton setColor:[AppDelegate appDelegate].color];

	
	if ([self.order.module isEqualToString:@"paypal"]) {
		self.successView.hidden = YES;
		self.acceptCreditCards = YES;
//		self.environment = PayPalEnvironmentNoNetwork;
	}
	else if ([self.order.module isEqualToString:@"check"]) {
	}
	else if ([self.order.module isEqualToString:@"paypal"]) {
	}
	
}

- (void)setup {
	[super setup];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	//INFO: only for US
	BOOL enable = NO;
	if ([self.order.module isEqualToString:@"paypal"] && enable) {
		/*
		[PayPalPaymentViewController setEnvironment:self.environment];
		[PayPalPaymentViewController prepareForPaymentUsingClientId:kPayPalClientId];
		 */
	}
	
	
	//TODO: update the order to get the good price
	
	[EwaterFeaturesAPI updateOrderWithId:[self.order.id_order stringValue] success:^(NSMutableDictionary *result) {
		NSLog(@"%s | Success update Order: %@", __PRETTY_FUNCTION__, result);
		Order *order = [Order addUpdateOrderWhithDictionary:result];
		NSLog(@"%s | order: %@", __PRETTY_FUNCTION__, order);
		
		self.totalProductTaxInclLabel.text = [NSString stringWithFormat:@"$ %0.2f", [self.order.total_products_wt doubleValue]];
		self.shippingCostLabel.text = [NSString stringWithFormat:@"$ %0.2f", [self.order.total_shipping doubleValue]];
		self.totalShippingTaxInclLabel.text = [NSString stringWithFormat:@"$ %0.2f", [self.order.total_paid_tax_incl doubleValue]];
		
	} failure:^(NSHTTPURLResponse *response, NSError *error) {
		NSLog(@"%s | Fail update Order", __PRETTY_FUNCTION__);
	}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonHandler:(id)sender {
	[self.navigationController popToRootViewControllerAnimated:YES];
	//	[self performSegueWithIdentifier:@"backSegue" sender:self];
}

#pragma mark - PayPalPaymentDelegate
/*
- (IBAction)pay {
	
	self.completedPayment = nil;
	
	PayPalPayment *payment = [[PayPalPayment alloc] init];
	NSString *amountString = [NSString stringWithFormat:@"%0.2f", [self.order.total_paid doubleValue]];
	payment.amount = [[NSDecimalNumber alloc] initWithString:amountString];
	payment.currencyCode = @"USD";
	payment.shortDescription = self.order.reference;
	
	if (!payment.processable) {
		// This particular payment will always be processable. If, for
		// example, the amount was negative or the shortDescription was
		// empty, this payment wouldn't be processable, and you'd want
		// to handle that here.
		[self displayMessage:@"Error payment" andTitle:@"If this error appears again, leave us an email or contact us."];
		return;
	}
	
	// Any customer identifier that you have will work here. Do NOT use a device- or
	// hardware-based identifier.
	NSString *customerId = [NSString stringWithFormat:@"%@", self.order.id_customer];
	
	// Set the environment:
	// - For live charges, use PayPalEnvironmentProduction (default).
	// - To use the PayPal sandbox, use PayPalEnvironmentSandbox.
	// - For testing, use PayPalEnvironmentNoNetwork.
	[PayPalPaymentViewController setEnvironment:self.environment];
	
	PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithClientId:kPayPalClientId
																								 receiverEmail:kPayPalReceiverEmail
																									   payerId:customerId
																									   payment:payment
																									  delegate:self];
	paymentViewController.hideCreditCardButton = !self.acceptCreditCards;
	
	[self presentViewController:paymentViewController animated:YES completion:nil];
}
*/
/*
#pragma mark - Proof of payment validation

- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment {
	// TODO: Send completedPayment.confirmation to server
	NSLog(@"Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", completedPayment.confirmation);
}

#pragma mark - PayPalPaymentDelegate methods

- (void)payPalPaymentDidComplete:(PayPalPayment *)completedPayment {
	NSLog(@"PayPal Payment Success!");
	self.completedPayment = completedPayment;
	self.successView.hidden = NO;
	
	[self sendCompletedPaymentToServer:completedPayment]; // Payment was processed successfully; send to server for verification and fulfillment
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel {
	NSLog(@"PayPal Payment Canceled");
	self.completedPayment = nil;
	self.successView.hidden = YES;
	[self dismissViewControllerAnimated:YES completion:nil];
}
*/
#pragma mark - Flipside View Controller
/*
 - (void)flipsideViewControllerDidFinish:(ZZFlipsideViewController *)controller {
 if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
 [self dismissViewControllerAnimated:YES completion:nil];
 } else {
 [self.flipsidePopoverController dismissPopoverAnimated:YES];
 self.flipsidePopoverController = nil;
 }
 }
 
 - (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
 self.flipsidePopoverController = nil;
 }
 
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 if ([[segue identifier] isEqualToString:@"showAlternate"]) {
 [[segue destinationViewController] setDelegate:self];
 
 if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
 UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
 self.flipsidePopoverController = popoverController;
 popoverController.delegate = self;
 }
 }
 }
 
 - (IBAction)togglePopover:(id)sender {
 if (self.flipsidePopoverController) {
 [self.flipsidePopoverController dismissPopoverAnimated:YES];
 self.flipsidePopoverController = nil;
 } else {
 [self performSegueWithIdentifier:@"showAlternate" sender:sender];
 }
 }
 */

@end
