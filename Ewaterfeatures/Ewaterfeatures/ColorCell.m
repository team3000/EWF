//
//  ColorCell.m
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 6/5/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "ColorCell.h"

@implementation ColorCell

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
	[self.contentView setBackgroundColor:[UIColor whiteColor]];
}

@end
