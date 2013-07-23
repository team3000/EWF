//
//  Country+Manager.h
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 6/17/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "Country.h"

@interface Country (Manager)

+ (Country *)countryWithId:(int)id_country;
+ (Country *)addUpdateCountryWithDictionary:(NSMutableDictionary *)dictionary;


@end
