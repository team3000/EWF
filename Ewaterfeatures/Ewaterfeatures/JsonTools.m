//
//  JsonTools.m
//  Utils
//
//  Created by Adrien Guffens on 10/19/12.
//  Copyright (c) 2012 Adrien Guffens. All rights reserved.
//

#import "JsonTools.h"

@implementation JsonTools

+ (NSDictionary *)getDictionaryFromData:(NSData *)data {
	NSError *error;
	NSDictionary *dico = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
	//NCLog(YES, @"getDictionaryFromData: %@", error);
	return (dico);
}

+ (NSArray *)getArrayFromData:(NSData *)data {
	NSError *error;
	//NCLog(YES, @"data %@", data);
	NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
	return (array);
}

+ (id)getObjectFromData:(NSData *)data {
	NSError *error;
//	NCLog(YES, @"data %@", data);
	id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
	return (object);
}

@end
