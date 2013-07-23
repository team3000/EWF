//
//  OrderDetailViewController.h
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 7/2/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "BaseTableViewController.h"
#import "Order.h"

@interface OrderDetailViewController : BaseTableViewController

@property (nonatomic, strong)Order *order;

@end
