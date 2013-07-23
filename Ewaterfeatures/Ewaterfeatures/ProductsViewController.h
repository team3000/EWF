//
//  ProductsViewController.h
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 5/2/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductCell.h"

#import "BaseTableViewController.h"

@interface ProductsViewController : BaseTableViewController <MCSwipeStickerTableViewCellDelegate>

@property(nonatomic, strong) NSMutableArray *productList;
@property (nonatomic, strong) NSNumber *categoryFilterId;

@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end
