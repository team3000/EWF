//
//  OrderCell.m
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 6/13/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "OrderCell.h"
#import "AppDelegate.h"

@implementation OrderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
	
    // Configure the view for the selected state
	if (selected == NO) {
		[self.contentView setBackgroundColor:[UIColor whiteColor]];
	} else {
		[self.contentView setBackgroundColor:[AppDelegate appDelegate].color];
	}
}

@end
