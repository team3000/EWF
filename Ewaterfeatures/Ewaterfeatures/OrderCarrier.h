//
//  OrderCarrier.h
//  ZXingWidget
//
//  Created by Adrien Guffens on 7/2/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface OrderCarrier : NSManagedObject

@property (nonatomic, retain) NSNumber * id_order_carrier;
@property (nonatomic, retain) NSNumber * id_order;
@property (nonatomic, retain) NSNumber * id_carrier;
@property (nonatomic, retain) NSNumber * id_order_invoice;
@property (nonatomic, retain) NSNumber * weight;
@property (nonatomic, retain) NSNumber * shipping_cost_tax_excl;
@property (nonatomic, retain) NSNumber * shipping_cost_tax_incl;
@property (nonatomic, retain) NSString * tracking_number;
@property (nonatomic, retain) NSDate * date_add;

@end
