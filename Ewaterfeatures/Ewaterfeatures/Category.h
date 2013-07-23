//
//  Category.h
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 6/19/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Product;

@interface Category : NSManagedObject

@property (nonatomic, retain) NSNumber * active;
@property (nonatomic, retain) NSString * category_description;
@property (nonatomic, retain) NSDate * date_add;
@property (nonatomic, retain) NSDate * date_upd;
@property (nonatomic, retain) NSNumber * id_category;
@property (nonatomic, retain) NSNumber * id_shop_default;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * nb_products_recursive;
@property (nonatomic, retain) NSNumber * is_root_category;
@property (nonatomic, retain) NSNumber * id_parent;
@property (nonatomic, retain) NSSet *product;
@end

@interface Category (CoreDataGeneratedAccessors)

- (void)addProductObject:(Product *)value;
- (void)removeProductObject:(Product *)value;
- (void)addProduct:(NSSet *)values;
- (void)removeProduct:(NSSet *)values;

@end
