//
//  CartRow+Manager.h
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 6/15/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "CartRow.h"

@interface CartRow (Manager)

+ (CartRow *)cartRowWithId:(int)id_product;
+ (CartRow *)addUpdateCartRowWhithDictionary:(NSMutableDictionary *)dictionary;

@end
