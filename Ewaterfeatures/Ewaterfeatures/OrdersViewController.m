//
//  OrdersViewController.m
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 6/13/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "OrdersViewController.h"
#import "OrderCell.h"

#import "Order+Manager.h"
#import "Order.h"

#import "Customer.h"
#import "Customer+Manager.h"

#import "OrderState.h"

#import "OrderRow+Manager.h"

#import "OrderDetailViewController.h"

#import "ConventionTools.h"

#import "AppDelegate.h"

@interface OrdersViewController ()

@property (nonatomic, strong)NSMutableArray *orderList;
@property (nonatomic, strong)Order *selectedOrder;
@end

@implementation OrdersViewController

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
	
	self.title = @"Orders";
	
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)setup {
	[super setup];
	//INFO: do additional stuff
	
	//INFO: setting up refreshControl
	self.refreshControl = [[UIRefreshControl alloc] init];
	[self.refreshControl addTarget:self action:@selector(refreshControlRequest)
				  forControlEvents:UIControlEventValueChanged];
	
	Customer *customer = [AppDelegate appDelegate].sessionManager.session.customer;
	self.orderList = [[NSMutableArray alloc] initWithArray:[Order findByAttribute:@"id_customer" withValue:customer.id_customer andOrderBy:@"date_upd" ascending:NO]];
//	[self.tableView reloadData];
	
	/*
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.valid == %@", @(YES)];
	
	NSArray *tempArray = [self.orderList filteredArrayUsingPredicate:predicate];
	NSLog(@"%@", tempArray);
*/
 //	[self.orderList removeAllObjects];
//	self.orderList = [NSMutableArray arrayWithArray:tempArray];

//	if ([self.orderList count] == 0) {
		[EwaterFeaturesAPI updateOrders:^(NSMutableDictionary *result) {
			Order *order = [Order addUpdateOrderWhithDictionary:result];
			if (order != nil) {
				if (![self.orderList containsObject:order]) {
//					[self.orderList insertObject:order atIndex:0];//addObject:order];
					self.orderList = [[NSMutableArray alloc] initWithArray:[Order findByAttribute:@"id_customer" withValue:customer.id_customer andOrderBy:@"date_upd" ascending:NO]];
					[self.tableView reloadData];
				}
			}
		} failure:^(NSHTTPURLResponse *response, NSError *error) {
			
		}];
//	}
	
	//	[self updateProductList];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.orderList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"OrderCell";
    OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
	Order *order = [self.orderList objectAtIndex:indexPath.row];
	
	cell.referenceLabel.text = order.reference;
	cell.totalPaidLabel.text = [NSString stringWithFormat:@"$ %.02f", [order.total_paid doubleValue]];
#warning TODO orderStateLabel
	cell.orderStateLabel.text = order.orderState.name;//@"Shipped";
	cell.dateAddedLadel.text = [ConventionTools getStringDate:order.date_add withFormat:@"yyyy-MM-dd"];
	
	[cell.contentView setBackgroundColor:[UIColor whiteColor]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Order *order = [self.orderList objectAtIndex:indexPath.row];
	
	NSLog(@"%s | order: %@", __PRETTY_FUNCTION__, order);
	for (OrderRow *orderRow in order.orderRow) {
		NSLog(@"%s | orderRow: %@", __PRETTY_FUNCTION__, orderRow);
		NSLog(@"%s | orderRow.product_name: %@", __PRETTY_FUNCTION__, orderRow.product_name);
		NSLog(@"%s | orderRow.product_id: %@", __PRETTY_FUNCTION__, orderRow.product_id);
		NSLog(@"%s | orderRow.product_attribute_id: %@", __PRETTY_FUNCTION__, orderRow.product_attribute_id);
	}
	
	
	self.selectedOrder = order;
	[self performSegueWithIdentifier:@"orderDetailSegue" sender:self];
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	
	 if ([[segue identifier] isEqualToString:@"orderDetailSegue"]) {
	 
		 OrderDetailViewController *orderDetailViewController = [segue destinationViewController];
		 orderDetailViewController.order = self.selectedOrder;//[self.orderList objectAtIndex:self.currentIndexPath.row];
	 }
	 
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 80;
}

//

- (void)refreshControlRequest
{
	NSLog(@"%s | refreshing...", __PRETTY_FUNCTION__);
	
	[self.orderList removeAllObjects];
	
	Customer *customer = [AppDelegate appDelegate].sessionManager.session.customer;
	self.orderList = [[NSMutableArray alloc] initWithArray:[Order findByAttribute:@"id_customer" withValue:customer.id_customer andOrderBy:@"date_upd" ascending:NO]];
	[self.tableView reloadData];
	[self.refreshControl endRefreshing];
	
//	if ([self.orderList count] == 0) {
		[EwaterFeaturesAPI updateOrders:^(NSMutableDictionary *result) {
			Order *order = [Order addUpdateOrderWhithDictionary:result];
			if (order != nil) {
				if (![self.orderList containsObject:order]) {
					self.orderList = [[NSMutableArray alloc] initWithArray:[Order findByAttribute:@"id_customer" withValue:customer.id_customer andOrderBy:@"date_upd" ascending:NO]];
//					[self.orderList insertObject:order atIndex:0];//addObject:order];
					[self.tableView reloadData];
//					[self.refreshControl endRefreshing];
				}
			}
		} failure:^(NSHTTPURLResponse *response, NSError *error) {
			
		}];
//	}
//	else {
//		[self.tableView reloadData];
//		[self.refreshControl endRefreshing];
//	}
}


@end
