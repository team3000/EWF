//
//  ProductsViewController.m
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 5/2/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "ProductsViewController.h"
#import "ProductDetailViewController.h"
//#import "Product.h"
#import "Product+Manager.h"
#import "ProductCell.h"

#import "HelperView.h"

#import "AFNetworking.h"
#import "EwaterFeaturesAPI.h"
#import "AppDelegate.h"


//date_upd

@interface ProductsViewController ()

@property (nonatomic, assign)NSInteger currentProductQuantity;

@property (nonatomic, strong)NSIndexPath *currentIndexPath;

@property (nonatomic, strong) NSString *tmpInnerTagText;
@property (nonatomic, strong) NSMutableDictionary *productDictionary;
@property (nonatomic, strong) NSString *tmpKeyString;

@property (nonatomic, strong) UIImage *defaultImage;

@property (nonatomic, strong) NSMutableDictionary *imageCacheDictionary;

@end

@implementation ProductsViewController

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

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	self.tableView.rowHeight = 80.0;
}

- (void)awakeFromNib {
	[super awakeFromNib];
	
	self.tabBarItem = [[UCTabBarItem alloc] initWithTitle:@"Products"
											imageSelected:@"product"
											andUnselected:@"product"];
	self.categoryFilterId = nil;
}

- (void)setup {
	[super setup];
	//INFO: do additional stuff
	
	self.defaultImage = [UIImage imageNamed:@"default-image"];
	self.imageCacheDictionary = [[NSMutableDictionary alloc] init];
	
	//INFO: setting up refreshControl
	self.refreshControl = [[UIRefreshControl alloc] init];
	[self.refreshControl addTarget:self action:@selector(refreshControlRequest)
				  forControlEvents:UIControlEventValueChanged];
	
	if (self.categoryFilterId == nil)
		self.productList = [[NSMutableArray alloc] initWithArray:[Product findByAttribute:@"active" withValue:@(YES) andOrderBy:@"date_upd" ascending:NO]];
	else {
		self.productList = [[NSMutableArray alloc] initWithArray:[Product findByAttribute:@"id_category_default" withValue:self.categoryFilterId andOrderBy:@"date_upd" ascending:NO]];
	}
	
	//	[self updateProductList];
	//[self performSelectorInBackground:@selector(updateProductList) withObject:nil];
}

- (void)updateProductList {
	
	
	[EwaterFeaturesAPI updateProducts:^(NSMutableDictionary *result) {
		if (result == nil)
			return;
		NSLog(@"%s | result = %@", __PRETTY_FUNCTION__, result);
		Product *product = [Product addUpdateProductWithDictionary:result];
		product = nil;
		if ([[AppDelegate appDelegate].ewaterFeaturesAPI.numberOfCurrentResquest isEqualToNumber:@(0)]) {
			//WARNING: may be do it on main thread
			[self.tableView reloadData];
			[self endRefreshControl:nil];
		}
	} failure:^(NSHTTPURLResponse *response, NSError *error) {
		if ([[AppDelegate appDelegate].ewaterFeaturesAPI.numberOfCurrentResquest isEqualToNumber:@(0)]) {
			[self endRefreshControl:nil];
		}
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
    return [self.productList count];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//	return 80;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ProductCell";
    ProductCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
	
	[cell setDelegate:self];
	
	UIColor *color = [AppDelegate appDelegate].color;
	
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
	Product *product = [self.productList objectAtIndex:indexPath.row];
	
	//	NSLog(@"%s | product: %@", __PRETTY_FUNCTION__, product);
	
	cell.nameLabel.text = product.name;
	
	cell.referenceLabel.text = product.reference;
	
	cell.priceLabel.text = [NSString stringWithFormat:@"$ %@", product.price];
	
	//if (cell.productImageView.image == nil) {
	
	//	[cell.productImageView setImageWithURL:[request URL] placeholderImage:self.defaultImage];
	
	//	[self.activityIndicator setHidden:NO];
	//	[self.activityIndicator startAnimating];
	
	/*
	UIImage *savProductImage = [self.imageCacheDictionary objectForKey:indexPath];
	
	if (savProductImage == nil) {
		UIImageView *savImageView = cell.productImageView;
		
		NSMutableURLRequest *request = [EwaterFeaturesAPI defaultImageUrlRequestForProduct:product];
		
		[cell.productImageView setImageWithURLRequest:request placeholderImage:self.defaultImage
											  success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
												  //		 [self.activityIndicator setHidden:YES];
												  //		 [self.activityIndicator stopAnimating];
												  [self.imageCacheDictionary setObject:image forKey:indexPath];
												  savImageView.image = image;
											  } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
												  //		 [self.activityIndicator setHidden:YES];
												  //		 [self.activityIndicator stopAnimating];
											  }];
	}
	else {
		cell.productImageView.image = savProductImage;
	}
	*/
	//}
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"productDetailSegue"]) {
		
		ProductDetailViewController *productDetailViewController = [segue destinationViewController];
		productDetailViewController.product = [self.productList objectAtIndex:self.currentIndexPath.row];
	}
}

- (void)addToCart {
	
	Product *product = [self.productList objectAtIndex:self.currentIndexPath.row];
	
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
	
	//	[[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
	[self updateBadgeCartValue];
}

#pragma mark - QuantityPickerViewDelegate

- (void)quantityPickerDidChange:(QuantityPickerView *)sender atRow:(NSInteger)row {
	NSLog(@"%s - %d", __PRETTY_FUNCTION__, sender.quantity);
	self.currentProductQuantity = sender.quantity;
}

#pragma mark - Refresh Control

- (void)refreshControlRequest
{
	NSLog(@"%s | refreshing...", __PRETTY_FUNCTION__);
	[self updateProductList];
	[self performSelectorInBackground:@selector(updateProductList) withObject:nil];
}

- (void)endRefreshControl:(NSTimer *)timer {
	[self.refreshControl endRefreshing];
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
