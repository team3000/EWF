//
//  Employee+Manager.m
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 6/18/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "Employee+Manager.h"
#import "ConventionTools.h"

@implementation Employee (Manager)

+ (Employee *)employeeWithId:(int)id_employee {
	NSLog(@"%s | id_employee: %d", __PRETTY_FUNCTION__, id_employee);
	
	NSManagedObjectContext *localContext = [NSManagedObjectContext defaultContext];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_employee == [c] %d", id_employee];
	Employee *employee = [Employee findFirstWithPredicate:predicate inContext:localContext];
	
	if (employee) {
		NSLog(@"%s | Employee already exist", __PRETTY_FUNCTION__);
	}
	else {
		NSLog(@"%s | Employee does not already exist", __PRETTY_FUNCTION__);
		employee = [Employee createEntity];
		employee.id_employee =  @(id_employee);
	}
	
//	[localContext save:nil];
	[localContext saveToPersistentStoreAndWait];

	
	return employee;
}

+ (Employee *)addUpdateEmployeeWithDictionary:(NSDictionary *)dictionary {

	NSManagedObjectContext *localContext = [NSManagedObjectContext defaultContext];
	
	Employee *employee = [Employee employeeWithId:[[[dictionary objectForKey:@"prestashop:employee:id"] lastObject] intValue]];
	
	employee.id_lang = @([[[dictionary objectForKey:@"prestashop:employee:id_lang"] lastObject] intValue]);
	employee.last_passwd_gen = [ConventionTools getDate:[[dictionary objectForKey:@"prestashop:employee:last_passwd_gen"] lastObject] withFormat:@"yyyy-MM-dd HH:mm:ss"];
	employee.stats_date_from = [ConventionTools getDate:[[dictionary objectForKey:@"prestashop:employee:stats_date_from"] lastObject] withFormat:@"yyyy-MM-dd"];
	employee.stats_date_to = [ConventionTools getDate:[[dictionary objectForKey:@"prestashop:employee:stats_date_to"] lastObject] withFormat:@"yyyy-MM-dd"];
	
	employee.passwd = [[dictionary objectForKey:@"prestashop:employee:passwd"] lastObject];
	employee.lastname = [[dictionary objectForKey:@"prestashop:employee:lastname"] lastObject];
	employee.firstname = [[dictionary objectForKey:@"prestashop:employee:firstname"] lastObject];
	employee.email = [[dictionary objectForKey:@"prestashop:employee:email"] lastObject];
	
	employee.active = @([[[dictionary objectForKey:@"prestashop:employee:active"] lastObject] boolValue]);

	employee.id_profile = @([[[dictionary objectForKey:@"prestashop:employee:id_profile"] lastObject] intValue]);
	
//	[localContext save:nil];
	[localContext saveToPersistentStoreAndWait];

	
	return employee;
}


@end
