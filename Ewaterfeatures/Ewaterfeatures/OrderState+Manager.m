//
//  OrderState+Manager.m
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 7/2/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "OrderState+Manager.h"

@implementation OrderState (Manager)

+ (OrderState *)orderStateWithId:(int)id_order_state {
	NSLog(@"%s | id_order_state: %d", __PRETTY_FUNCTION__, id_order_state);
	
	NSManagedObjectContext *localContext = [NSManagedObjectContext defaultContext];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_order_state == [c] %d", id_order_state];
	OrderState *orderState = [OrderState findFirstWithPredicate:predicate inContext:localContext];
	
	if (orderState) {
		NSLog(@"%s | OrderState already exist", __PRETTY_FUNCTION__);
	}
	else {
		NSLog(@"%s | OrderState does not already exist", __PRETTY_FUNCTION__);
		orderState = [OrderState createEntity];
		orderState.id_order_state = @(id_order_state);
		//		[localContext save:nil];
	}
	[localContext saveToPersistentStoreAndWait];
	
	return orderState;
}

+ (OrderState *)addUpdateOrderStateWithDictionary:(NSMutableDictionary *)dictionary {
	NSManagedObjectContext *localContext = [NSManagedObjectContext defaultContext];
	
	OrderState *orderState = [OrderState orderStateWithId:[[[dictionary objectForKey:@"prestashop:order_state:id"] lastObject] intValue]];
	
//	orderState.module_name = [[dictionary objectForKey:@"prestashop:order_state:module_name"] lastObject];
	orderState.name = [[dictionary objectForKey:@"prestashop:order_state:name"] lastObject];
	
	orderState.delivery = @([[[dictionary objectForKey:@"prestashop:order_state:delivery"] lastObject] boolValue]);
	
	orderState.hidden = @([[[dictionary objectForKey:@"prestashop:order_state:hidden"] lastObject] boolValue]);
	orderState.send_email = @([[[dictionary objectForKey:@"prestashop:order_state:send_email"] lastObject] boolValue]);
	orderState.invoice = @([[[dictionary objectForKey:@"prestashop:order_state:invoice"] lastObject] boolValue]);
	orderState.shipped = @([[[dictionary objectForKey:@"prestashop:order_state:shipped"] lastObject] boolValue]);
	orderState.paid = @([[[dictionary objectForKey:@"prestashop:order_state:paid"] lastObject] boolValue]);
	orderState.deleted = @([[[dictionary objectForKey:@"prestashop:order_state:deleted"] lastObject] boolValue]);
	
	orderState.template = [[dictionary objectForKey:@"prestashop:order_state:template"] lastObject];
	
	[localContext saveToPersistentStoreAndWait];
	
	return  orderState;
}


@end
