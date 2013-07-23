//
//  BillingAddress.h
//  EWF
//
//  Created by Adrien Guffens on 7/5/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BillingAddress : NSObject

@property (nonatomic, strong)NSString *line1;
@property (nonatomic, strong)NSString *city;
@property (nonatomic, strong)NSString *country_code;
@property (nonatomic, strong)NSString *postal_code;
@property (nonatomic, strong)NSString *state;


@end
