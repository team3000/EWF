//
//  OrderRowCell.h
//  EWF
//
//  Created by Adrien Guffens on 7/2/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderRowCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *referenceLabel;
@property (strong, nonatomic) IBOutlet UIImageView *productImageView;

@end
