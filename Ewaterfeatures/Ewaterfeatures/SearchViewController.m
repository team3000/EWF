//
//  SearchViewController.m
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 5/2/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "SearchViewController.h"

#import "ProductDetailViewController.h"

#import "Product.h"
#import "Product+Manager.h"

#import "ProductCell.h"



#import "AFNetworking.h"
#import "QuantityPickerView.h"
#import "HelperView.h"

#import "AppDelegate.h"

@interface SearchViewController ()

@property (nonatomic, assign)NSInteger currentProductQuantity;
@property (nonatomic, strong)NSIndexPath *currentIndexPath;
@property (nonatomic, assign)BOOL searchBegin;

@end

@implementation SearchViewController

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
	
	self.searchBegin = NO;
	self.searchDisplayController.searchBar.showsScopeBar = NO;
	[self.searchDisplayController.searchBar sizeToFit];
	NSArray *productArray = [[NSArray alloc] initWithArray:[Product findByAttribute:@"active" withValue:@(YES) andOrderBy:@"date_upd" ascending:NO]];

	self.searchRecordList = [[NSMutableArray alloc] initWithArray:productArray];
	self.filteredSearchRecordList = [[NSMutableArray alloc] initWithArray:productArray];
	/*
	 self.searchRecordList = [[NSMutableArray alloc] init];
	 self.filteredSearchRecordList = [[NSMutableArray alloc] init];
	 
	 [self setup];
	 */
	[self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	self.searchTableView.rowHeight = 80.0;
}

- (void)setup {
	[super setup];
	//INFO: do additional stuff
	//[self performSelectorInBackground:@selector(updateProductList) withObject:nil];
}

- (void)updateProductList {
	
	
	[EwaterFeaturesAPI updateProducts:^(NSMutableDictionary *result) {
		if (result == nil)
			return;
		NSLog(@"%s | result = %@", __PRETTY_FUNCTION__, result);
		Product *product = [Product addUpdateProductWithDictionary:result];
		
		//WARNING: may be do it on main thread
		[self.tableView reloadData];
//		[self endRefreshControl:nil];
	} failure:^(NSHTTPURLResponse *response, NSError *error) {
//		[self endRefreshControl:nil];
	}];
}


- (void)awakeFromNib {
	[super awakeFromNib];
	self.tabBarItem = [[UCTabBarItem alloc] initWithTitle:@"Search"
											imageSelected:@"search"
											andUnselected:@"search"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
	if (tableView == self.searchDisplayController.searchResultsTableView) {
		return [self.filteredSearchRecordList count];
	} else {
		return [self.searchRecordList count];
	}
	return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 80.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	UIColor *color = [AppDelegate appDelegate].color;
	
    static NSString *CellIdentifier = @"ProductCell";
	
	//INFO: using self.tableView to get the cell
    ProductCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	[cell setDelegate:self];
	
	
	[cell setFirstStateIconName:@"mathematic-multiply2-icon-white"
					 firstColor:color
			secondStateIconName:@"Very-Basic-Info-icon"
					secondColor:color
				  thirdIconName:@"Ecommerce-Buy-icon"
					 thirdColor:color
				 fourthIconName:nil
					fourthColor:color
				   fithIconName:nil
					  fithColor:color];
	
	
	//INFO: basic stuff
	[cell.contentView setBackgroundColor:[UIColor whiteColor]];
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	
    // Configure the cell...
	Product *product;
	if (tableView == self.searchDisplayController.searchResultsTableView)
        product = [self.filteredSearchRecordList objectAtIndex:indexPath.row];
    else
		product = [self.searchRecordList objectAtIndex:indexPath.row];
	cell.nameLabel.text = product.name;
	
	cell.referenceLabel.text = product.reference;
	
	cell.priceLabel.text = [NSString stringWithFormat:@"$ %@", product.price];
	
	//if (cell.productImageView.image == nil) {
	
	NSMutableURLRequest *request = [EwaterFeaturesAPI defaultImageUrlRequestForProduct:product];
	[cell.productImageView setImageWithURL:[request URL] placeholderImage:[UIImage imageNamed:@"default-image"]];
	
	//}
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
	//	searchBar.showsScopeBar = YES;
	//	[searchBar sizeToFit];
	
	
	//self.searchRecordList =
	self.searchBegin = YES;
	[self.searchDisplayController setActive:YES animated:YES];
	[searchBar setShowsCancelButton:YES animated:YES];
	
	self.searchRecordList = [[NSMutableArray alloc] initWithArray:[Product findAll]];
	
	return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
	//TODO: maybe cancel current request
	//	searchBar.showsScopeBar = NO;
	//	[searchBar sizeToFit];
	[self.searchDisplayController setActive:NO animated:YES];
	//	self.searchDisplayController.searchBar.showsScopeBar = NO;
	//	[self.searchDisplayController.searchBar sizeToFit];
	
	//searchBar.text
	self.searchBegin = NO;
	self.searchRecordList = self.filteredSearchRecordList;
	[self.tableView reloadData];
	
	[searchBar setShowsCancelButton:NO animated:YES];
	
	return YES;
}

#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
	[self.filteredSearchRecordList removeAllObjects];
	
	NSLog(@"searchText: %@", searchText);
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@", searchText];
	
	NSArray *tempArray = [self.searchRecordList filteredArrayUsingPredicate:predicate];
	NSLog(@"%@", tempArray);
	self.filteredSearchRecordList = [NSMutableArray arrayWithArray:tempArray];
	
	[self.searchTableView reloadData];
	//	[self.tableView reloadData];
	
	NSLog(@"scope: %@", scope);
}

#pragma mark - UISearchDisplayController Delegate Methods
// searchDisplayController:didLoadSearchResultsTableView
- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView {
	self.searchTableView = tableView;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    //INFO: Tells the table data source to reload when text changes
	
	NSString *categoryName = [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]];
	NSLog(@"searchDisplayController 1 categoryName: %@", categoryName);
    [self filterContentForSearchText:searchString scope:categoryName];
    //INFO: Return YES to cause the search result table view to be reloaded.
    return NO;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    //INFO: Tells the table data source to reload when scope bar selection changes
	NSString *categoryName = [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption];
	NSLog(@"searchDisplayController 2 categoryName: %@", categoryName);
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:categoryName];
    //INFO: Return YES to cause the search result table view to be reloaded.
    return NO;
}


#pragma mark - segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"productDetailSegue"]) {
		
		ProductDetailViewController *productDetailViewController = [segue destinationViewController];
		if (self.searchBegin == YES)
			productDetailViewController.product = [self.filteredSearchRecordList objectAtIndex:self.currentIndexPath.row];
		else
			productDetailViewController.product = [self.searchRecordList objectAtIndex:self.currentIndexPath.row];
	}
}


//

- (void)addToCart {
	Product *product;
	
	if (self.searchBegin == YES)
		product = [self.filteredSearchRecordList objectAtIndex:self.currentIndexPath.row];
	else
		product = [self.searchRecordList objectAtIndex:self.currentIndexPath.row];
	
	product.is_in_cart = [NSNumber numberWithBool:YES];
	
	
	
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 300)];
	view.backgroundColor = [UIColor clearColor];
	
	QuantityPickerView *quantityPickerView = [[QuantityPickerView alloc] initWithFrame:CGRectMake(0, 0, 100, 300)];
	quantityPickerView.quantityPickerViewDelegate = self;
	quantityPickerView.quantity = [product.quantity integerValue] + 1;
	
	
	
	HelperView *helperView = [[HelperView alloc] initWithTitle:@"Select Quantity" andView:quantityPickerView];
	
	[helperView addButtonWithTitle:@"Cancel"
							  type:HelperViewButtonTypeCancel
						   handler:^(HelperView *helperView) {
							   NSLog(@"Cancel Clicked");
						   }];
	
	[helperView addButtonWithTitle:@"Validate"
							  type:HelperViewButtonTypeDefault
						   handler:^(HelperView *helperView) {
							   NSLog(@"Validate Button Clicked");
							   product.is_in_cart = [NSNumber numberWithBool:YES];
							   product.quantity = [NSNumber numberWithInteger:quantityPickerView.quantity];//[NSNumber numberWithInteger:self.currentProductQuantity];
							   [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];//NestedContexts];
							   [self updateBadgeCartValue];
							   
							   
						   }];
	
	
	helperView.willShowHandler = ^(HelperView *helperView) {
		NSLog(@"%@, willShowHandler", helperView);
	};
	helperView.didShowHandler = ^(HelperView *helperView) {
		NSLog(@"%@, didShowHandler", helperView);
		[quantityPickerView setSelectedRow:quantityPickerView.quantity - 1];
	};
	helperView.willDismissHandler = ^(HelperView *helperView) {
		NSLog(@"%@, willDismissHandler", helperView);
	};
	helperView.didDismissHandler = ^(HelperView *helperView) {
		NSLog(@"%@, didDismissHandler", helperView);
	};
	
	[helperView show];
	
	
	//	product.quantity = [NSNumber numberWithInt:[product.quantity intValue] + 1];
	
//	[[NSManagedObjectContext defaultContext] save:nil];
	[self updateBadgeCartValue];

}

#pragma mark - QuantityPickerViewDelegate

- (void)quantityPickerDidChange:(QuantityPickerView *)sender atRow:(NSInteger)row {
	NSLog(@"%s - %d", __PRETTY_FUNCTION__, sender.quantity);
	self.currentProductQuantity = sender.quantity;
}

#pragma mark - MCSwipeTableViewCellDelegate

- (void)swipeStickerTableViewCell:(ProductCell *)cell didTriggerButtonState:(MCSwipeTableViewButtonState)buttonState {
	NSLog(@"%s - %d", __PRETTY_FUNCTION__, buttonState);
	
	self.currentIndexPath = [self.tableView indexPathForCell:cell];
	
	NSLog(@"%s - %@", __PRETTY_FUNCTION__, self.currentIndexPath);
	
	switch (buttonState) {
		case MCSwipeTableViewButtonState1:
			break;
		case MCSwipeTableViewButtonState2://INFO: Detail
		{
			[cell bounceToOrigin];
			[self performSegueWithIdentifier:@"productDetailSegue" sender:self];
			
		}
			break;
		case MCSwipeTableViewButtonState3://INFO: Add to cart
		{
			[self addToCart];
			[cell bounceToOrigin];
			
		}
			break;
		case MCSwipeTableViewButtonState4://INFO:
		{
		}
			break;
		case MCSwipeTableViewButtonState5://INFO: nothing
			break;
			
		default:
			break;
	}
}

- (void)swipeStickerTableViewCell:(ProductCell *)cell didTriggerState:(MCSwipeTableViewCellState)state withMode:(MCSwipeTableViewCellMode)mode {
	NSLog(@"%s - %d - %d", __PRETTY_FUNCTION__, state, mode);
}



@end
