//
//  PreferencesViewController.h
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 5/2/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BButton.h"

#import "BaseTableViewController.h"

@interface PreferencesViewController : BaseTableViewController

@property (strong, nonatomic) IBOutlet BButton *logoutButton;

- (IBAction)handleLogoutButton:(id)sender;

@end
