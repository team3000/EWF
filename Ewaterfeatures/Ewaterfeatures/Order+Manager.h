//
//  Order+Manager.h
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 6/15/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "Order.h"

@interface Order (Manager)

+ (Order *)orderWithId:(int)id_order;
+ (Order *)addUpdateOrderWhithDictionary:(NSMutableDictionary *)dictionary;

+ (NSString *)convertToXML:(Order *)order;

@end
