//
//  OrderPayment.h
//  ZXingWidget
//
//  Created by Adrien Guffens on 7/2/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface OrderPayment : NSManagedObject

@property (nonatomic, retain) NSNumber * id_order_payment;
@property (nonatomic, retain) NSString * order_reference;
@property (nonatomic, retain) NSNumber * id_currency;
@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSString * payment_method;
@property (nonatomic, retain) NSString * card_number;
@property (nonatomic, retain) NSString * card_brand;
@property (nonatomic, retain) NSString * card_expiration;
@property (nonatomic, retain) NSString * card_holder;
@property (nonatomic, retain) NSDate * date_add;

@end
