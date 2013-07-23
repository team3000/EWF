//
//  PaymentPaypalModel.m
//  EWF
//
//  Created by Adrien Guffens on 7/5/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "PaymentPaypalModel.h"
#import "JAGPropertyConverter.h"



@implementation PaymentPaypalModel

- (id)initWithPaymentPaypalModel:(PaymentPaypalModel *)paymentPaypalModel {
	self = [super init];
	if (self) {
		self.intent = paymentPaypalModel.intent;
		self.payer = paymentPaypalModel.payer;
	}
	return self;
}

- (NSDictionary *)dictionary {
	JAGPropertyConverter *converter = [[JAGPropertyConverter alloc] initWithOutputType:kJAGJSONOutput];
	converter.classesToConvert = [NSSet setWithObjects:[Payer class], [CreditCard class], [BillingAddress class], [Transaction class], [Amount class], [DetailsPaypal class], [CreditCardWrapper class], [TransactionWrapper class], [DescriptionWrapper class], nil];
	NSDictionary *jsonDictionary = [converter convertToDictionary:self];
	
	return jsonDictionary;
}

@end
