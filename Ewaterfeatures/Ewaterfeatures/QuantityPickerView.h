//
//  MinutePickerView.h
//  AB
//
//  Created by Adrien Guffens on 2/19/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuantityPickerViewDelegate.h"

@interface QuantityPickerView : UIPickerView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, assign)NSInteger quantity;
@property (nonatomic, strong)id<QuantityPickerViewDelegate> quantityPickerViewDelegate;
@property (nonatomic, strong)NSMutableArray *itemList;
@property (nonatomic, assign)NSInteger selectedRow;

- (void)setSelectedRow:(NSInteger)row;
- (void)setSelectedObject:(id)object;

@end
