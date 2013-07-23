//
//  Carrier.h
//  ZXingWidget
//
//  Created by Adrien Guffens on 7/2/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Carrier : NSManagedObject

@property (nonatomic, retain) NSString * id_carrier;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * active;
@property (nonatomic, retain) NSString * delay;

@end
