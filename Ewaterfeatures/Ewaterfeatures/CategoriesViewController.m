//
//  CategoriesViewController.m
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 6/14/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "CategoriesViewController.h"
#import "CategoryCell.h"
#import "Category+Manager.h"

#import "ProductsViewController.h"
#import "Product.h"
#import "Product+Manager.h"

#import "EwaterFeaturesAPI.h"

#import "AppDelegate.h"

@interface CategoriesViewController ()

@property (nonatomic, strong) NSMutableArray *categoryList;

@end

@implementation CategoriesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	self.tableView.rowHeight = 80.0;
}

- (void)setup {
	[super setup];
	
	self.title = @"Categories";
	
	self.tabBarItem = [[UCTabBarItem alloc] initWithTitle:@"Categories"
											imageSelected:@"product"
											andUnselected:@"product"];

	
	//INFO: do additional stuff
	
	//INFO: setting up refreshControl
	self.refreshControl = [[UIRefreshControl alloc] init];
	[self.refreshControl addTarget:self action:@selector(refreshControlRequest)
				  forControlEvents:UIControlEventValueChanged];
//	/*
	Category *category = [Category categoryWithId:-1];
	category.name = @"All";
	category.nb_products_recursive = [NSNumber numberWithInt:[Product quantityOfProducts]];
	category.id_parent = [NSNumber numberWithInt:2];

//*/
	[[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];//:nil];
	
	self.categoryList = [[NSMutableArray alloc] init];//WithObjects:category, nil];
	[self.categoryList addObjectsFromArray:[Category findByAttribute:@"id_parent" withValue:[NSNumber numberWithInt:2] andOrderBy:@"id_category" ascending:YES]];//findAllSortedBy:@"id_category" ascending:YES]];
	//	[self updateProductList];
//	[self performSelectorInBackground:@selector(updateCategoryList) withObject:nil];
	
	//
	[self update];
}

- (void)update {
//	if ([config.db_base_is_configured isEqualToNumber:@(NO)]) {
	{
		[self.view addSubview:self.waitingView];
		[EwaterFeaturesAPI updateForCustomer:^{
			[self.view addSubview:self.waitingView];
			//		self.waitingView.alpha = 1;
			[UIView animateWithDuration:0.3
							 animations:^{
								 self.waitingView.alpha = 0;
							 }
							 completion:^(BOOL finished) {
								 Category *category = [Category categoryWithId:-1];
								 category.name = @"All";
								 category.nb_products_recursive = [NSNumber numberWithInt:[Product quantityOfProducts]];
								 category.id_parent = [NSNumber numberWithInt:2];
								 
								 [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
								 
								 [self.waitingView removeFromSuperview];

								 [self.categoryList removeAllObjects];
								 [self.categoryList addObjectsFromArray:[Category findByAttribute:@"id_parent" withValue:[NSNumber numberWithInt:2] andOrderBy:@"id_category" ascending:YES]];
								 [self.tableView reloadData];
							 }];
		}];
	}
}

- (void)updateCategoryList {
	
	Category *category = [Category categoryWithId:-1];
	category.name = @"All";
	category.nb_products_recursive = [NSNumber numberWithInt:[Product quantityOfProducts]];
	category.id_parent = [NSNumber numberWithInt:2];
	
	[[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];

	//
	
	[EwaterFeaturesAPI updateCategories:^(NSMutableDictionary *result) {
		Category *category = [Category addUpdateCategoryWithDictionary:result];
		[self.categoryList removeAllObjects];
		[self.categoryList addObjectsFromArray:[Category findByAttribute:@"id_parent" withValue:[NSNumber numberWithInt:2] andOrderBy:@"id_category" ascending:YES]];//findAllSortedBy:@"id_category"
		
		Category *allCategory = [Category categoryWithId:-1];
		allCategory.nb_products_recursive = [NSNumber numberWithInt:[Product quantityOfProducts]];
		[[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];//:nil];
		/*
		 if ([self.productList containsObject:product] == NO) {
		 [self.productList addObject:product];
		 [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[self.productList count] inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
		 }
		 else {
		 //[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[self.productList count] inSection:0]] withRowAnimation:UITableViewRowAnimationMiddle];
		 [self.tableView reloadData];
		 }
		 */
		//WARNING: may be do it on main thread
		[self.tableView reloadData];
		[self endRefreshControl:nil];
	} failure:^(NSHTTPURLResponse *response, NSError *error) {
		[self endRefreshControl:nil];
	}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.categoryList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CategoryCell";
    CategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
	
	
	//INFO: basic stuff
	[cell.contentView setBackgroundColor:[UIColor whiteColor]];
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	
    // Configure the cell...
	Category *category = [self.categoryList objectAtIndex:indexPath.row];
	cell.nameLabel.text = category.name;
	cell.quantityProducts.text = [NSString stringWithFormat:@"%@", category.nb_products_recursive];
	
	/*
	cell.referenceLabel.text = product.reference;
	
	cell.priceLabel.text = [NSString stringWithFormat:@"$ %@", product.price];
	
	//if (cell.imageView.image == nil) {
	
	NSMutableURLRequest *request = [EwaterFeaturesAPI defaultImageUrlRequestForProduct:product];
	[cell.productImageView setImageWithURL:[request URL] placeholderImage:[UIImage imageNamed:@"ewf39995"]];
	*/
	//}
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

	UIStoryboard *storyboard = [AppDelegate mainStoryBoard];
	ProductsViewController *productsViewController  = (ProductsViewController *)[storyboard instantiateViewControllerWithIdentifier:@"products"];
		//TODO: set the category to display

	Category *category = [self.categoryList objectAtIndex:indexPath.row];
	//INFO: fix All category
	if ([category.id_category isEqual:[NSNumber numberWithInt:-1]]) {
		productsViewController.categoryFilterId = nil;
	}
	else {
		productsViewController.categoryFilterId = category.id_category;
	}
	[self.navigationController pushViewController:productsViewController animated:YES];
}

#pragma mark - Refresh Control

- (void)refreshControlRequest
{
	NSLog(@"%s | refreshing...", __PRETTY_FUNCTION__);
	[self updateCategoryList];
}

- (void)endRefreshControl:(NSTimer *)timer {
	[self.refreshControl endRefreshing];
}


@end
