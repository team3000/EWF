//
//  Address.h
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 6/26/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Country, CountryState, Customer;

@interface Address : NSManagedObject

@property (nonatomic, retain) NSString * address1;
@property (nonatomic, retain) NSString * address2;
@property (nonatomic, retain) NSString * alias;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSDate * date_add;
@property (nonatomic, retain) NSDate * date_upd;
@property (nonatomic, retain) NSNumber * deleted;
@property (nonatomic, retain) NSString * firstname;
@property (nonatomic, retain) NSNumber * id_address;
@property (nonatomic, retain) NSNumber * id_country;
@property (nonatomic, retain) NSNumber * id_customer;
@property (nonatomic, retain) NSString * lastname;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * phone_mobile;
@property (nonatomic, retain) NSString * postcode;
@property (nonatomic, retain) NSNumber * id_state;
@property (nonatomic, retain) NSString * compagny;
@property (nonatomic, retain) NSString * other;
@property (nonatomic, retain) Country *country;
@property (nonatomic, retain) Customer *customer;
@property (nonatomic, retain) CountryState *countryState;

@end
