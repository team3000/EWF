//
//  User.h
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 6/10/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	UserTypeUnknown,
	UserTypeClient,
	UserTypeSeller
} UserType;

@interface User : NSObject

@end
