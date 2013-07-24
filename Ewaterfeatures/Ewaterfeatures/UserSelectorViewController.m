//
//  UserSelectorViewController.m
//  EWF
//
//  Created by Adrien Guffens on 7/23/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "UserSelectorViewController.h"
#import "UserCell.h"

#import "Customer+Manager.h"
#import "AccountViewController.h"
#import "AppDelegate.h"
#import "EwaterFeaturesAPI.h"

@interface UserSelectorViewController ()

@property (nonatomic, strong) NSMutableArray *userSelectorList;


@end

@implementation UserSelectorViewController

- (id)initWithStyle:(UITableViewStyle)style
{
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
	
	self.userSelectorList = [[NSMutableArray alloc] init];
	
	[EwaterFeaturesAPI customerListWithFirstName:self.selectedCustomer.firstname lastName:self.selectedCustomer.lastname company:self.selectedCustomer.company success:^(NSMutableDictionary *result) {
		
		Customer *customer = [Customer addUpdateCustomerWithDictionary:result];
		if (customer) {
			[self.userSelectorList addObject:customer];
			[self.tableView reloadData];
		}
		
	} failure:^(NSHTTPURLResponse *response, NSError *error) {
		
	}];
	self.userSelectorList = [[NSMutableArray alloc] init];
	
	//TODO: get the data for self.userSelectorList
	
	[self.userSelectorList addObject:@"Add new Customer !"];
	self.tableView.rowHeight = 44.0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.userSelectorList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UserCell";
    UserCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
	if ([[self.userSelectorList objectAtIndex:indexPath.row] isKindOfClass:[Customer class]]) {
		
		Customer *customer = [self.userSelectorList objectAtIndex:indexPath.row];
		
		cell.userNameLabel.text = [NSString stringWithFormat:@"%@ %@", customer.firstname, customer.lastname];
	}
	else {
		NSString *message = [self.userSelectorList objectAtIndex:indexPath.row];
		
		cell.userNameLabel.text = message;
	}
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	
	
	
	if ([[self.userSelectorList objectAtIndex:indexPath.row] isKindOfClass:[Customer class]]) {
		
		Customer *customer = [self.userSelectorList objectAtIndex:indexPath.row];
		//TODO:login as selected customer
		[[AppDelegate appDelegate].sessionManager setupSessionWithCustomer:customer];
		
		[self updateLoggedCustomer];
		[self dismissViewControllerAnimated:YES completion:nil];
	}
	else {
		NSString *message = [self.userSelectorList objectAtIndex:indexPath.row];
		//TODO: add new customer
		
		UIStoryboard *storyboard = [AppDelegate mainStoryBoard];
		
		AccountViewController *accountViewController  = (AccountViewController *)[storyboard instantiateViewControllerWithIdentifier:@"account"];
		accountViewController.isSignup = YES;
		
		
		
		[accountViewController setupAccountWithCustomer:self.selectedCustomer];
		
		UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:accountViewController];
		
		[self presentViewController:navigationController animated:YES completion:nil];		
	}

}

@end
