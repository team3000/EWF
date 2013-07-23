//
//  Address+Manager.h
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 6/15/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "Address.h"

@class Customer;
@class Employee;

@interface Address (Manager)

+ (Address *)addressWithId:(int)id_address;
+ (Address *)addressForCustomer:(Customer *)customer;
//+ (Address *)addressForEmployee:(Employee *)employee;
+ (Address *)addUpdateAddressWhithDictionary:(NSMutableDictionary *)dictionary;

+ (NSString *)convertToXML:(Address *)address;

@end
