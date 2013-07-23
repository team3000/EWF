//
//  State+Manager.h
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 6/26/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CountryState.h"

@interface CountryState (Manager)

+ (CountryState *)stateWithId:(int)id_state;
+ (CountryState *)addUpdateStateWithDictionary:(NSMutableDictionary *)dictionary;


@end
