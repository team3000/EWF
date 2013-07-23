//
//  NewAddressViewController.h
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 6/26/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
#import "BButton.h"
#import "UCAddress.h"

@interface NewAddressViewController : BaseTableViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *aliasTextField;
@property (strong, nonatomic) IBOutlet UCAddress *address;
@property (strong, nonatomic) IBOutlet BButton *addNewAddressButton;

- (IBAction)handleAddNewAdressButton:(id)sender;

@end
