//
//  Cart+Manager.m
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 6/15/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "Cart+Manager.h"
#import "Order+Manager.h"
#import "Address+Manager.h"
#import "Customer+Manager.h"

#import "Cart.h"

#import "CartRow.h"
#import "CartRow+Manager.h"

#import "Product.h"

//
#import "AppDelegate.h"
#import "SessionManager.h"
#import "Customer.h"
//
#import "ConventionTools.h"

@implementation Cart (Manager)

+ (Cart *)cartWithId:(int)id_cart {
	NSLog(@"%s | id_cart: %d", __PRETTY_FUNCTION__, id_cart);
	
	NSManagedObjectContext *localContext = [NSManagedObjectContext defaultContext];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_cart == [c] %d", id_cart];
	Cart *cart = [Cart findFirstWithPredicate:predicate inContext:localContext];
	
	if (cart) {
		NSLog(@"%s | Cart already exist", __PRETTY_FUNCTION__);
	}
	else {
		NSLog(@"%s | Cart does not already exist", __PRETTY_FUNCTION__);
		cart = [Cart createEntity];
		cart.id_cart = @(id_cart);
//		[localContext saveToPersistentStoreAndWait];
	}
	
//	[localContext save:nil];
	[localContext saveToPersistentStoreAndWait];
	
	return cart;
}

/*
 TODO:
 - currency
 */
+ (Cart *)addUpdateCartWhithDictionary:(NSMutableDictionary *)dictionary {
	NSManagedObjectContext *localContext = [NSManagedObjectContext defaultContext];
	
	Cart *cart = [Cart cartWithId:[[[dictionary objectForKey:@"prestashop:cart:id"] lastObject] intValue]];
	
	cart.id_cart = @([[[dictionary objectForKey:@"prestashop:cart:id"] lastObject] intValue]);
	cart.allow_seperated_package = @([[[dictionary objectForKey:@"prestashop:cart:allow_seperated_package"] lastObject] boolValue]);
	
	cart.date_add = [ConventionTools getDate:[[dictionary objectForKey:@"prestashop:cart:date_add"] lastObject] withFormat:@"yyyy-MM-dd HH:mm:ss"];
	cart.date_upd = [ConventionTools getDate:[[dictionary objectForKey:@"prestashop:cart:date_upd"] lastObject] withFormat:@"yyyy-MM-dd HH:mm:ss"];
	
	cart.gift = @([[[dictionary objectForKey:@"prestashop:cart:gift"] lastObject] boolValue]);
	
	cart.id_address_delivery = @([[[dictionary objectForKey:@"prestashop:cart:id_address_delivery"] lastObject] intValue]);
	cart.id_address_invoice = @([[[dictionary objectForKey:@"prestashop:cart:id_address_invoice"] lastObject] intValue]);
	
	cart.id_carrier = @([[[dictionary objectForKey:@"prestashop:cart:id_carrier"] lastObject] intValue]);
	
	cart.id_currency = @([[[dictionary objectForKey:@"prestashop:cart:id_currency"] lastObject] intValue]);
	
	cart.id_customer =  @([[[dictionary objectForKey:@"prestashop:cart:id_customer"] lastObject] intValue]);
	
	cart.id_guest =  @([[[dictionary objectForKey:@"prestashop:cart:id_guest"] lastObject] intValue]);
	cart.id_shop =  @([[[dictionary objectForKey:@"prestashop:cart:id_shop"] lastObject] intValue]);
	cart.id_shop_group =  @([[[dictionary objectForKey:@"prestashop:cart:id_shop_group"] lastObject] intValue]);
	cart.secure_key = [[dictionary objectForKey:@"prestashop:cart:secure_key"] lastObject];
	
	//TODO: cart row
	int index = 0;
	for (NSString *id_row in [dictionary objectForKey:@"prestashop:cart:associations:cart_rows:cart_row:id_product"]) {
		
		NSString *id_product = [dictionary objectForKey:@"prestashop:cart:associations:cart_rows:cart_row:id_product"][index];
		NSString *id_product_attribute = [dictionary objectForKey:@"prestashop:cart:associations:cart_rows:cart_row:id_product_attribute"][index];
		NSString *quantity = [dictionary objectForKey:@"prestashop:cart:associations:cart_rows:cart_row:quantity"][index];
		
		NSMutableDictionary *cartRowDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:id_product, @"prestashop:cart:associations:cart_rows:cart_row:id_product",
												  id_product_attribute, @"prestashop:cart:associations:cart_rows:cart_row:id_product_attribute",
												  quantity, @"prestashop:cart:associations:cart_rows:cart_row:quantity", nil];
		
		CartRow *cartRow = [CartRow addUpdateCartRowWhithDictionary:cartRowDictionary];
		[cart addCartRowObject:cartRow];
		index++;
	}
	
	cart.addressDelivery = [Address addressWithId:[cart.id_address_delivery intValue]];
	cart.addressInvoice = [Address addressWithId:[cart.id_address_invoice intValue]];
	cart.customer = [Customer customerWithId:[cart.id_customer intValue]];
	
	[localContext saveToPersistentStoreAndWait];
//	[localContext save:nil];
	
	return cart;
}

+ (NSNumber *)cartPrice {
	double result = 0;
	
	//INFO: may by apply  filter to get only products from the cart
	for (Product *product in [Product findByAttribute:@"is_in_cart" withValue:[NSNumber numberWithBool:YES] andOrderBy:@"price" ascending:YES]) {//[Product findByAttribute:@"is_in_cart" withValue:@"1"]) {
		result += ([product.price doubleValue] * [product.quantity intValue]);
	}
	
	return [NSNumber numberWithDouble:result];
}

+ (void)clearCart {
	//INFO: may by apply  filter to get only products from the cart
	for (Product *product in [Product findByAttribute:@"is_in_cart" withValue:[NSNumber numberWithBool:YES] andOrderBy:@"price" ascending:YES]) {//[Product findByAttribute:@"is_in_cart" withValue:@"1"]) {
		product.is_in_cart = @(NO);
		product.quantity = @(0);
	}
	[[NSManagedObjectContext contextForCurrentThread] saveToPersistentStoreAndWait];

}

+ (NSString *)convertToXML:(Cart *)cart {
	
	NSString *cartRows = @"<cart_rows>";
	for (CartRow *cartRow in cart.cartRow) {
		if (cartRow) {
			NSNumber *id_product = cartRow.id_product;
			NSNumber *id_product_attribute = cartRow.id_product_attribute;
			NSNumber *quantity = cartRow.quantity;
			NSString *cartRow = [NSString stringWithFormat:@""								 
								 "<cart_row>"
								 "<id_product>%@</id_product>"
								 "<id_product_attribute>%@</id_product_attribute>"
								 "<quantity>%@</quantity>"
								 "</cart_row>", id_product, id_product_attribute, quantity];
			
			cartRows = [cartRows stringByAppendingString:cartRow];
		}
		
	}
	cartRows = [cartRows stringByAppendingString:@"</cart_rows>"];
	
	
	NSString *xmlString = [NSString stringWithFormat:@"<prestashop xmlns:xlink=\"http://www.w3.org/1999/xlink\">"
						   "<cart>"
						   "<id></id>"
						   "<id_address_delivery>%@</id_address_delivery>"
						   "<id_address_invoice>%@</id_address_invoice>"
						   "<id_currency>%@</id_currency>"
						   "<id_customer>%@</id_customer>"
						   "<id_guest>0</id_guest>"
						   "<id_lang>2</id_lang>"
						   
						   "<id_shop_group>%@</id_shop_group>"
						   "<id_shop>%@</id_shop>"
						   "<id_carrier>%@</id_carrier>"
						   "<recyclable></recyclable>"
						   "<gift>0</gift>"
						   "<gift_message></gift_message>"
						   "<mobile_theme></mobile_theme>"
						   "<delivery_option></delivery_option>"
						   "<secure_key>%@</secure_key>"
						   "<allow_seperated_package></allow_seperated_package>"
						   "<date_add></date_add>"
						   "<date_upd></date_upd>"
						   
						   
						   "<associations>"
						   "%@"
						   "</associations>"
						   
						   "</cart>"
						   "</prestashop>", cart.id_address_delivery, cart.id_address_invoice, cart.id_currency, cart.id_customer, cart.id_shop_group, cart.id_shop, cart.id_carrier, cart.secure_key, cartRows];
	/*
	 "<cart_rows>"
	 "<cart_row>"
	 "<id_product>1</id_product>"
	 "<id_product_attribute>18</id_product_attribute>"
	 "<quantity>1</quantity>"
	 "</cart_row>"
	 "</cart_rows>"
	 
	 */
	return xmlString;
}


@end
