//
//  OrderCell.h
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 6/13/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *referenceLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalPaidLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderStateLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateAddedLadel;

@end
