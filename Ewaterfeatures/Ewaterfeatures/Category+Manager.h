//
//  Category+Manager.h
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 6/14/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "Category.h"

@interface Category (Manager)

+ (Category *)categoryWithId:(int)id_category;
+ (Category *)addUpdateCategoryWithDictionary:(NSMutableDictionary *)dictionary;

@end
