//
//  JsonTools.h
//  Utils
//
//  Created by Adrien Guffens on 10/19/12.
//  Copyright (c) 2012 Adrien Guffens. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 JsonTools is a static class to manipulate json data
 */
@interface JsonTools : NSObject

/**
 Extract data to a hash table
 @param data bites array
 @return hash table from the input data
 */
+ (NSDictionary *)getDictionaryFromData:(NSData *)data;
/**
 Extract data to array
 @param data bites array
 @return array from the input data
 */
+ (NSArray *)getArrayFromData:(NSData *)data;
/**
 Extract data to pointer object
 @param data bites array
 @return pointer object from the input data
 */
+ (id)getObjectFromData:(NSData *)data;

@end
