//
//  QuantityPickerDelegate.h
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 6/4/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QuantityPickerView;

@protocol QuantityPickerViewDelegate <NSObject>

- (void)quantityPickerDidChange:(QuantityPickerView *)sender atRow:(NSInteger)row;
- (NSString *)quantityPicker:(QuantityPickerView *)sender stringAtRow:(NSInteger)row;

@end
