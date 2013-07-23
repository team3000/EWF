//
//  Order+Manager.m
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 6/15/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "Order+Manager.h"
#import "ConventionTools.h"
#import "OrderRow+Manager.h"

#import "Address+Manager.h"

#import "Cart+Manager.h"

#import "Customer+Manager.h"

#import "OrderState+Manager.h"

@implementation Order (Manager)

+ (Order *)orderWithId:(int)id_order {
	NSLog(@"%s | id_order: %d", __PRETTY_FUNCTION__, id_order);
	
	NSManagedObjectContext *localContext = [NSManagedObjectContext defaultContext];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_order == %@", @(id_order)];
	Order *order = [Order findFirstWithPredicate:predicate inContext:localContext];
	
	if (order) {
		NSLog(@"%s | Order already exist", __PRETTY_FUNCTION__);
	}
	else {
		NSLog(@"%s | Order does not already exist", __PRETTY_FUNCTION__);
		Order *order = [Order createEntity];
		order.id_order = @(id_order);
	}
	
	NSError *error = nil;
	[localContext saveToPersistentStoreAndWait];//save:&error];
	if (error) {
		NSLog(@"%s | error: %@", __PRETTY_FUNCTION__, error);
	}
	
	return order;
}


+ (Order *)addUpdateOrderWhithDictionary:(NSMutableDictionary *)dictionary {
	NSManagedObjectContext *localContext = [NSManagedObjectContext defaultContext];
	
	Order *order = [Order orderWithId:[[[dictionary objectForKey:@"prestashop:order:id"] lastObject] intValue]];
	if (order == nil) {
		order = [Order findFirstByAttribute:@"id_order" withValue:@([[[dictionary objectForKey:@"prestashop:order:id"] lastObject] intValue])];//createEntity];
		order.id_order = @([[[dictionary objectForKey:@"prestashop:order:id"] lastObject] intValue]);
	}
	NSLog(@"%s | order: %@", __PRETTY_FUNCTION__, [order description]);
	
	order.carrier_tax_rate = @([[[dictionary objectForKey:@"prestashop:order:carrier_tax_rate"] lastObject] doubleValue]);
	
	order.conversion_rate = @([[[dictionary objectForKey:@"prestashop:order:conversion_rate"] lastObject] doubleValue]);
	order.current_state = @([[[dictionary objectForKey:@"prestashop:order:current_state"] lastObject] intValue]);
	
	order.date_add = [ConventionTools getDate:[[dictionary objectForKey:@"prestashop:order:date_add"] lastObject] withFormat:@"yyyy-MM-dd HH:mm:ss"];
	order.date_upd = [ConventionTools getDate:[[dictionary objectForKey:@"prestashop:order:date_upd"] lastObject] withFormat:@"yyyy-MM-dd HH:mm:ss"];
	order.delivery_date = [ConventionTools getDate:[[dictionary objectForKey:@"prestashop:order:delivery_date"] lastObject] withFormat:@"yyyy-MM-dd HH:mm:ss"];
	
	order.gift = @([[[dictionary objectForKey:@"prestashop:order:gift"] lastObject] boolValue]);
	
	order.id_address_delivery = @([[[dictionary objectForKey:@"prestashop:order:id_address_delivery"] lastObject] intValue]);
	order.id_address_invoice = @([[[dictionary objectForKey:@"prestashop:order:id_address_invoice"] lastObject] intValue]);
	order.id_cart = @([[[dictionary objectForKey:@"prestashop:order:id_cart"] lastObject] intValue]);
	
	order.id_customer = @([[[dictionary objectForKey:@"prestashop:order:id_customer"] lastObject] intValue]);
	order.id_shop = @([[[dictionary objectForKey:@"prestashop:order:id_shop"] lastObject] intValue]);
	
	order.invoice_date = [ConventionTools getDate:[[dictionary objectForKey:@"prestashop:order:invoice_date"] lastObject] withFormat:@"yyyy-MM-dd HH:mm:ss"];
	
	order.module = [[dictionary objectForKey:@"prestashop:order:module"] lastObject];
	order.payment = [[dictionary objectForKey:@"prestashop:order:payment"] lastObject];
	order.reference = [[dictionary objectForKey:@"prestashop:order:reference"] lastObject];
	order.secure_key = [[dictionary objectForKey:@"prestashop:order:secure_key"] lastObject];
	
	order.total_discounts = @([[[dictionary objectForKey:@"prestashop:order:total_discounts"] lastObject] doubleValue]);
	order.total_discounts_tax_incl = @([[[dictionary objectForKey:@"prestashop:order:total_discounts_tax_incl"] lastObject] doubleValue]);
	
	order.total_paid = @([[[dictionary objectForKey:@"prestashop:order:total_paid"] lastObject] doubleValue]);
	order.total_paid_real = @([[[dictionary objectForKey:@"prestashop:order:total_paid_real"] lastObject] doubleValue]);
	
	
	order.total_paid_tax_excl = @([[[dictionary objectForKey:@"prestashop:order:total_paid_tax_excl"] lastObject] doubleValue]);
	order.total_paid_tax_incl = @([[[dictionary objectForKey:@"prestashop:order:total_paid_tax_incl"] lastObject] doubleValue]);
	
	order.total_wrapping_tax_excl = @([[[dictionary objectForKey:@"prestashop:order:total_wrapping_tax_excl"] lastObject] doubleValue]);
	order.total_wrapping_tax_incl = @([[[dictionary objectForKey:@"prestashop:order:total_wrapping_tax_incl"] lastObject] doubleValue]);
	
	order.valid = @([[[dictionary objectForKey:@"prestashop:order:valid"] lastObject] boolValue]);
	
	//NSLog(@"%s | order: %@", __PRETTY_FUNCTION__, [order description]);
	
	
	//TODO: order_row
	int index = 0;
	for (NSString *id_order_row in [dictionary objectForKey:@"prestashop:order:associations:order_rows:order_row:id"]) {
		
		
		NSMutableDictionary *orderRowDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[dictionary objectForKey:
																									   @"prestashop:order:associations:order_rows:order_row:id"][index], @"prestashop:order:associations:order_rows:order_row:id", [dictionary objectForKey:@"prestashop:order:associations:order_rows:order_row:product_id"][index], @"prestashop:order:associations:order_rows:order_row:product_id", [dictionary objectForKey:@"prestashop:order:associations:order_rows:order_row:product_attribute_id"][index], @"prestashop:order:associations:order_rows:order_row:product_attribute_id", [dictionary objectForKey:@"prestashop:order:associations:order_rows:order_row:product_quantity"][index], @"prestashop:order:associations:order_rows:order_row:product_quantity", [dictionary objectForKey:@"prestashop:order:associations:order_rows:order_row:product_name"][index], @"prestashop:order:associations:order_rows:order_row:product_name", [dictionary objectForKey:@"prestashop:order:associations:order_rows:order_row:product_price"][index], @"prestashop:order:associations:order_rows:order_row:product_price", nil];
		
		OrderRow *orderRow = [OrderRow addUpdateOrderRowWhithDictionary:orderRowDictionary];
		
		NSLog(@"%s | orderRow: %@", __PRETTY_FUNCTION__, [orderRow description]);
		
		if (orderRow == nil) {
			OrderRow *orderRow = [OrderRow createEntity];//findFirstByAttribute:@"id_order_row" withValue:@([[dictionary objectForKey:@"prestashop:order:associations:order_rows:order_row:id"][index] intValue])];//createEntity];//orderRowWithId:[[dictionary objectForKey:@"prestashop:order:associations:order_rows:order_row:id"][index] intValue]];
			
			orderRow.id_order_row = @([[dictionary objectForKey:@"prestashop:order:associations:order_rows:order_row:id"][index] intValue]);
			orderRow.product_attribute_id = @([[dictionary objectForKey:@"prestashop:order:associations:order_rows:order_row:product_attribute_id"][index] intValue]);
			orderRow.product_id =  @([[dictionary objectForKey:@"prestashop:order:associations:order_rows:order_row:product_id"][index] intValue]);
			orderRow.product_name =  [dictionary objectForKey:@"prestashop:order:associations:order_rows:order_row:product_name"][index];
			orderRow.product_price =  @([[dictionary objectForKey:@"prestashop:order:associations:order_rows:order_row:product_price"][index] doubleValue]);
			orderRow.product_quantity =  @([[dictionary objectForKey:@"prestashop:order:associations:order_rows:order_row:product_quantity"][index] intValue]);
			[order addOrderRowObject:orderRow];
		}
		else
			[order addOrderRowObject:orderRow];
		
		index++;
	}
	
	
	order.addressDelivery = [Address addressWithId:[order.id_address_delivery intValue]];
	order.addressInvoice = [Address addressWithId:[order.id_address_invoice intValue]];
	
	order.cart = [Cart cartWithId:[order.id_cart intValue]];
	
	order.orderState = [OrderState orderStateWithId:[order.current_state intValue]];
	
	order.customer = [Customer customerWithId:[order.id_customer intValue]];
	
	//NSLog(@"%s | %@", __PRETTY_FUNCTION__, [order description]);
	
//	[localContext save:nil];
	[localContext saveToPersistentStoreAndWait];
	
	return order;
}

+ (NSString *)convertToXML:(Order *)order {
	
	NSString *orderRows = @"<order_rows>";//[NSString stringWithFormat:@""];
	
	
	for (OrderRow *orderRow in order.orderRow) {
		if (orderRow) {
			NSNumber *product_id = orderRow.product_id;
			NSNumber *product_attribute_id = orderRow.product_attribute_id;
			NSNumber *product_quantity = orderRow.product_quantity;
			NSString *product_name = orderRow.product_name;
			NSNumber *product_price = orderRow.product_price;
			NSString *orderRow = [NSString stringWithFormat:@"<order_row>"
								  "<id></id>"
								  "<product_id>%@</product_id>"
								  "<product_name>%@</product_name>"
								  "<product_attribute_id>%@</product_attribute_id>"
								  "<product_quantity>%@</product_quantity>"

								  "<product_price>%@</product_price>"
								  "</order_row>", product_id, product_name, product_attribute_id, product_quantity, product_price];
			orderRows = [orderRows stringByAppendingString:orderRow];
		}
	}
	
	orderRows = [orderRows stringByAppendingString:@"</order_rows>"];
	
	NSString *xmlString = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
						   "<prestashop xmlns:xlink=\"http://www.w3.org/1999/xlink\">"
						   "<order>"
						  "<id></id>"
						   "<id_address_delivery>%@</id_address_delivery>"
						   "<id_address_invoice>%@</id_address_invoice>"
						   "<id_cart>%@</id_cart>"
						   "<id_currency>%@</id_currency>"
						   "<id_lang>%@</id_lang>"
						   "<id_customer>%@</id_customer>"
						   "<id_carrier>%@</id_carrier>"
						   "<id_shop>%@</id_shop>"
						   "<id_shop_group>%@</id_shop_group>"
						   
						   "<secure_key>%@</secure_key>"
						   
						   "<invoice_number></invoice_number>"
						   "<delivery_number></delivery_number>"
						   "<valid>1</valid>"
						   "<current_state></current_state>"
						   
						   "<recyclable>1</recyclable>"
						   "<total_discounts>0</total_discounts>"
						   
						   "<module>%@</module>"
						   
						   "<gift>0</gift>"
						   "<gift_message></gift_message>"
						   "<mobile_theme></mobile_theme>"
						   "<date_add></date_add>"
						   "<date_upd></date_upd>"
						   
						   "<payment>%@</payment>"
						   
						   
						   "<total_paid>%@</total_paid>"
						   "<total_paid_real>%@</total_paid_real>"
						   "<total_products>%@</total_products>"
						   "<total_products_wt>%@</total_products_wt>"
						   "<conversion_rate>%@</conversion_rate>"
						   
						   
						   "<total_shipping>2.20</total_shipping>"
						   "<total_wrapping></total_wrapping>"
						   "<shipping_number></shipping_number>"
						   
						   
						   "<associations>"
						   "%@"
						   "</associations>"
						   
						   
						   "</order>"
						   "</prestashop>", order.id_address_delivery, order.id_address_invoice, order.id_cart, order.id_currency, order.id_lang, order.id_customer, order.id_carrier, order.id_shop, order.id_shop_group, order.secure_key, order.module, order.payment, order.total_paid, order.total_paid_real, order.total_products, order.total_products_wt, order.conversion_rate, orderRows];
	
	/*
	 order.id_address_delivery, order.id_address_invoice, order.id_cart, order.id_currency, order.id_lang, order.id_customer, order.id_carrier, order.id_shop, order.id_shop_group, order.secure_key, order.module, order.payment, [NSNumber numberWithDouble:139.24] , [NSNumber numberWithDouble:0.0], [NSNumber numberWithDouble:124.58], order.total_products_wt, order.conversion_rate, orderRows];
	 */
	
	/*
	 
	 
	 "<associations>"
	 "<order_rows>"
	 "<order_row>"
	 "<id></id>"
	 "<product_id>1</product_id>"
	 "<product_attribute_id>18</product_attribute_id>"
	 "<product_quantity>1</product_quantity>"
	 "<product_name>iPod Nano</product_name>"
	 "<product_price>265.8</product_price>"
	 "</order_row>"
	 "</order_rows>"
	 "</associations>"
	 */
	
	return xmlString;
}


@end
