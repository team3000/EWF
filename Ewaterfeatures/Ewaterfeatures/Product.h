//
//  Product.h
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 6/18/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Category, Image;

@interface Product : NSManagedObject

@property (nonatomic, retain) NSNumber * active;
@property (nonatomic, retain) NSString * additional_shipping_cost;
@property (nonatomic, retain) NSString * availability;
@property (nonatomic, retain) NSNumber * available_for_order;
@property (nonatomic, retain) NSDate * date_add;
@property (nonatomic, retain) NSDate * date_upd;
@property (nonatomic, retain) NSNumber * depth;
@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSNumber * id_category_default;
@property (nonatomic, retain) NSNumber * id_default_image;
@property (nonatomic, retain) NSNumber * id_product;
@property (nonatomic, retain) NSNumber * id_stock_available;
@property (nonatomic, retain) NSNumber * is_in_cart;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSString * product_description;
@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) NSString * reference;
@property (nonatomic, retain) NSString * related_product;
@property (nonatomic, retain) NSString * size;
@property (nonatomic, retain) NSString * sku;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSNumber * weight;
@property (nonatomic, retain) NSNumber * width;
@property (nonatomic, retain) Category *default_category;
@property (nonatomic, retain) NSSet *image;
@end

@interface Product (CoreDataGeneratedAccessors)

- (void)addImageObject:(Image *)value;
- (void)removeImageObject:(Image *)value;
- (void)addImage:(NSSet *)values;
- (void)removeImage:(NSSet *)values;

@end
