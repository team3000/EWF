//
//  SessionDelegate.h
//  AB
//
//  Created by Adrien Guffens on 1/18/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SessionDelegate <NSObject>

- (void)didLogin;
- (void)didFailLogin;

@end
