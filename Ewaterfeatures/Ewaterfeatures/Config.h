//
//  Config.h
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 7/1/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Config : NSManagedObject

@property (nonatomic, retain) NSNumber * id_config;
@property (nonatomic, retain) NSNumber * db_base_is_configured;

@end
