//
//  AddressViewController.h
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 6/21/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
#import "UCAddress.h"
#import "CustomCell.h"
#import "Cart.h"
#import "BButton.h"

#import "QuantityPickerView.h"
#import "QuantityPickerViewDelegate.h"

@interface AddressViewController : BaseTableViewController <QuantityPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *mainLabel;
@property (strong, nonatomic) IBOutlet UCAddress *deliveryAddress;
@property (strong, nonatomic) IBOutlet UISwitch *sameAddressSwitch;
@property (strong, nonatomic) IBOutlet UCAddress *billingAddress;

@property (strong, nonatomic) IBOutlet UIButton *deliveryAddressSelectorButton;
@property (strong, nonatomic) IBOutlet UIButton *billingAddressSelectorButton;

@property (strong, nonatomic) IBOutlet CustomCell *billingAddressCell;

- (IBAction)sameAddressSwitchChanged:(id)sender;
- (IBAction)handleNextButton:(id)sender;

- (IBAction)handleDeliveryAdressSelector:(id)sender;
- (IBAction)handleBillingAddressSelector:(id)sender;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *nextActivityIndicator;
@property (strong, nonatomic) IBOutlet BButton *nextButton;

@property (nonatomic, strong)Cart *cart;

@end
