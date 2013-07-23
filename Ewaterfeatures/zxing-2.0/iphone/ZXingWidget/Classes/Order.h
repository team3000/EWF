//
//  Order.h
//  ZXingWidget
//
//  Created by Adrien Guffens on 6/20/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Address, Cart, OrderRow;

@interface Order : NSManagedObject

@property (nonatomic, retain) NSNumber * carrier_tax_rate;
@property (nonatomic, retain) NSNumber * conversion_rate;
@property (nonatomic, retain) NSNumber * current_state;
@property (nonatomic, retain) NSDate * date_add;
@property (nonatomic, retain) NSDate * date_upd;
@property (nonatomic, retain) NSDate * delivery_date;
@property (nonatomic, retain) NSNumber * delivery_number;
@property (nonatomic, retain) NSNumber * gift;
@property (nonatomic, retain) NSNumber * id_address_delivery;
@property (nonatomic, retain) NSNumber * id_address_invoice;
@property (nonatomic, retain) NSNumber * id_cart;
@property (nonatomic, retain) NSNumber * id_currency;
@property (nonatomic, retain) NSNumber * id_customer;
@property (nonatomic, retain) NSNumber * id_order;
@property (nonatomic, retain) NSNumber * id_shop;
@property (nonatomic, retain) NSDate * invoice_date;
@property (nonatomic, retain) NSNumber * invoice_number;
@property (nonatomic, retain) NSString * module;
@property (nonatomic, retain) NSString * payment;
@property (nonatomic, retain) NSString * reference;
@property (nonatomic, retain) NSString * secure_key;
@property (nonatomic, retain) NSNumber * total_discounts;
@property (nonatomic, retain) NSNumber * total_discounts_tax_incl;
@property (nonatomic, retain) NSNumber * total_paid;
@property (nonatomic, retain) NSNumber * total_paid_real;
@property (nonatomic, retain) NSNumber * total_paid_tax_excl;
@property (nonatomic, retain) NSNumber * total_paid_tax_incl;
@property (nonatomic, retain) NSNumber * total_products;
@property (nonatomic, retain) NSNumber * total_products_wt;
@property (nonatomic, retain) NSNumber * total_shipping;
@property (nonatomic, retain) NSNumber * total_shipping_tax_excl;
@property (nonatomic, retain) NSNumber * total_shipping_tax_incl;
@property (nonatomic, retain) NSNumber * total_wrapping;
@property (nonatomic, retain) NSNumber * total_wrapping_tax_excl;
@property (nonatomic, retain) NSNumber * total_wrapping_tax_incl;
@property (nonatomic, retain) NSNumber * valid;
@property (nonatomic, retain) UNKNOWN_TYPE id_lang;
@property (nonatomic, retain) NSNumber * id_carrier;
@property (nonatomic, retain) Address *addressDelivery;
@property (nonatomic, retain) Address *addressInvoice;
@property (nonatomic, retain) Cart *cart;
@property (nonatomic, retain) NSSet *orderRow;
@end

@interface Order (CoreDataGeneratedAccessors)

- (void)addOrderRowObject:(OrderRow *)value;
- (void)removeOrderRowObject:(OrderRow *)value;
- (void)addOrderRow:(NSSet *)values;
- (void)removeOrderRow:(NSSet *)values;

@end
