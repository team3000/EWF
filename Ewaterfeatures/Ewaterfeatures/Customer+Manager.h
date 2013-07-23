//
//  Customer+Manager.h
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 6/14/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "Customer.h"

@interface Customer (Manager)

+ (Customer *)customerWithId:(int)id_customer;
+ (Customer *)addUpdateCustomerWithDictionary:(NSDictionary *)dictionary;
+ (NSString *)convertToXML:(Customer *)customer;

@end
