//
//  Transaction.h
//  EWF
//
//  Created by Adrien Guffens on 7/5/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Amount.h"

@interface Transaction : NSObject

@property (nonatomic, strong)NSString *description;
@property (nonatomic, strong)Amount *amount;


@end
