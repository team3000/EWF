//
//  ProductDetailViewController.h
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 5/3/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomCell.h"
#import "BButton.h"

#import "BaseTableViewController.h"

@class Product;

@interface ProductDetailViewController : BaseTableViewController <UIWebViewDelegate>


@property (nonatomic, strong) Product *product;

//INFO: UI stuff

@property(nonatomic, assign)BOOL customBackButtonEnable;

//INFO: row 1
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *referenceLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)handleAddToCart:(id)sender;
- (IBAction)handleBuy:(id)sender;

//INFO: row 2
@property (strong, nonatomic) IBOutlet UILabel *skuLabel;

//INFO: row 3
@property (strong, nonatomic) IBOutlet UILabel *categoryLabel;

//INFO: row 4
@property (strong, nonatomic) IBOutlet UILabel *sizeLabel;

//INFO: row 5
@property (strong, nonatomic) IBOutlet UILabel *weightLabel;

//INFO: row 6
@property (strong, nonatomic) IBOutlet UILabel *availabilityLabel;

//INFO: row 7
@property (strong, nonatomic) IBOutlet UILabel *relatedProductsLabel;

//INFO: row 8
@property (strong, nonatomic) IBOutlet UIWebView *descriptionWebView;

//INFO: row 9
@property (strong, nonatomic) IBOutlet CustomCell *backCell;
@property (strong, nonatomic) IBOutlet BButton *backButton;

@end
