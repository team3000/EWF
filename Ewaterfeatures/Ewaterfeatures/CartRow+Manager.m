//
//  CartRow+Manager.m
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 6/15/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "CartRow+Manager.h"
#import "Product+Manager.h"
#import "Product.h"

@implementation CartRow (Manager)
//INFO: id == id product
+ (CartRow *)cartRowWithId:(int)id_product {
	NSLog(@"%s | id_product: %d", __PRETTY_FUNCTION__, id_product);
	
	NSManagedObjectContext *localContext = [NSManagedObjectContext defaultContext];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_product == [c] %d", id_product];
	CartRow *cartRow = [CartRow findFirstWithPredicate:predicate inContext:localContext];
	
	if (cartRow) {
		NSLog(@"%s | CartRow already exist", __PRETTY_FUNCTION__);
	}
	else {
		NSLog(@"%s | CartRow does not already exist", __PRETTY_FUNCTION__);
		cartRow = [CartRow createEntity];
		cartRow.id_product =  @(id_product);
	}
	
//	[localContext save:nil];
	[localContext saveToPersistentStoreAndWait];
	return cartRow;

}

+ (CartRow *)addUpdateCartRowWhithDictionary:(NSMutableDictionary *)dictionary {
	NSManagedObjectContext *localContext = [NSManagedObjectContext defaultContext];
	
	CartRow *cartRow = [CartRow cartRowWithId:[[dictionary objectForKey:@"prestashop:cart:associations:cart_rows:cart_row:id_product"] intValue]];

	cartRow.id_product = @([[dictionary objectForKey:@"prestashop:cart:associations:cart_rows:cart_row:id_product"] intValue]);
	cartRow.id_product_attribute = @([[dictionary objectForKey:@"prestashop:cart:associations:cart_rows:cart_row:id_product_attribute"] intValue]);
	cartRow.quantity = @([[dictionary objectForKey:@"prestashop:cart:associations:cart_rows:cart_row:quantity"] intValue]);
	
	//INFO: may be consider the product attribute id to be more OK
	cartRow.product = [Product productWithId:[cartRow.id_product intValue]];
	
//	[localContext save:nil];
	[localContext saveToPersistentStoreAndWait];
	
	return cartRow;
}


@end
