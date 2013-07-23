//
//  State+Manager.m
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 6/26/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "CountryState+Manager.h"

@implementation CountryState (Manager)

+ (CountryState *)stateWithId:(int)id_state {
	NSLog(@"%s | id_state: %d", __PRETTY_FUNCTION__, id_state);
	
	NSManagedObjectContext *localContext = [NSManagedObjectContext defaultContext];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_state == [c] %d", id_state];
	CountryState *state = [CountryState findFirstWithPredicate:predicate inContext:localContext];
	
	if (state) {
		NSLog(@"%s | CountryState already exist", __PRETTY_FUNCTION__);
	}
	else {
		NSLog(@"%s | CountryState does not already exist", __PRETTY_FUNCTION__);
		state = [CountryState createEntity];
		state.id_state =  @(id_state);
//		[localContext save:nil];
	}
	[localContext saveToPersistentStoreAndWait];
	
	return state;
}

+ (CountryState *)addUpdateStateWithDictionary:(NSMutableDictionary *)dictionary {
	NSManagedObjectContext *localContext = [NSManagedObjectContext defaultContext];
	
	CountryState *state = [CountryState stateWithId:[[[dictionary objectForKey:@"prestashop:state:id"] lastObject] intValue]];
	
	state.name = [[dictionary objectForKey:@"prestashop:state:name"] lastObject];
	
	state.active = @([[[dictionary objectForKey:@"prestashop:state:active"] lastObject] boolValue]);
	state.id_zone = @([[[dictionary objectForKey:@"prestashop:state:id_zone"] lastObject] intValue]);
	
	state.iso_code = [[dictionary objectForKey:@"prestashop:state:iso_code"] lastObject];
	
//	[localContext save:Nil];
	[localContext saveToPersistentStoreAndWait];

	
	return state;
}


@end
