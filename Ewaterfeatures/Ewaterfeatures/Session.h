//
//  Session.h
//  AB
//
//  Created by Adrien Guffens on 1/13/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Customer;
@class Employee;

@interface Session : NSObject

@property (nonatomic, strong) NSString *login;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *host;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *cookieKey;

@property (nonatomic, strong) Customer *customer;
@property (nonatomic, strong) Employee *employee;

@end
