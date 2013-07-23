//
//  Image.h
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 6/18/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Product;

@interface Image : NSManagedObject

@property (nonatomic, retain) NSNumber * id_image;
@property (nonatomic, retain) NSNumber * id_product;
@property (nonatomic, retain) Product *product;

@end
