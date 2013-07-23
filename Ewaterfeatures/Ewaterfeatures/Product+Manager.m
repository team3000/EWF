//
//  Product+Manager.m
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 5/31/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "Product+Manager.h"
#import "Image+Manager.h"
#import "Category+Manager.h"
#import "ConventionTools.h"
#import "Image.h"

@implementation Product (Manager)

+ (Product *)productWithId:(int)id_product {
	NSLog(@"%s | id_product: %d", __PRETTY_FUNCTION__, id_product);
	
	NSManagedObjectContext *localContext = [NSManagedObjectContext defaultContext];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_product == [c] %d", id_product];
	Product *product = [Product findFirstWithPredicate:predicate inContext:localContext];
	
	if (product) {
		NSLog(@"%s | Product already exist", __PRETTY_FUNCTION__);
	}
	else {
		NSLog(@"%s | Product does not already exist", __PRETTY_FUNCTION__);
		product = [Product createEntity];
		product.id_product =  @(id_product);
		product.is_in_cart = [NSNumber numberWithBool:NO];
	}
	
	[localContext saveToPersistentStoreAndWait];

//	[localContext save:nil];
//	[localContext saveToPersistentStoreAndWait];
	
	return product;
}


+ (Product *)addUpdateProductWithDictionary:(NSMutableDictionary *)dictionary {
	
	NSManagedObjectContext *localContext = [NSManagedObjectContext defaultContext];
	
//	Product *product = [Product productWithId:[[[dictionary objectForKey:@"prestashop:product:id"] lastObject] intValue]];
//	NSManagedObjectContext *localContext = [NSManagedObjectContext defaultContext];
//	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_product == [c] %d", [[[dictionary objectForKey:@"prestashop:product:id"] lastObject] intValue]];
	Product *product = [Product productWithId:[[[dictionary objectForKey:@"prestashop:product:id"] lastObject] intValue]]; //findFirstWithPredicate:predicate inContext:localContext];
	/*
	if (product) {
		NSLog(@"%s | Product already exist", __PRETTY_FUNCTION__);
	}
	else {
		NSLog(@"%s | Product does not already exist", __PRETTY_FUNCTION__);
		product = [Product createEntity];
		product.id_product =  @([[[dictionary objectForKey:@"prestashop:product:id"] lastObject] intValue]);
		product.is_in_cart = [NSNumber numberWithBool:NO];
	}
	*/
//	[localContext save:nil];
	
	
//	product.availability = [dictionary objectForKey:@"availability"];
	product.id_category_default = @([[[dictionary objectForKey:@"prestashop:product:id_category_default"] lastObject] intValue]);
	product.product_description = [[dictionary objectForKey:@"prestashop:product:description"] lastObject];
	product.name = [[dictionary objectForKey:@"prestashop:product:name"] lastObject];
	product.price = @([[[dictionary objectForKey:@"prestashop:product:price"] lastObject] doubleValue]);
//	product.quantity = @([[dictionary objectForKey:@"prestashop:product:quantity"] intValue]);
	product.reference = [[dictionary objectForKey:@"prestashop:product:reference"] lastObject];
//	product.related_product = [dictionary objectForKey:@"related_product"];
//	product.size = [dictionary objectForKey:@"size"];
//	product.sku = [dictionary objectForKey:@"sku"];
	product.weight = @([[[dictionary objectForKey:@"prestashop:product:weight"] lastObject] doubleValue]);
	product.depth = @([[[dictionary objectForKey:@"prestashop:product:depth"] lastObject] doubleValue]);
	product.active = @([[[dictionary objectForKey:@"prestashop:product:active"] lastObject] boolValue]);
	product.additional_shipping_cost = [[dictionary objectForKey:@"prestashop:product:additional_shipping_cost"] lastObject];;
//	product.category_id = [dictionary objectForKey:@"category_id"];

	product.id_stock_available = @([[[dictionary objectForKey:@"prestashop:product:associations:stock_availables:stock_available:id"] lastObject] boolValue]);
	product.available_for_order = @([[[dictionary objectForKey:@"prestashop:product:available_for_order"] lastObject] intValue]);
	product.date_add = [ConventionTools getDate:[[dictionary objectForKey:@"prestashop:product:date_add"] lastObject] withFormat:@"yyyy-MM-dd HH:mm:ss"];
	product.date_upd = [ConventionTools getDate:[[dictionary objectForKey:@"prestashop:product:date_upd"] lastObject] withFormat:@"yyyy-MM-dd HH:mm:ss"];
	product.height = @([[[dictionary objectForKey:@"prestashop:product:height"] lastObject] doubleValue]);
	product.id_default_image = @([[[dictionary objectForKey:@"prestashop:product:id_default_image"] lastObject] intValue]);
	product.type = [[dictionary objectForKey:@"prestashop:product:type"] lastObject];
	product.width = @([[[dictionary objectForKey:@"prestashop:product:width"] lastObject] doubleValue]);
	
//	product.image.image_id = @([[[dictionary objectForKey:@"prestashop:product:id_default_image"] lastObject] intValue]);
	
	for (NSString *value in [dictionary objectForKey:@"prestashop:product:associations:images:image:id"]) {
		Image *image = [Image imageWithId:[value intValue]];
		image.id_image = [NSNumber numberWithInt:[value intValue]];
		image.id_product = product.id_product;
		[product addImageObject:image];
	}
	
	product.default_category = [Category categoryWithId: [product.id_category_default intValue]];
	
	[localContext saveToPersistentStoreAndWait];
//	[localContext save:nil];

	return product;
}

+ (int)quantityOfProductsInCart {
	int result = 0;
	
	//INFO: may by apply  filter to get only products from the cart
	for (Product *product in [Product findByAttribute:@"is_in_cart" withValue:[NSNumber numberWithBool:YES] andOrderBy:@"price" ascending:YES]) {//[Product findByAttribute:@"is_in_cart" withValue:@"1"]) {
		result += (1 * [product.quantity intValue]);
	}
	
	return result;
}

+ (int)quantityOfProducts {
	int result = 0;
	
	//INFO: may by apply  filter to get only products from the cart
	for (Category *category in [Category findByAttribute:@"id_parent" withValue:[NSNumber numberWithInt:2] andOrderBy:@"id_category" ascending:YES]) {//[Product findByAttribute:@"is_in_cart" withValue:@"1"]) {
		if (category.id_category != [NSNumber numberWithInt:-1])
			result += (1 * [category.nb_products_recursive intValue]);
	}
	
	return result;
}


@end
