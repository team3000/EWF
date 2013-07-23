//
//  Customer+Manager.m
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 6/14/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "Customer+Manager.h"
#import "ConventionTools.h"

@implementation Customer (Manager)

+ (Customer *)customerWithId:(int)id_customer {
	NSLog(@"%s | id_customer: %d", __PRETTY_FUNCTION__, id_customer);
	
	NSManagedObjectContext *localContext = [NSManagedObjectContext defaultContext];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_customer == [c] %d", id_customer];
	Customer *customer = [Customer findFirstWithPredicate:predicate inContext:localContext];
	
	if (customer) {
		NSLog(@"%s | Category already exist", __PRETTY_FUNCTION__);
	}
	else {
		NSLog(@"%s | Category does not already exist", __PRETTY_FUNCTION__);
		customer = [Customer createEntity];
		customer.id_customer =  @(id_customer);
	}
	
//	[localContext save:nil];
	[localContext saveToPersistentStoreAndWait];
	
	
	return customer;
}

/*
 
 TODO:
 - gender
 
 */

+ (Customer *)addUpdateCustomerWithDictionary:(NSDictionary *)dictionary {
	NSManagedObjectContext *localContext = [NSManagedObjectContext defaultContext];
	
	Customer *customer = [Customer customerWithId:[[[dictionary objectForKey:@"prestashop:customer:id"] lastObject] intValue]];
	
	customer.secure_key = [[dictionary objectForKey:@"prestashop:customer:secure_key"] lastObject];
	customer.deleted = @([[[dictionary objectForKey:@"prestashop:customer:deleted"] lastObject] boolValue]);

	customer.lastname = [[dictionary objectForKey:@"prestashop:customer:lastname"] lastObject];
	customer.firstname = [[dictionary objectForKey:@"prestashop:customer:firstname"] lastObject];

	customer.email = [[dictionary objectForKey:@"prestashop:customer:email"] lastObject];
	
	customer.id_gender = @([[[dictionary objectForKey:@"prestashop:customer:id_gender"] lastObject] intValue]);
	
	customer.birthday = [ConventionTools getDate:[[dictionary objectForKey:@"prestashop:customer:birthday"] lastObject] withFormat:@"yyyy-MM-dd"];
	
	customer.newsletter = @([[[dictionary objectForKey:@"prestashop:customer:newsletter"] lastObject] boolValue]);
	
	customer.website = [[dictionary objectForKey:@"prestashop:customer:website"] lastObject];
	customer.company = [[dictionary objectForKey:@"prestashop:customer:company"] lastObject];
	customer.siret = [[dictionary objectForKey:@"prestashop:customer:siret"] lastObject];
	
	customer.active = @([[[dictionary objectForKey:@"prestashop:customer:active"] lastObject] boolValue]);

	customer.is_guest = @([[[dictionary objectForKey:@"prestashop:customer:is_guest"] lastObject] boolValue]);

	customer.date_add = [ConventionTools getDate:[[dictionary objectForKey:@"prestashop:customer:date_add"] lastObject] withFormat:@"yyyy-MM-dd HH:mm:ss"];
	customer.date_upd = [ConventionTools getDate:[[dictionary objectForKey:@"prestashop:customer:date_upd"] lastObject] withFormat:@"yyyy-MM-dd HH:mm:ss"];

	customer.optin = @([[[dictionary objectForKey:@"prestashop:customer:optin"] lastObject] boolValue]);
	
	customer.passwd = [[dictionary objectForKey:@"prestashop:customer:passwd"] lastObject];
	
//	[localContext save:nil];
	[localContext saveToPersistentStoreAndWait];

	
	return customer;
}

+ (NSString *)convertToXML:(Customer *)customer {
	
	NSString *xmlString = [NSString stringWithFormat:@"<prestashop xmlns:xlink=\"http://www.w3.org/1999/xlink\">"
						   "<customer>"
						   "<id></id>"
						   "<id_default_group>3</id_default_group>"
						   "<id_lang>2</id_lang>"
						   
						   
//						   "<newsletter_date_add></newsletter_date_add>"
//						   "<last_passwd_gen></last_passwd_gen>"
						   
						   
//						   "<secure_key></secure_key>"
//						   "<deleted></deleted>"
						   "<passwd>%@</passwd>"
						   "<lastname>%@</lastname>"
						   "<firstname>%@</firstname>"
						   "<email>%@</email>"
						   "<id_gender>%@</id_gender>"
//						   "<birthday></birthday>"

						   
						   "<newsletter>%@</newsletter>"
						   "<optin>%@</optin>"

						   "<active>1</active>"
						   
//						   "<website></website>"
//						   "<company></company>"
//						   "<siret></siret>"
//						   "<ape></ape>"

						   
//						   "<outstanding_allow_amount></outstanding_allow_amount>"
//						   "<show_public_prices>0</show_public_prices>"
//						   "<id_risk></id_risk>"
//						   "<max_payment_days></max_payment_days>"
//						   "<active></active>"
//						   "<ape></ape>"

						   
//						   "<is_guest>0</is_guest>"

						   "<id_shop_group>1</id_shop_group>"
						   "<id_shop>1</id_shop>"
						   
//						   "<date_add></date_add>"
//						   "<date_upd></date_upd>"
						   
		
						   
						   "</customer>"
						   "</prestashop>", customer.passwd, customer.lastname, customer.firstname, customer.email, customer.id_gender, customer.newsletter, customer.optin];

	return xmlString;
}


@end

