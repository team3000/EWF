//
//  CreditCard.h
//  EWF
//
//  Created by Adrien Guffens on 7/5/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BillingAddress.h"

@interface CreditCard : NSObject

@property (nonatomic, strong)NSString *number;
@property (nonatomic, strong)NSString *type;
@property (nonatomic, strong)NSString *expire_month;
@property (nonatomic, strong)NSString *expire_year;
@property (nonatomic, strong)NSString *cvv2;
@property (nonatomic, strong)NSString *first_name;
@property (nonatomic, strong)NSString *last_name;
@property (nonatomic, strong)BillingAddress *billing_address;


@end
