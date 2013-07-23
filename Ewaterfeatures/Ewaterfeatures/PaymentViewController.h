//
//  PaymentViewController.h
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 6/21/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
#import "Cart.h"

@interface PaymentViewController : BaseTableViewController

@property (nonatomic, strong)Cart *cart;

@end
