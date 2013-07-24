//
//  BaseTableViewController.h
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 5/30/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "QuantityPickerView.h"

@interface BaseTableViewController : UITableViewController <QuantityPickerViewDelegate>

@property (nonatomic, assign)UserType userType;

- (void)setup;
- (void)updateBadgeCartValue;
- (void)updateLoggedCustomer;

//INFO: Helper
- (void)displayMessage:(NSString *)message andTitle:(NSString *)title;

@end
