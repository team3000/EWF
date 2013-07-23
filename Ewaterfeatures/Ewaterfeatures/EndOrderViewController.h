//
//  EndOrderViewController.h
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 6/21/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
#import "Order.h"
#import "BButton.h"
//#import "PayPalMobile.h"

@interface EndOrderViewController : BaseTableViewController //<PayPalPaymentDelegate>

@property(nonatomic, strong, readwrite) UIPopoverController *flipsidePopoverController;

@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;
//@property(nonatomic, strong, readwrite) PayPalPayment *completedPayment;

//
@property (nonatomic, strong)Order *order;
//

@property (strong, nonatomic) IBOutlet UILabel *totalProductTaxInclLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalShippingTaxInclLabel;
@property (strong, nonatomic) IBOutlet UILabel *shippingCostLabel;


@property (strong, nonatomic) IBOutlet UIView *successView;
@property (strong, nonatomic) IBOutlet BButton *payButton;


@property (strong, nonatomic) IBOutlet BButton *backButton;

- (IBAction)backButtonHandler:(id)sender;

@end
