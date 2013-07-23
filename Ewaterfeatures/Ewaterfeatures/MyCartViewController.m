//
//  MyCartViewController.m
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 5/2/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "MyCartViewController.h"
#import "ProductDetailViewController.h"
#import "Product.h"

#import "Cart+Manager.h"

#import "HelperView.h"
#import "QuantityPickerView.h"

#import "AFNetworking.h"
#import "EwaterFeaturesAPI.h"

#import "AppDelegate.h"

@interface MyCartViewController ()

@property (nonatomic, strong)NSIndexPath *currentIndexPath;
@property (nonatomic, assign)NSInteger currentProductQuantity;

@property (nonatomic, strong) NSString *tmpInnerTagText;
@property (nonatomic, strong) NSMutableDictionary *productDictionary;
@property (nonatomic, strong) NSString *tmpKeyString;


@end

@implementation MyCartViewController

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
	
	UIBarButtonItem *orderButton = [[UIBarButtonItem alloc] initWithTitle:@"Order" style:UIBarButtonItemStylePlain target:self action:@selector(handleOrder:)];
	self.navigationItem.rightBarButtonItem = orderButton;
	
	

	UIBarButtonItem *leftTotalPriceButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
	self.navigationItem.leftBarButtonItem = leftTotalPriceButton;

	
//	self.navigationItem.leftBarButtonItem.title = @"$$";
	[self updateCartPrice];

}

- (void)updateCartPrice {
	NSNumber *cartPriceNumber = [Cart cartPrice];
	NSString *cartPrice = [NSString stringWithFormat:@"$ %.2f", [cartPriceNumber doubleValue]];
	[self.navigationItem.leftBarButtonItem setTitle:cartPrice];
	
	if ([cartPriceNumber intValue] == 0) {
		self.navigationItem.rightBarButtonItem.enabled = NO;
	}
	else {
		self.navigationItem.rightBarButtonItem.enabled = YES;
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	//INFO: reload cells
	[self setup];
	[self.tableView reloadData];
}

- (void)awakeFromNib {
	[super awakeFromNib];
	
	self.tabBarItem = [[UCTabBarItem alloc] initWithTitle:@"My Cart"
											imageSelected:@"cart"
											andUnselected:@"cart"];

}

- (void)setup {
	[super setup];
	
	/*
	NSString *cartPrice = [NSString stringWithFormat:@"$ %.2f", [[Cart cartPrice] doubleValue]];
	[self.navigationItem.leftBarButtonItem setTitle:cartPrice];
*/
	[self updateCartPrice];
	
	self.currentProductQuantity = 0;
	
	self.productList = [[NSMutableArray alloc] initWithArray:[Product findByAttribute:@"is_in_cart" withValue:@(YES) andOrderBy:@"price" ascending:YES]];
//	self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", [self.productList count]];
	[self updateBadgeCartValue];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 80.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.productList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ProductCell";
    ProductCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
	
    // Configure the cell...
	
	[cell setDelegate:self];
	
	UIColor *color = [AppDelegate appDelegate].color;
	
	[cell setFirstStateIconName:@"mathematic-multiply2-icon-white"
                     firstColor:color
            secondStateIconName:@"plus-minus-icon"
                    secondColor:color
                  thirdIconName:@"Very-Basic-Info-icon"
                     thirdColor:color
                 fourthIconName:@"editing-delete-icon-white"
                    fourthColor:color
				   fithIconName:nil
					  fithColor:color];
	
	
	Product *product = [self.productList objectAtIndex:indexPath.row];
	
	cell.priceLabel.text = [NSString stringWithFormat:@"%@ x $ %@", product.quantity, product.price];
//[cell.priceLabel setText:[NSString stringWithFormat:@"%@ x $ 749.99", product.quantity]];

	cell.referenceLabel.text = product.reference;
	
	cell.nameLabel.text = product.name;
	
	
	
//	NSString *imageUrlString = [NSString stringWithFormat:@"images/products/%@/%@", product.product_id, product.id_default_image];
//	NSMutableURLRequest *request = [SessionManager requestForRoute:imageUrlString];
//	NSLog(@"%s | %@", __PRETTY_FUNCTION__, [request description]);
	
//	if (cell.imageView.image == nil) {
		NSMutableURLRequest *request = [EwaterFeaturesAPI defaultImageUrlRequestForProduct:product];
		[cell.productImageView setImageWithURL:[request URL] placeholderImage:[UIImage imageNamed:@"default-image"]];
	
//	}
	//INFO: basic stuff
	[cell.contentView setBackgroundColor:[UIColor whiteColor]];
	
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"productDetailSegue"]) {
		
		ProductDetailViewController *productDetailViewController = [segue destinationViewController];
		productDetailViewController.product = [self.productList objectAtIndex:self.currentIndexPath.row];
	}
}

#pragma mark - Table view delegate

- (void)deleteProductAtIndexpath:(NSIndexPath *)indexPath {
	
	Product *product = [self.productList objectAtIndex:indexPath.row];
	product.is_in_cart = NO;
	product.quantity = [NSNumber numberWithInt:0];
	
//	[product deleteEntity];
	
	[[NSManagedObjectContext defaultContext] save:nil];//NestedContexts];
	
	[self setup];
	
	[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)selectQuantityOfProductAtIndexPath:(NSIndexPath *)indexPath {
	Product *product = [self.productList objectAtIndex:indexPath.row];
	
	
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
							   
							   [self updateCartPrice];
							   //
							   
							   [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
							   							   
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
		case MCSwipeTableViewButtonState2://INFO: Quantity
		{
			[cell bounceToOrigin];
			[self selectQuantityOfProductAtIndexPath:self.currentIndexPath];
		}
			break;
		case MCSwipeTableViewButtonState3://INFO: Detail
		{
			[cell bounceToOrigin];
			[self performSegueWithIdentifier:@"productDetailSegue" sender:self];

		}
			break;
		case MCSwipeTableViewButtonState4://INFO: Delete item from cart
		{
			[cell bounceToOrigin];
			[self deleteProductAtIndexpath:self.currentIndexPath];
		}
			break;
		case MCSwipeTableViewButtonState5://INFO: nothing
			break;
			
		default:
			break;
	}
	self.currentIndexPath = nil;
}

- (void)swipeStickerTableViewCell:(ProductCell *)cell didTriggerState:(MCSwipeTableViewCellState)state withMode:(MCSwipeTableViewCellMode)mode {
	NSLog(@"%s - %d - %d", __PRETTY_FUNCTION__, state, mode);
}

#pragma mark - Handle


- (void)handleOrder:(id)sender {
	NSLog(@"%s submit order", __PRETTY_FUNCTION__);
	
	[self performSegueWithIdentifier:@"addressSegue" sender:self];
	
}

/*
#pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
	if (self.tmpKeyString != nil && [self.tmpKeyString length] > 0)
		self.tmpKeyString = [NSString stringWithFormat:@"%@:%@", self.tmpKeyString, elementName];
	else
		self.tmpKeyString = elementName;
	NSLog(@"%s | key: %@", __PRETTY_FUNCTION__, self.tmpKeyString);
	 NSLog(@"%s | attributeDict: %@", __PRETTY_FUNCTION__, attributeDict);
	 NSLog(@"%s | elementName: %@", __PRETTY_FUNCTION__, elementName);

 if ([elementName isEqualToString:@"product"]) {
		if ([attributeDict valueForKey:@"id"]) {
			NSString *routeString = [NSString stringWithFormat:@"products/%@", [attributeDict valueForKey:@"id"]];
			
			NSMutableURLRequest *request = [SessionManager requestForRoute:routeString];
			[request setHTTPMethod:@"GET"];
			
			AFXMLRequestOperation *operation = [AFXMLRequestOperation XMLParserRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser) {
				XMLParser.delegate = self;
				[XMLParser parse];
			} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSXMLParser *XMLParser) {
				NSLog(@"%s | %@", __PRETTY_FUNCTION__, [error description]);
			}];
			[operation start];
		}
		else {
			self.productDictionary = [[NSMutableDictionary alloc] init];
		}
	}
	
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    self.tmpInnerTagText = string; //INFO: text between tags
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{

	 NSLog(@"%s | tmpInnerTagText: %@", __PRETTY_FUNCTION__, self.tmpInnerTagText);
	 NSLog(@"%s | elementName: %@", __PRETTY_FUNCTION__, elementName);

    
	[self.productDictionary setObject:self.tmpInnerTagText forKey:self.tmpKeyString];
	
	if ([elementName isEqualToString:@"product"]) {
		
		if (self.productDictionary != nil && [self.productDictionary count] > 0) {
			NSLog(@"\n_______________\n");
			
			NSLog(@"%s | productDictionary: %@", __PRETTY_FUNCTION__, self.productDictionary);

			Product *product = [Product addUpdateProductWithDictionary:self.productDictionary];
			[self.productList addObject:product];

			[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
			//			[self.tableView reloadData];
			//			[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[self.productList count] - 1 inSection:0]] withRowAnimation:YES];
//			NSLog(@"%s | %@", __PRETTY_FUNCTION__, product);
			NSLog(@"\n_______________\n");
		}
		self.productDictionary = nil;
    }
	
	int lengthToKeep = [self.tmpKeyString length] - ([elementName length] + 1);
	lengthToKeep = (lengthToKeep < 0) ? 0 : lengthToKeep;
	
	self.tmpKeyString = [self.tmpKeyString substringToIndex:lengthToKeep];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"Paser Error = %@", parseError);
    //TODO: Create Alert message error
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	NSLog(@"%s", __PRETTY_FUNCTION__);
	
}
*/

@end
