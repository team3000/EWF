//
//  Country+Manager.m
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 6/17/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "Country+Manager.h"

@implementation Country (Manager)

+ (Country *)countryWithId:(int)id_country {
	NSLog(@"%s | id_country: %d", __PRETTY_FUNCTION__, id_country);
	
	NSManagedObjectContext *localContext = [NSManagedObjectContext defaultContext];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_country == [c] %d", id_country];
	Country *country = [Country findFirstWithPredicate:predicate inContext:localContext];
	
	if (country) {
		NSLog(@"%s | Category already exist", __PRETTY_FUNCTION__);
	}
	else {
		NSLog(@"%s | Category does not already exist", __PRETTY_FUNCTION__);
		country = [Country createEntity];
		country.id_country =  @(id_country);
	}
	
//	[localContext save:nil];
	[localContext saveToPersistentStoreAndWait];
	
	return country;
}

+ (Country *)addUpdateCountryWithDictionary:(NSMutableDictionary *)dictionary {
	NSManagedObjectContext *localContext = [NSManagedObjectContext defaultContext];
	Country *country = [Country countryWithId:[[[dictionary objectForKey:@"prestashop:country:id"] lastObject] intValue]];
	
	country.id_zone = @([[[dictionary objectForKey:@"prestashop:country:id_zone"] lastObject] intValue]);
	country.id_currency = @([[[dictionary objectForKey:@"prestashop:country:id_currency"] lastObject] intValue]);
	
	country.call_prefix = [[dictionary objectForKey:@"prestashop:country:call_prefix"] lastObject];
	country.iso_code = [[dictionary objectForKey:@"prestashop:country:iso_code"] lastObject];
	
	country.active = @([[[dictionary objectForKey:@"prestashop:country:active"] lastObject] boolValue]);
	country.contains_states = @([[[dictionary objectForKey:@"prestashop:country:contains_states"] lastObject] boolValue]);
	country.need_identification_number = @([[[dictionary objectForKey:@"prestashop:country:need_identification_number"] lastObject] boolValue]);
	country.need_zip_code = @([[[dictionary objectForKey:@"prestashop:country:need_zip_code"] lastObject] boolValue]);
	
	country.zip_code_format = [[dictionary objectForKey:@"prestashop:country:zip_code_format"] lastObject];
	
	country.display_tax_label = @([[[dictionary objectForKey:@"prestashop:country:display_tax_label"] lastObject] boolValue]);
	
	country.name = [[dictionary objectForKey:@"prestashop:country:name"] lastObject];
	
//	[localContext save:nil];
	[localContext saveToPersistentStoreAndWait];

	return  country;
}

@end
