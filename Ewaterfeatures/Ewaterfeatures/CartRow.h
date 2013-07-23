//
//  CartRow.h
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 6/18/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Product;

@interface CartRow : NSManagedObject

@property (nonatomic, retain) NSNumber * id_product;
@property (nonatomic, retain) NSNumber * id_product_attribute;
@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) Product *product;

@end
