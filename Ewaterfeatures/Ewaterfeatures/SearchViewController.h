//
//  SearchViewController.h
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 5/2/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductCell.h"

#import "BaseTableViewController.h"

@interface SearchViewController : BaseTableViewController <UISearchBarDelegate, UISearchDisplayDelegate, MCSwipeStickerTableViewCellDelegate, QuantityPickerViewDelegate, QuantityPickerViewDelegate>

@property(nonatomic, strong)NSMutableArray *searchRecordList;
@property(strong,nonatomic)NSMutableArray *filteredSearchRecordList;

@property (strong, nonatomic) IBOutlet UITableView *searchTableView;

@end
