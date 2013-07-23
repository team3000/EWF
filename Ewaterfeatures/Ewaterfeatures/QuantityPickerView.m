//
//  MinutePickerView.m
//  AB
//
//  Created by Adrien Guffens on 2/19/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "QuantityPickerView.h"

@implementation QuantityPickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		[self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib {
	self.quantity = 1;
	self.selectedRow = 0;
	self.delegate = self;
	self.dataSource = self;
	self.itemList = nil;
	self.showsSelectionIndicator = YES;
//	self.backgroundColor = [UIColor clearColor];
}

#pragma mark -
#pragma mark UIPicker Delegate & DataSource

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	self.quantity = row + 1;
	self.selectedRow = row;
	if ([self.quantityPickerViewDelegate respondsToSelector:@selector(quantityPickerDidChange:atRow:)]) {
		[self.quantityPickerViewDelegate quantityPickerDidChange:self atRow:row];
	}
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	if (self.itemList != nil) {
		return [self.itemList count];
	}
	else {
		return 1000;
	}
}

//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:  (NSInteger)component {
//    return [NSString stringWithFormat:@" Hello %d",row];
//}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
	
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 37)];
	if (self.itemList != nil) {
		//TODO: call delegate
		//label.text = [self.stringList objectAtIndex:row];
		if ([self.quantityPickerViewDelegate respondsToSelector:@selector(quantityPicker:stringAtRow:)]) {
			label.text = [self.quantityPickerViewDelegate quantityPicker:self stringAtRow:row];
		}
	}
	else {
		label.text = [NSString stringWithFormat:@"%d", row + 1];
	}
    label.textAlignment = UITextAlignmentCenter;
	label.font = [UIFont boldSystemFontOfSize:/*[UIFont systemFontSize]*/17.0];
    label.backgroundColor = [UIColor clearColor];
	
    return label;
}

/*
- (void)addSubview:(UIView*)view {
	//NSLog(@"------> %@", view);
	NSLog(@"%s | view: %@", __PRETTY_FUNCTION__, [view description]);
	if ([[[view class] description] isEqualToString:@"_UIPickerViewTopFrame"]) {
		// Cadre du pickerView
		return;
	}
	if ([[[view class] description] isEqualToString:@"_UIOnePartImageView"]) {
		// Vue permettant l'effet d'ombre en haut et en bas
		return; // note: également utilisé pour la selectionBar
	}
	if ([[[view class] description] isEqualToString:@"_UIPickerWheelView"]) {
		// Image des rouleaux
		//UIImage *backgroundImage = [UIImage imageNamed:@"bluePickerView"];
		//view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
	}
	if ([[[view class] description] isEqualToString:@"UIPickerTableView"]) {
		// Rouleaux (vue contenant les éléments des rouleaux), clearColor par défaut
		view.backgroundColor = [UIColor whiteColor];
	}
	if ([[[view class] description] isEqualToString:@"UIView"]) {
		// Arrière plan (noir par défaut)
		//UIImage *backgroundImage = [UIImage imageNamed:@"bluePickerView"];
		//view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];

	}
	[super addSubview:view];
}
*/

/*
- (void)setQuantityPickerViewDelegate:(id<QuantityPickerViewDelegate>)quantityPickerViewDelegate {
	self.quantityPickerViewDelegate = quantityPickerViewDelegate;
	if ([self.quantityPickerViewDelegate respondsToSelector:@selector(quantityPickerDidChange:)]) {
		[self.quantityPickerViewDelegate quantityPickerDidChange:self.quantity];
	}
}
*/

- (void)setSelectedRow:(NSInteger)row {
	
	[self selectRow:row inComponent:0 animated:YES];
	[self reloadAllComponents];
//	if ([self.quantityPickerViewDelegate respondsToSelector:@selector(quantityPickerDidChange:atRow:)]) {
//		[self.quantityPickerViewDelegate quantityPickerDidChange:self atRow:row];
//	}
	//self.selectedCustomer = [self.itemList objectAtIndex:row];
}

- (void)setSelectedObject:(id)object {
	NSInteger index = 0;
	
	if (object == nil)
		return;
	
	for (id item in self.itemList) {
		if ([item isEqual:object]) {
			[self setSelectedRow:index];
		}
		index++;
	}
}

@end
