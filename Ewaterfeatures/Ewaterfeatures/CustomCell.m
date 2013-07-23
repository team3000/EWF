//
//  CustomCell.m
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 5/25/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "CustomCell.h"
#import "AppDelegate.h"

@implementation CustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
		[self.contentView setBackgroundColor:[UIColor whiteColor]];
		
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //[super setSelected:selected animated:animated];
	
    // Configure the view for the selected state
	NSLog(@"%s %@", __PRETTY_FUNCTION__, selected ? @"Selected" : @"Unselected");
	/*
	 if (self.isUserInteractionEnabled == YES)//([self.reuseIdentifier isEqualToString:@"logoutCell"])
	 selected = NO;
	 */
	if (selected == NO) {
		[self.contentView setBackgroundColor:[UIColor whiteColor]];
	} else {
		[self.contentView setBackgroundColor:[AppDelegate appDelegate].color];
	}
	//self.isUserInteractionEnabled == YES
}

@end
