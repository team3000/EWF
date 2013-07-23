//
//  Employee.h
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 6/18/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Employee : NSManagedObject

@property (nonatomic, retain) NSNumber * id_employee;
@property (nonatomic, retain) NSNumber * id_lang;
@property (nonatomic, retain) NSDate * last_passwd_gen;
@property (nonatomic, retain) NSDate * stats_date_from;
@property (nonatomic, retain) NSDate * stats_date_to;
@property (nonatomic, retain) NSString * passwd;
@property (nonatomic, retain) NSString * lastname;
@property (nonatomic, retain) NSString * firstname;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * active;
@property (nonatomic, retain) NSNumber * id_profile;

@end
