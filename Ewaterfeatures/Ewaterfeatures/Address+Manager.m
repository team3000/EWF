//
//  Address+Manager.m
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 6/15/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "Address+Manager.h"
#import "ConventionTools.h"

#import "Customer+Manager.h"
#import "Customer.h"

#import "Country+Manager.h"
#import "Country.h"

#import "CountryState+Manager.h"
#import "CountryState.h"

#import "Employee.h"

@implementation Address (Manager)

+ (Address *)addressWithId:(int)id_address {
	NSLog(@"%s | id_address: %d", __PRETTY_FUNCTION__, id_address);
	
	NSManagedObjectContext *localContext = [NSManagedObjectContext defaultContext];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_address == [c] %d", id_address];
	Address *address = [Address findFirstWithPredicate:predicate inContext:localContext];
	
	if (address) {
		NSLog(@"%s | Address already exist", __PRETTY_FUNCTION__);
	}
	else {
		NSLog(@"%s | Address does not already exist", __PRETTY_FUNCTION__);
		address = [Address createEntity];
		address.id_address =  @(id_address);
	}
	
	[localContext saveToPersistentStoreAndWait];
	
	return address;
}

+ (Address *)addressForCustomer:(Customer *)customer {
	Address *address = [[Address findByAttribute:@"id_customer" withValue:customer.id_customer] lastObject];
	
	return address;
}

/*
+ (Address *)addressForEmployee:(Employee *)employee {
	Address *address = [[Address findByAttribute:@"id_employee" withValue:employee.id_employee] lastObject];
	
	return address;
}
*/
/*
 TODO:
 link with:
 - customer [OK]
 - country [OK]
 */

+ (Address *)addUpdateAddressWhithDictionary:(NSMutableDictionary *)dictionary {
	
	NSManagedObjectContext *localContext = [NSManagedObjectContext defaultContext];
	
	Address *address = [Address addressWithId:[[[dictionary objectForKey:@"prestashop:address:id"] lastObject] intValue]];

	
	
	address.address1 = [[dictionary objectForKey:@"prestashop:address:address1"] lastObject];
	address.address2 = [[dictionary objectForKey:@"prestashop:address:address2"] lastObject];
	address.alias = [[dictionary objectForKey:@"prestashop:address:alias"] lastObject];
	address.city = [[dictionary objectForKey:@"prestashop:address:city"] lastObject];
	address.date_add = [ConventionTools getDate:[[dictionary objectForKey:@"prestashop:address:date_add"] lastObject] withFormat:@"yyyy-MM-dd HH:mm:ss"];
	address.date_upd = [ConventionTools getDate:[[dictionary objectForKey:@"prestashop:address:date_upd"] lastObject] withFormat:@"yyyy-MM-dd HH:mm:ss"];

	address.deleted = @([[[dictionary objectForKey:@"prestashop:address:deleted"] lastObject] boolValue]);
	address.firstname = [[dictionary objectForKey:@"prestashop:address:firstname"] lastObject];
	address.lastname = [[dictionary objectForKey:@"prestashop:address:lastname"] lastObject];

	
	address.id_country = @([[[dictionary objectForKey:@"prestashop:address:id_country"] lastObject] intValue]);
	address.id_customer = @([[[dictionary objectForKey:@"prestashop:address:id_customer"] lastObject] intValue]);
	address.id_state = @([[[dictionary objectForKey:@"prestashop:address:id_state"] lastObject] intValue]);
	
	address.phone = [[dictionary objectForKey:@"prestashop:address:phone"] lastObject];
	address.phone_mobile = [[dictionary objectForKey:@"prestashop:address:phone_mobile"] lastObject];
	address.postcode = [[dictionary objectForKey:@"prestashop:address:postcode"] lastObject];
	
	address.compagny = [[dictionary objectForKey:@"prestashop:address:compagny"] lastObject];
	
	address.other = [[dictionary objectForKey:@"prestashop:address:other"] lastObject];
	
	address.customer = [Customer customerWithId:[address.id_customer intValue]];
	address.country = [Country countryWithId:[address.id_country intValue]];
	
	address.countryState = [CountryState stateWithId:[address.id_state intValue]];
	
	[localContext saveToPersistentStoreAndWait];
	
	return address;
}

+ (NSString *)convertToXML:(Address *)address {
	NSString *xmlString = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
						   "<prestashop xmlns:xlink=\"http://www.w3.org/1999/xlink\">"
						   "<address>"
						   "<id></id>"
						   
						   "<id_customer>%@</id_customer>"
						   
//						   "<id_manufacturer></id_manufacturer>"
//						   "<id_supplier></id_supplier>"
//						   "<id_warehouse></id_warehouse>"
						   
						   "<id_country>%@</id_country>"
						   "<id_state>%@</id_state>"
						   "<alias>%@</alias>"
						   "<compagny>%@</compagny>"
						   "<lastname>%@</lastname>"
						   "<firstname>%@</firstname>"

//						   "<vat_number></vat_number>"
						   
						   "<address1>%@</address1>"
						   "<address2>%@</address2>"
						   "<postcode>%@</postcode>"
						   "<city>%@</city>"
						   
						   "<other>%@</other>"
						   
						   "<phone>%@</phone>"
						   "<phone_mobile>%@</phone_mobile>"

//						   "<dni></dni>"
//						   "<deleted>/deleted>"
						   
						   "</address>"
						   "</prestashop>", address.id_customer, address.id_country, address.id_state, address.alias, address.compagny, address.lastname, address.firstname, address.address1, address.address2, address.postcode, address.city, address.other, address.phone, address.phone_mobile];
	return xmlString;
}

@end
