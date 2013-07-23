//
//  OrderState.h
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 7/2/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface OrderState : NSManagedObject

@property (nonatomic, retain) NSNumber * id_order_state;
@property (nonatomic, retain) NSNumber * unremovable;
@property (nonatomic, retain) NSNumber * delivery;
@property (nonatomic, retain) NSNumber * hidden;
@property (nonatomic, retain) NSNumber * send_email;
@property (nonatomic, retain) NSNumber * invoice;
@property (nonatomic, retain) NSNumber * color;
@property (nonatomic, retain) NSNumber * logable;
@property (nonatomic, retain) NSNumber * shipped;
@property (nonatomic, retain) NSNumber * paid;
@property (nonatomic, retain) NSNumber * deleted;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * template;

@end
