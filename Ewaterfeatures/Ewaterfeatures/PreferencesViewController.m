//
//  PreferencesViewController.m
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 5/2/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "PreferencesViewController.h"
#import "Cart+Manager.h"
#import "AppDelegate.h"

@interface PreferencesViewController ()

@end

@implementation PreferencesViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)setup {
	[super setup];
	//INFO: do additional stuff
	
	[self.logoutButton setColor:[UIColor colorWithRed:162/255.0 green:36.0/255.0 blue:60.0/255.0 alpha:1.0]];
}

- (void)awakeFromNib {
	[super awakeFromNib];

	self.tabBarItem = [[UCTabBarItem alloc] initWithTitle:@"My Space"
											imageSelected:@"my_space"
											andUnselected:@"my_space"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)handleLogoutButton:(id)sender {
	NSLog(@"%s | BOOM", __PRETTY_FUNCTION__);
	
	[Cart clearCart];
	[[AppDelegate appDelegate].sessionManager logout];
	
}

@end
