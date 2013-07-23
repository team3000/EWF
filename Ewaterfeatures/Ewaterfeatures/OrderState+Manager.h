//
//  OrderState+Manager.h
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 7/2/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "OrderState.h"

@interface OrderState (Manager)

+ (OrderState *)orderStateWithId:(int)id_order_state;
+ (OrderState *)addUpdateOrderStateWithDictionary:(NSMutableDictionary *)dictionary;


@end
