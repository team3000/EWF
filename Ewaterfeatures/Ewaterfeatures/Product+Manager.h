//
//  Product+Manager.h
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 5/31/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"

@interface Product (Manager)

+ (Product *)productWithId:(int)id_product;
+ (Product *)addUpdateProductWithDictionary:(NSMutableDictionary *)dictionary;

+ (int)quantityOfProductsInCart;
+ (int)quantityOfProducts;

@end
