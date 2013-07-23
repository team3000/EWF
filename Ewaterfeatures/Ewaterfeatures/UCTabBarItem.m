//
//  UCTabBarItem.m
//  sportel
//
//  Created by Adrien Guffens on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UCTabBarItem.h"

@implementation UCTabBarItem

@synthesize HighlightedImage = _highlightedImage;
@synthesize StandardImage = _standardImage;

- (id)initWithTitle:(NSString *)title imageSelected:(NSString *)selected andUnselected:(NSString *)unselected {
	self = [super initWithTitle:title image:nil tag:0];
	if (self) {
#warning TODO iOS 7 compatibility
//		[self setSelectedImage:[UIImage imageNamed:selected]];
		[self setHighlightedImage:[UIImage imageNamed:selected]];
		[self setStandardImage:[UIImage imageNamed:unselected]];
	}
	return self;
}

- (UIImage *)selectedImage {
	return self->_highlightedImage;
}

- (UIImage *)unselectedImage {
	return self->_standardImage;
}

@end
