//
//  OrderRow+Manager.h
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 6/15/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "OrderRow.h"

@interface OrderRow (Manager)

+ (OrderRow *)orderRowWithId:(int)id_order;
+ (OrderRow *)addUpdateOrderRowWhithDictionary:(NSMutableDictionary *)dictionary;


@end
