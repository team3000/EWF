//
//  OrderRow+Manager.m
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 6/15/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "OrderRow+Manager.h"
#import "Product.h"
#import "Product+Manager.h"

@implementation OrderRow (Manager)

+ (OrderRow *)orderRowWithId:(int)id_order_row {
	NSLog(@"%s | id_order_row: %d", __PRETTY_FUNCTION__, id_order_row);
	
	NSManagedObjectContext *localContext = [NSManagedObjectContext defaultContext];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_order_row == [c] %d", id_order_row];
	OrderRow *orderRow = [OrderRow findFirstWithPredicate:predicate inContext:localContext];
	
	if (orderRow) {
		NSLog(@"%s | OrderRow already exist", __PRETTY_FUNCTION__);
	}
	else {
		NSLog(@"%s | OrderRow does not already exist", __PRETTY_FUNCTION__);
		orderRow.id_order_row =  @(id_order_row);
	}
	
//	[localContext save:nil];
	[localContext saveToPersistentStoreAndWait];

	return orderRow;

}

+ (OrderRow *)addUpdateOrderRowWhithDictionary:(NSMutableDictionary *)dictionary {
	NSManagedObjectContext *localContext = [NSManagedObjectContext defaultContext];
	
	OrderRow *orderRow = [OrderRow orderRowWithId:[[dictionary objectForKey:@"prestashop:order:associations:order_rows:order_row:id"] intValue]];
	
	orderRow.product_attribute_id = @([[dictionary objectForKey:@"prestashop:order:associations:order_rows:order_row:product_attribute_id"] intValue]);
	orderRow.product_id =  @([[dictionary objectForKey:@"prestashop:order:associations:order_rows:order_row:product_id"] intValue]);
	orderRow.product_name =  [dictionary objectForKey:@"prestashop:order:associations:order_rows:order_row:product_name"];
	orderRow.product_price =  @([[dictionary objectForKey:@"prestashop:order:associations:order_rows:order_row:product_price"] doubleValue]);
	orderRow.product_quantity =  @([[dictionary objectForKey:@"prestashop:order:associations:order_rows:order_row:product_quantity"] intValue]);
	
	orderRow.product = [Product productWithId:[orderRow.product_id intValue]];
	
	
//	[[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
//	[localContext save:nil];
	[localContext saveToPersistentStoreAndWait];

	
	return orderRow;
}


@end
