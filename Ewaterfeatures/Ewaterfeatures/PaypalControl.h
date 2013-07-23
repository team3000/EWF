//
//  PaypalControl.h
//  EWF
//
//  Created by Adrien Guffens on 7/4/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BButton.h"
#import "QuantityPickerView.h"

@interface PaypalControl : UIView <UITextFieldDelegate, QuantityPickerViewDelegate>


@property (nonatomic, strong) IBOutlet UITextField *cardNumberTextField;
@property (nonatomic, strong) IBOutlet UITextField *cardTypeTextField;
@property (nonatomic, strong) IBOutlet UITextField *cardMonthTextField;
@property (nonatomic, strong) IBOutlet UITextField *cardYearTextField;
@property (nonatomic, strong) IBOutlet UITextField *cardCVVTextField;

@property (nonatomic, strong) IBOutlet BButton *submitButton;

@end
