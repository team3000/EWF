//
//  Category+Manager.m
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 6/14/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "Category+Manager.h"
#import "Product+Manager.h"

#import "ConventionTools.h"

@implementation Category (Manager)

+ (Category *)categoryWithId:(int)id_category {
	NSLog(@"%s | id_category: %d", __PRETTY_FUNCTION__, id_category);
	
	NSManagedObjectContext *localContext = [NSManagedObjectContext defaultContext];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_category == [c] %d", id_category];
	Category *category = [Category findFirstWithPredicate:predicate inContext:localContext];
	
	if (category) {
		NSLog(@"%s | Category already exist", __PRETTY_FUNCTION__);
	}
	else {
		NSLog(@"%s | Category does not already exist", __PRETTY_FUNCTION__);
		category = [Category createEntity];
		category.id_category =  @(id_category);
	}
	
//	[localContext save:nil];
	[localContext saveToPersistentStoreAndWait];
	
	return category;
}

+ (Category *)addUpdateCategoryWithDictionary:(NSMutableDictionary *)dictionary {
	
	NSManagedObjectContext *localContext = [NSManagedObjectContext defaultContext];
	
	Category *category = [Category categoryWithId:[[[dictionary objectForKey:@"prestashop:category:id"] lastObject] intValue]];
	
	category.name = [[dictionary objectForKey:@"prestashop:category:name"] lastObject];
	
	category.active = @([[[dictionary objectForKey:@"prestashop:category:active"] lastObject] boolValue]);
	category.category_description = [[dictionary objectForKey:@"prestashop:category:description"] lastObject];
	category.id_shop_default = @([[[dictionary objectForKey:@"prestashop:category:id_shop_default"] lastObject] intValue]);
	category.nb_products_recursive = @([[[dictionary objectForKey:@"prestashop:category:nb_products_recursive"] lastObject] intValue]);
	
	category.date_add = [ConventionTools getDate:[[dictionary objectForKey:@"prestashop:category:date_add"] lastObject] withFormat:@"yyyy-MM-dd HH:mm:ss"];
	category.date_upd = [ConventionTools getDate:[[dictionary objectForKey:@"prestashop:category:date_upd"] lastObject] withFormat:@"yyyy-MM-dd HH:mm:ss"];
	category.is_root_category = @([[[dictionary objectForKey:@"prestashop:category:is_root_category"] lastObject] boolValue]);
	
	category.id_parent = @([[[dictionary objectForKey:@"prestashop:category:id_parent"] lastObject] intValue]);
	
	
	for (NSString *value in [dictionary objectForKey:@"prestashop:category:associations:products:product:id"]) {
		
		Product *product = [Product productWithId:[value intValue]];
		[category addProductObject:product];
	}
	//TODO: complete
	
//	[localContext save:Nil];
	[localContext saveToPersistentStoreAndWait];
	
	return category;
}

@end
