//
//  PaymentPaypalModel.h
//  EWF
//
//  Created by Adrien Guffens on 7/5/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Payer.h"

#import "CreditCardWrapper.h"
#import "CreditCard.h"
#import "BillingAddress.h"
#import "TransactionWrapper.h"
#import "Transaction.h"
#import "Amount.h"
#import "DetailsPaypal.h"
#import "DescriptionWrapper.h"

@interface PaymentPaypalModel : NSObject

@property (nonatomic, strong)NSString *intent;
@property (nonatomic, strong)NSMutableArray *transactions;
@property (nonatomic, strong)Payer *payer;

- (NSDictionary *)dictionary;

@end
