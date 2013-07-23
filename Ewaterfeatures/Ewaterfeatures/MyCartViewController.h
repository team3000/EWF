//
//  MyCartViewController.h
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 5/2/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductCell.h"
#import "QuantityPickerViewDelegate.h"

#import "BaseTableViewController.h"

@interface MyCartViewController : BaseTableViewController <MCSwipeStickerTableViewCellDelegate, NSXMLParserDelegate, QuantityPickerViewDelegate>

@property(nonatomic, strong) NSMutableArray *productList;

@end
