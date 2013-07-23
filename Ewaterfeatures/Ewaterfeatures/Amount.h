//
//  Amount.h
//  EWF
//
//  Created by Adrien Guffens on 7/5/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetailsPaypal.h"

@interface Amount : NSObject

@property (nonatomic, strong)NSString *total;
@property (nonatomic, strong)NSString *currency;
@property (nonatomic, strong)DetailsPaypal *details;



@end
