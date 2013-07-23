//
//  CountryState.h
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 6/26/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CountryState : NSManagedObject

@property (nonatomic, retain) NSNumber * id_state;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * active;
@property (nonatomic, retain) NSNumber * id_zone;
@property (nonatomic, retain) NSString * iso_code;

@end
