//
//  ProductDetailViewController.m
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 5/3/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "Product+Manager.h"
#import "Category.h"

#import "AFNetworking.h"
#import "HelperView.h"

#import "EwaterFeaturesAPI.h"

#import "Image.h"

#import "AppDelegate.h"

@interface ProductDetailViewController ()

@property (nonatomic, assign)NSInteger currentProductQuantity;
@property (nonatomic, assign)int imageIndex;
@property (nonatomic, strong)NSTimer *imageTimer;

@end

@implementation ProductDetailViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
		self.customBackButtonEnable = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
}

- (void)setup {
	[super setup];
	//
	if (self.customBackButtonEnable == YES) {
		
		UIImage *backButtonImage = [[UIImage imageNamed:@"down-icon"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 6)];
		UIButton *backButton =  [UIButton buttonWithType:UIButtonTypeCustom];
		
		[backButton setBackgroundImage:backButtonImage forState:UIControlStateNormal];
		[backButton addTarget:self action:@selector(handleBack) forControlEvents:UIControlEventAllTouchEvents];
		backButton.frame = CGRectMake(0.0, 0.0, backButtonImage.size.width, backButtonImage.size.height);
		
		
		UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backButton];
		
		self.navigationItem.hidesBackButton = YES;
		
		self.navigationItem.leftBarButtonItem = item;
		
	}
	
	self.imageIndex = 0;
	self.title = @"Product";
	
	[self configureProduit];
	[self updateProduct];

}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	
	[self.imageTimer invalidate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureProduit {
	if (self.product) {
		
		dispatch_async(dispatch_get_main_queue(), ^{
			self.nameLabel.text = self.product.name;
			self.referenceLabel.text = self.product.reference;
			self.priceLabel.text = [NSString stringWithFormat:@"$ %@", self.product.price];
			
			//			self.skuLabel.text = self.product.sku;
			self.skuLabel.text = self.product.reference;
			//TODO: complete category
			self.categoryLabel.text = self.product.default_category.name;
			self.sizeLabel.text = [NSString stringWithFormat:@"%@*%@*%@ CM", self.product.width, self.product.height, self.product.depth];//self.product.size;
			self.weightLabel.text = [NSString stringWithFormat:@"%@ KG", self.product.weight];
			self.availabilityLabel.text = [self.product.available_for_order boolValue] ==  YES ? @"In Stock" : @"Out of Stock";
			self.relatedProductsLabel.text = self.product.related_product;
			[self.descriptionWebView loadHTMLString:self.product.product_description baseURL:nil];
			
			NSString *imageUrlString = [NSString stringWithFormat:@"images/products/%@/%@", self.product.id_product, self.product.id_default_image];
			NSMutableURLRequest *request = [SessionManager requestForRoute:imageUrlString];
			NSLog(@"%s | %@", __PRETTY_FUNCTION__, [request description]);
			
			[self.imageView setImageWithURL:[request URL] placeholderImage:[UIImage imageNamed:@"default-image"]];
			
			
			self.imageTimer = [NSTimer scheduledTimerWithTimeInterval:6.0
															   target:self
															 selector:@selector(handleImage:)
															 userInfo:nil
															  repeats:YES];
		});
	}
}

- (void)updateProduct {
	
	[EwaterFeaturesAPI updateProductWithId:[self.product.id_product stringValue] success:^(NSMutableDictionary *result) {
		NSLog(@"%s | result = %@", __PRETTY_FUNCTION__, result);
		Product *product = [Product addUpdateProductWithDictionary:result];
		if (product) {
			[self configureProduit];
		}
	} failure:^(NSHTTPURLResponse *response, NSError *error) {
		//INFO: fail update product
		NSLog(@"%s | Fail update Product", __PRETTY_FUNCTION__);
	}];
}

- (void)handleImage:(NSTimer *)timer {
	
	if (self.imageIndex > [self.product.image count]) {
		self.imageIndex = 0;
	}
	//	self.imageIndex = (self.imageIndex > [self.product.image count]) ? 0 : self.imageIndex++;
	NSLog(@"%d - current index: %d", [self.product.image count], self.imageIndex);
	
	int i = 0;
	for (Image *image in self.product.image) {
		
		if (i == self.imageIndex) {
			NSString *imageUrlString = [NSString stringWithFormat:@"images/products/%@/%@", self.product.id_product, image.id_image];
			NSMutableURLRequest *request = [SessionManager requestForRoute:imageUrlString];
			
			NSLog(@"%s | %@", __PRETTY_FUNCTION__, [request description]);
			
			[self.imageView setImageWithURL:[request URL] placeholderImage:self.imageView.image];//
		}
		i++;
	}
	self.imageIndex++;
}

- (void)handleAddToCart:(id)sender {
	
	self.product.is_in_cart = [NSNumber numberWithBool:YES];
	
	
	
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 300)];
	view.backgroundColor = [UIColor clearColor];
	
	QuantityPickerView *quantityPickerView = [[QuantityPickerView alloc] initWithFrame:CGRectMake(0, 0, 100, 300)];
	quantityPickerView.quantityPickerViewDelegate = self;
	quantityPickerView.quantity = [self.product.quantity integerValue] + 1;
	
	
	
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
							   self.product.is_in_cart = [NSNumber numberWithBool:YES];
							   self.product.quantity = [NSNumber numberWithInteger:quantityPickerView.quantity];
							   [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
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
	
	[[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
	[self updateBadgeCartValue];
}

#pragma mark - QuantityPickerViewDelegate

- (void)quantityPickerDidChange:(QuantityPickerView *)sender atRow:(NSInteger)row {
	NSLog(@"%s - %d", __PRETTY_FUNCTION__, sender.quantity);
	self.currentProductQuantity = sender.quantity;
}


- (IBAction)handleBuy:(id)sender {
}

- (IBAction)handleBack {
	[self dismissViewControllerAnimated:YES
							 completion:nil];
	//	[self.navigationController removeFromParentViewController];
}
@end
