//
//  Employee+Manager.h
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 6/18/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "Employee.h"

@interface Employee (Manager)

+ (Employee *)employeeWithId:(int)id_employee;
+ (Employee *)addUpdateEmployeeWithDictionary:(NSDictionary *)dictionary;

@end
