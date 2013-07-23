//
//  UCTabBarItem.h
//  sportel
//
//  Created by Adrien Guffens on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UCTabBarItem : UITabBarItem {
	UIImage *_highlightedImage;
	UIImage *_standardImage;
}

-(id) initWithTitle:(NSString *)title imageSelected:(NSString *)selected andUnselected:(NSString *)unselected;

@property(nonatomic, strong)UIImage * HighlightedImage;
@property(nonatomic, strong)UIImage * StandardImage;

@end
