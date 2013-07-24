//
//  UserCell.m
//  EWF
//
//  Created by Adrien Guffens on 7/23/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "UserCell.h"
#import "AppDelegate.h"

@implementation UserCell

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
	
	if (selected == YES) {
		self.contentView.backgroundColor = [AppDelegate appDelegate].color;
	}
	else {
		self.contentView.backgroundColor = [UIColor whiteColor];
	}
    // Configure the view for the selected state
}

@end
