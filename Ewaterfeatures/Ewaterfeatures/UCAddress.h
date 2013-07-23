//
//  UCAddress.h
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 6/6/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Address.h"

#import "UCAddressDelegate.h"

#import "QuantityPickerViewDelegate.h"

@interface UCAddress : UITableView <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, QuantityPickerViewDelegate>

//@property (nonatomic, strong) id<UCAddressDelegate>addressDelegate;

@property (nonatomic, strong) NSMutableArray *placeholderList;
@property (nonatomic, strong) NSMutableDictionary *addressList;

@property (nonatomic, assign) BOOL isEditable;

@property (nonatomic, strong) Address *address;

- (void)setupAddress:(Address *)address;
- (void)unbindAddress;

@end
