//
//  OrderRow.h
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 6/21/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Product;

@interface OrderRow : NSManagedObject

@property (nonatomic, retain) NSNumber * id_order_row;
@property (nonatomic, retain) NSNumber * product_attribute_id;
@property (nonatomic, retain) NSNumber * product_id;
@property (nonatomic, retain) NSString * product_name;
@property (nonatomic, retain) NSNumber * product_price;
@property (nonatomic, retain) NSNumber * product_quantity;
@property (nonatomic, retain) Product *product;

@end
