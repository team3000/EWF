//
//  DetailsPaypal.h
//  EWF
//
//  Created by Adrien Guffens on 7/5/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailsPaypal : NSObject

@property (nonatomic, strong)NSString *subtotal;
@property (nonatomic, strong)NSString *tax;
@property (nonatomic, strong)NSString *shipping;

@end
