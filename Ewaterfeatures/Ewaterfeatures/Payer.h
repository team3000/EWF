//
//  Payer.h
//  EWF
//
//  Created by Adrien Guffens on 7/5/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Payer : NSObject

@property (nonatomic, strong)NSString *payment_method;
@property (nonatomic, strong)NSMutableArray *funding_instruments;//INFO: contains credit_card && transactions

@end
