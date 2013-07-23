//
//  Cart.h
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 6/18/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Address, CartRow, Customer;

@interface Cart : NSManagedObject

@property (nonatomic, retain) NSNumber * allow_seperated_package;
@property (nonatomic, retain) NSDate * date_add;
@property (nonatomic, retain) NSDate * date_upd;
@property (nonatomic, retain) NSNumber * gift;
@property (nonatomic, retain) NSNumber * id_address_delivery;
@property (nonatomic, retain) NSNumber * id_address_invoice;
@property (nonatomic, retain) NSNumber * id_carrier;
@property (nonatomic, retain) NSNumber * id_cart;
@property (nonatomic, retain) NSNumber * id_currency;
@property (nonatomic, retain) NSNumber * id_customer;
@property (nonatomic, retain) NSNumber * id_guest;
@property (nonatomic, retain) NSNumber * id_shop;
@property (nonatomic, retain) NSNumber * id_shop_group;
@property (nonatomic, retain) NSString * secure_key;
@property (nonatomic, retain) Address *addressDelivery;
@property (nonatomic, retain) Address *addressInvoice;
@property (nonatomic, retain) NSSet *cartRow;
@property (nonatomic, retain) Customer *customer;
@end

@interface Cart (CoreDataGeneratedAccessors)

- (void)addCartRowObject:(CartRow *)value;
- (void)removeCartRowObject:(CartRow *)value;
- (void)addCartRow:(NSSet *)values;
- (void)removeCartRow:(NSSet *)values;

@end
