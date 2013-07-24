//
//  UserSelectorViewController.h
//  EWF
//
//  Created by Adrien Guffens on 7/23/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"

@class Customer;

@interface UserSelectorViewController : BaseTableViewController

@property (nonatomic, strong) Customer *selectedCustomer;

@end
