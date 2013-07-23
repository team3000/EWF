//
//  Image+Manager.m
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 6/14/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "Image+Manager.h"

@implementation Image (Manager)

+ (Image *)imageWithId:(int)id_image {
	
	NSLog(@"%s | id_image: %d", __PRETTY_FUNCTION__, id_image);
	NSManagedObjectContext *localContext = [NSManagedObjectContext defaultContext];//[NSManagedObjectContext contextForCurrentThread];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_image == [c] %d", id_image];
	Image *image = [Image findFirstWithPredicate:predicate inContext:localContext];
	
	if (image) {
		NSLog(@"%s | Image already exist", __PRETTY_FUNCTION__);
	}
	else {
		NSLog(@"%s | Image does not already exist", __PRETTY_FUNCTION__);
		image = [Image createEntity];
		image.id_image = [NSNumber numberWithInt:id_image];
	}
	
	[localContext saveToPersistentStoreAndWait];
	
	return image;
}

@end
