//
//  OrderDetailViewController.m
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 7/2/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderRow.h"
#import "OrderRowCell.h"

#import "Product.h"

#import "AFNetworking.h"
#import "EwaterFeaturesAPI.h"

@interface OrderDetailViewController ()

@property (nonatomic, strong) NSMutableArray *orderRowList;

@end

@implementation OrderDetailViewController

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
	
	self.orderRowList = [[NSMutableArray alloc] init];
	
	for (OrderRow *orderRow in self.order.orderRow) {
		OrderRow *x = orderRow;
		NSLog(@"%s | x: %@", __PRETTY_FUNCTION__, x);
		[self.orderRowList addObject:x];
	}
	
//	[self.tableView reloadData];
	
	NSLog(@"%s | self.orderRowList: %@", __PRETTY_FUNCTION__, self.orderRowList);
}

- (void)setup {
	[super setup];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 80.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.orderRowList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"OrderRowCell";
    OrderRowCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
	
    // Configure the cell...
	
	
	OrderRow *orderRow = [self.orderRowList objectAtIndex:indexPath.row];
//	orderRow.product.
	
	Product *product = orderRow.product;
	
	
	NSMutableURLRequest *request = [EwaterFeaturesAPI defaultImageUrlRequestForProduct:product];
	[cell.productImageView setImageWithURL:[request URL] placeholderImage:[UIImage imageNamed:@"default-image"]];

	
	cell.priceLabel.text = [NSString stringWithFormat:@"%@ x $ %@", orderRow.product_quantity, product.price];
	//[cell.priceLabel setText:[NSString stringWithFormat:@"%@ x $ 749.99", product.quantity]];
	
	cell.referenceLabel.text = product.reference;
	
	cell.nameLabel.text = product.name;
	
	
	
	//	NSString *imageUrlString = [NSString stringWithFormat:@"images/products/%@/%@", product.product_id, product.id_default_image];
	//	NSMutableURLRequest *request = [SessionManager requestForRoute:imageUrlString];
	//	NSLog(@"%s | %@", __PRETTY_FUNCTION__, [request description]);
	
	//	if (cell.imageView.image == nil) {
	/*
	NSMutableURLRequest *request = [EwaterFeaturesAPI defaultImageUrlRequestForProduct:product];
	[cell.productImageView setImageWithURL:[request URL] placeholderImage:[UIImage imageNamed:@"default-image"]];
	*/
	//	}
	//INFO: basic stuff
	[cell.contentView setBackgroundColor:[UIColor whiteColor]];
	

    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	/*
    if ([[segue identifier] isEqualToString:@"productDetailSegue"]) {
		
		ProductDetailViewController *productDetailViewController = [segue destinationViewController];
		productDetailViewController.product = [self.productList objectAtIndex:self.currentIndexPath.row];
	}
	 */
}



@end
