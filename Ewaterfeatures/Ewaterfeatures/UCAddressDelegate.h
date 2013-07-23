//
//  UCAddressDelegate.h
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 6/26/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol UCAddressDelegate <NSObject>

- (void)textFieldDidBeginEditing:(UITextField *)textField forKey:(NSString *)key;

@end
