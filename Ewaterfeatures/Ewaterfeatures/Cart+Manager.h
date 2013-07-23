//
//  Cart+Manager.h
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 6/15/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "Cart.h"

@interface Cart (Manager)

+ (Cart *)cartWithId:(int)id_cart;
+ (Cart *)addUpdateCartWhithDictionary:(NSMutableDictionary *)dictionary;

+ (NSNumber *)cartPrice;
+ (void)clearCart;

+ (NSString *)convertToXML:(Cart *)cart;

@end
