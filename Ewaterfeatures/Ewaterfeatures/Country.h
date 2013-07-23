//
//  Country.h
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 6/18/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Country : NSManagedObject

@property (nonatomic, retain) NSNumber * active;
@property (nonatomic, retain) NSString * call_prefix;
@property (nonatomic, retain) NSNumber * contains_states;
@property (nonatomic, retain) NSNumber * country_id;
@property (nonatomic, retain) NSNumber * display_tax_label;
@property (nonatomic, retain) NSNumber * id_country;
@property (nonatomic, retain) NSNumber * id_currency;
@property (nonatomic, retain) NSNumber * id_zone;
@property (nonatomic, retain) NSString * iso_code;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * need_identification_number;
@property (nonatomic, retain) NSNumber * need_zip_code;
@property (nonatomic, retain) NSString * zip_code_format;

@end
