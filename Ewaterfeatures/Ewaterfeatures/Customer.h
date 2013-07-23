//
//  Customer.h
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 6/18/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Customer : NSManagedObject

@property (nonatomic, retain) NSNumber * active;
@property (nonatomic, retain) NSDate * birthday;
@property (nonatomic, retain) NSString * company;
@property (nonatomic, retain) NSDate * date_add;
@property (nonatomic, retain) NSDate * date_upd;
@property (nonatomic, retain) NSNumber * deleted;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * firstname;
@property (nonatomic, retain) NSNumber * id_customer;
@property (nonatomic, retain) NSNumber * id_gender;
@property (nonatomic, retain) NSNumber * is_guest;
@property (nonatomic, retain) NSString * lastname;
@property (nonatomic, retain) NSNumber * newsletter;
@property (nonatomic, retain) NSNumber * optin;
@property (nonatomic, retain) NSString * secure_key;
@property (nonatomic, retain) NSString * siret;
@property (nonatomic, retain) NSString * website;
@property (nonatomic, retain) NSString * passwd;

@end
