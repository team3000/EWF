//
//  PaypalControl.m
//  EWF
//
//  Created by Adrien Guffens on 7/4/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "PaypalControl.h"
#import "AppDelegate.h"

#import "NSDictionary+QueryString.h"

#import "QuantityPickerView.h"
#import "HelperView.h"

#import "PaymentPaypalModel.h"

#import "JsonTools.h"

#define kPayPalClientId @"EOJ2S-Z6OoN_le_KS1d75wsZ6y0SFdVsY9183IvxFyZp"
#define kPayPalReceiverEmail @"EClusMEUk8e9ihI7ZdVLF5cZ6y0SFdVsY9183IvxFyZp"


@interface PaypalControl ()

@property (nonatomic, strong)NSMutableArray *cardTypeList;
@property (nonatomic, strong)NSMutableArray *monthList;
@property (nonatomic, strong)NSMutableArray *yearList;

@property (nonatomic, strong)NSString *selectedCardType;
@property (nonatomic, strong)NSString *selectedMonth;
@property (nonatomic, strong)NSString *selectedYear;

@property (nonatomic, strong)QuantityPickerView *cardTypeQuantityPickerView;
@property (nonatomic, strong)QuantityPickerView *expireMonthQuantityPickerView;
@property (nonatomic, strong)QuantityPickerView *expireYearQuantityPickerView;

@end

@implementation PaypalControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
	[super awakeFromNib];
	
	[self.submitButton setType:BButtonTypeDefault];
	[self.submitButton setColor:[AppDelegate appDelegate].color];
	self.cardTypeList = [[NSMutableArray alloc] initWithObjects:@"MasterCard", @"Visa", nil];
	self.monthList = [[NSMutableArray alloc] initWithObjects:@"01", @"02", @"03", @"04", @"05", @"06", @"07", @"08", @"09", @"10", @"11", @"12", nil];
	self.yearList = [[NSMutableArray alloc] initWithObjects:@"2013", @"2014", @"2015", @"2016", @"2017", @"2018", @"2019", @"2019", @"2020", @"2021", @"2022", @"2023", @"2024", @"2025", @"2026", @"2027", @"2027", @"2028", @"2029", @"2030", @"2031", @"2032", nil];
}

- (IBAction)pay {
	//
	
	
	
	NSDictionary *params = [[NSMutableDictionary alloc] init];
	[params setValue:@"client_credentials" forKey:@"grant_type"];
/*		[params setValue:dateString forKey:@"dateofactivity"];
	[params setValue:[NSString stringWithFormat:@"%d", self.gpsTracking.timeTotal] forKey:@"valuelength"];
	[params setValue:self.gpsTracking.comment forKey:@"activitydescription"];
 */
#warning sending distance total in KM
	
	
	NSLog(@"params: %@", params);
	
	//
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.sandbox.paypal.com/v1/oauth2/token"]];
	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"en_US" forHTTPHeaderField:@"Accept-Language"];
	
	
	NSString *authStr = [NSString stringWithFormat:@"%@:%@", kPayPalClientId, kPayPalReceiverEmail];
	NSString *authValue = [NSString stringWithFormat:@"Basic %@", AFBase64EncodedStringFromString(authStr)];
	[request setValue:authValue forHTTPHeaderField:@"Authorization"];

	
//	NSString *accessToken = @"";//[[ABAppDelegate appDelegate].sessionManager accessToken];
//	[request setValue:[NSString stringWithFormat:@"bearer %@", accessToken] forHTTPHeaderField:@"Authorization"];

	[request setHTTPBody:[[params stringWithFormEncodedComponents] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *res, NSData *data, NSError *err){
		NSLog(@"data error: %@", err);
		NSLog(@"NSURLResponse: %@", res);
		
		if (data) {
			NSDictionary *dictionary = [JsonTools getDictionaryFromData:data];
			NSLog(@"%s | dictionary: %@", __PRETTY_FUNCTION__, dictionary);
			NSString *accessToken = [dictionary objectForKey:@"access_token"];
			if (accessToken) {
				[self doThePaymentWithAccessToken:accessToken];
			}
		}
			/*
		NSLog(@"%s | data: %@", __PRETTY_FUNCTION__ ,data);
		NSString *dataStringDebug = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSLog(@"%s | dataStringDebug: %@", __PRETTY_FUNCTION__, dataStringDebug);
		 */
		
//		[self didReceiveData:data];
	}];
	//[self.gpsTracking debug];

}

- (void)doThePaymentWithAccessToken:(NSString *)accessToken {
	
	
	
	PaymentPaypalModel *paymentPaypalModel = [[PaymentPaypalModel alloc] init];
	paymentPaypalModel.intent = @"sale";
	paymentPaypalModel.payer = [[Payer alloc] init];
	paymentPaypalModel.payer.payment_method = @"credit_card";
	paymentPaypalModel.payer.funding_instruments = [[NSMutableArray alloc] init];
	
	CreditCard *creditCard = [[CreditCard alloc] init];
	creditCard.number = @"5500005555555559";
	creditCard.type = @"mastercard";
	creditCard.expire_month = @"12";
	creditCard.expire_year = @"2018";
	creditCard.cvv2 = @"111";
	creditCard.first_name = @"Joe";
	creditCard.last_name = @"Shopper";
	/*
	creditCard.billing_address = [[BillingAddress alloc] init];
	creditCard.billing_address.line1 = @"52 N Main ST";
	creditCard.billing_address.city = @"Johnstown";
	creditCard.billing_address.country_code = @"US";
	creditCard.billing_address.postal_code = @"43210";
	creditCard.billing_address.state = @"OH";
	*/
	CreditCardWrapper *creditCardWrapper = [[CreditCardWrapper alloc] init];
	creditCardWrapper.credit_card = creditCard;

	[paymentPaypalModel.payer.funding_instruments addObject:creditCardWrapper];
	
	Transaction *transaction = [[Transaction alloc] init];
	transaction.amount = [[Amount alloc] init];
	transaction.amount.total = @"7.47";
	transaction.amount.currency = @"USD";
	/*
	transaction.amount.details = [[DetailsPaypal alloc] init];
	transaction.amount.details.subtotal = @"7.41";
	transaction.amount.details.tax = @"0.03";
	transaction.amount.details.shipping = @"0.03";
	*/
	transaction.description = @"This is the payment transaction description.";
	//INFO: to delete
	/*
	TransactionWrapper *transactionWrapper = [[TransactionWrapper alloc] init];
	transactionWrapper.transactions = [[NSMutableArray alloc] init];
	[transactionWrapper.transactions addObject:transaction];
	*/
	//[paymentPaypalModel.payer.funding_instruments addObject:transactionWrapper];
	

	paymentPaypalModel.transactions = [[NSMutableArray alloc] init];
	[paymentPaypalModel.transactions addObject:transaction];
	NSLog(@"%s | [paymentPaypalModel dictionary]: %@", __PRETTY_FUNCTION__, [paymentPaypalModel dictionary]);
	
	
	NSData* encodedData = [NSJSONSerialization dataWithJSONObject:[paymentPaypalModel dictionary] options:NSJSONWritingPrettyPrinted error:nil];
	NSString* jsonString = [[NSString alloc] initWithData:encodedData encoding:NSUTF8StringEncoding];

	NSLog(@"%s | [jsonString]: %@", __PRETTY_FUNCTION__, jsonString);
		
	
	
	
	
	NSDictionary *params = [[NSMutableDictionary alloc] init];
//	[params setValue:@"client_credentials" forKey:@"grant_type"];
	/*		[params setValue:dateString forKey:@"dateofactivity"];
	 [params setValue:[NSString stringWithFormat:@"%d", self.gpsTracking.timeTotal] forKey:@"valuelength"];
	 [params setValue:self.gpsTracking.comment forKey:@"activitydescription"];
	 */
#warning sending distance total in KM
	
	
	NSLog(@"params: %@", params);
	
	//
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.sandbox.paypal.com/v1/payments/payment"]];
	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[request setValue:@"en_US" forHTTPHeaderField:@"Accept-Language"];
	
	NSLog(@"%s | %@", __PRETTY_FUNCTION__, accessToken);
	
	[request setValue:[NSString stringWithFormat:@"Bearer %@", accessToken] forHTTPHeaderField:@"Authorization"];

	[request setHTTPBody:encodedData];
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *res, NSData *data, NSError *err){
		NSLog(@"data error: %@", err);
		NSLog(@"NSURLResponse: %@", res);
		
		if (data) {
			NSDictionary *dictionary = [JsonTools getDictionaryFromData:data];
			NSLog(@"%s | dictionary: %@", __PRETTY_FUNCTION__, dictionary);
			NSString *state = [dictionary objectForKey:@"state"];
			if (state) {
				NSLog(@"%s | state: %@", __PRETTY_FUNCTION__, state);
			}
		}
		/*
		 NSLog(@"%s | data: %@", __PRETTY_FUNCTION__ ,data);
		 NSString *dataStringDebug = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		 NSLog(@"%s | dataStringDebug: %@", __PRETTY_FUNCTION__, dataStringDebug);
		 */
		
		//		[self didReceiveData:data];
	}];
	//[self.gpsTracking debug];
	

}

#pragma mark - QuantityPickerViewDelegate

- (void)quantityPickerDidChange:(QuantityPickerView *)sender atRow:(NSInteger)row {
	
//	self.selectedGender = @(row + 1);
	if ([sender isEqual:self.cardTypeQuantityPickerView]) {
		self.selectedCardType = [self.cardTypeList objectAtIndex:row];
	}
	else if ([sender isEqual:self.expireMonthQuantityPickerView]) {
		self.selectedMonth = [self.monthList objectAtIndex:row];
	}
	else if ([sender isEqual:self.expireYearQuantityPickerView]) {
		self.selectedYear = [self.yearList objectAtIndex:row];
	}
}

- (NSString *)quantityPicker:(QuantityPickerView *)sender stringAtRow:(NSInteger)row {
	NSString *result = @"";
	
	if ([sender isEqual:self.cardTypeQuantityPickerView]) {
		result = [self.cardTypeList objectAtIndex:row];
	}
	else if ([sender isEqual:self.expireMonthQuantityPickerView]) {
		result = [self.monthList objectAtIndex:row];
	}
	else if ([sender isEqual:self.expireYearQuantityPickerView]) {
		result = [self.yearList objectAtIndex:row];
	}
	
	return result;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	BOOL result = YES;

	if ([textField isEqual:self.cardTypeTextField]) {
		[textField resignFirstResponder];
		[self displayCardTypeSelector];
		result = NO;
	}
	else if ([textField isEqual:self.cardMonthTextField]) {
		[textField resignFirstResponder];
		[self displayMonthSelector];
		result = NO;
	}
	else if ([textField isEqual:self.cardYearTextField]) {
		[textField resignFirstResponder];
		[self displayYearSelector];
		result = NO;
	}
	return result;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return NO;
}

#pragma mark - Display

- (void)displayCardTypeSelector {
	self.cardTypeQuantityPickerView = [[QuantityPickerView alloc] initWithFrame:CGRectMake(0, 0, 100, 300)];
	self.cardTypeQuantityPickerView.quantityPickerViewDelegate = self;
	
	self.cardTypeQuantityPickerView.itemList = self.cardTypeList;
	
	NSInteger selectedRow = 0;
	self.selectedCardType = self.cardTypeTextField.text;
	if ([self.selectedCardType length] > 0) {
		selectedRow = [self.cardTypeList indexOfObject:self.selectedCardType];
	}
	
	[self.cardTypeQuantityPickerView setSelectedRow:selectedRow];
	
	HelperView *helperView = [[HelperView alloc] initWithTitle:@"Select Card Type" andView:self.cardTypeQuantityPickerView];
	
	[helperView addButtonWithTitle:@"Cancel"
							  type:HelperViewButtonTypeCancel
						   handler:^(HelperView *helperView) {
							   NSLog(@"Cancel Clicked");
							   self.selectedCardType = nil;
						   }];
	
    [helperView addButtonWithTitle:@"Validate"
							  type:HelperViewButtonTypeDefault
						   handler:^(HelperView *helperView) {
							   NSLog(@"Validate Button Clicked");
							   
							   if (self.selectedCardType) {
								   self.cardTypeTextField.text = self.selectedCardType;
							   }
							   else {
								   
							   }
							   
						   }];
	
    
    helperView.willShowHandler = ^(HelperView *helperView) {
        NSLog(@"%@, willShowHandler", helperView);
    };
    helperView.didShowHandler = ^(HelperView *helperView) {
        NSLog(@"%@, didShowHandler", helperView);
    };
    helperView.willDismissHandler = ^(HelperView *helperView) {
        NSLog(@"%@, willDismissHandler", helperView);
    };
    helperView.didDismissHandler = ^(HelperView *helperView) {
        NSLog(@"%@, didDismissHandler", helperView);
    };
    
    [helperView show];
}

- (void)displayMonthSelector {
	self.expireMonthQuantityPickerView = [[QuantityPickerView alloc] initWithFrame:CGRectMake(0, 0, 100, 300)];
	self.expireMonthQuantityPickerView.quantityPickerViewDelegate = self;
	
	self.expireMonthQuantityPickerView.itemList = self.monthList;
	
	NSInteger selectedRow = 0;
	self.selectedMonth = self.cardMonthTextField.text;
	if ([self.selectedMonth length] > 0) {
		selectedRow = [self.monthList indexOfObject:self.selectedMonth];
	}
	
	[self.expireMonthQuantityPickerView setSelectedRow:selectedRow];
	
	HelperView *helperView = [[HelperView alloc] initWithTitle:@"Select a Month" andView:self.expireMonthQuantityPickerView];
	
	[helperView addButtonWithTitle:@"Cancel"
							  type:HelperViewButtonTypeCancel
						   handler:^(HelperView *helperView) {
							   NSLog(@"Cancel Clicked");
							   self.selectedMonth = nil;
						   }];
	
    [helperView addButtonWithTitle:@"Validate"
							  type:HelperViewButtonTypeDefault
						   handler:^(HelperView *helperView) {
							   NSLog(@"Validate Button Clicked");
							   
							   if (self.selectedMonth) {
								   self.cardMonthTextField.text = self.selectedMonth;
							   }
							   else {
								   
							   }
							   
						   }];
	
    
    helperView.willShowHandler = ^(HelperView *helperView) {
        NSLog(@"%@, willShowHandler", helperView);
    };
    helperView.didShowHandler = ^(HelperView *helperView) {
        NSLog(@"%@, didShowHandler", helperView);
    };
    helperView.willDismissHandler = ^(HelperView *helperView) {
        NSLog(@"%@, willDismissHandler", helperView);
    };
    helperView.didDismissHandler = ^(HelperView *helperView) {
        NSLog(@"%@, didDismissHandler", helperView);
    };
    
    [helperView show];
}

- (void)displayYearSelector {
	self.expireYearQuantityPickerView = [[QuantityPickerView alloc] initWithFrame:CGRectMake(0, 0, 100, 300)];
	self.expireYearQuantityPickerView.quantityPickerViewDelegate = self;
	
	self.expireYearQuantityPickerView.itemList = self.yearList;
	
	NSInteger selectedRow = 0;
	self.selectedYear = self.cardYearTextField.text;
	if ([self.selectedYear length] > 0) {
		selectedRow = [self.yearList indexOfObject:self.selectedYear];
	}
	
	[self.expireYearQuantityPickerView setSelectedRow:selectedRow];
	
	HelperView *helperView = [[HelperView alloc] initWithTitle:@"Select a Year" andView:self.expireYearQuantityPickerView];
	
	[helperView addButtonWithTitle:@"Cancel"
							  type:HelperViewButtonTypeCancel
						   handler:^(HelperView *helperView) {
							   NSLog(@"Cancel Clicked");
							   self.selectedYear = nil;
						   }];
	
    [helperView addButtonWithTitle:@"Validate"
							  type:HelperViewButtonTypeDefault
						   handler:^(HelperView *helperView) {
							   NSLog(@"Validate Button Clicked");
							   
							   if (self.selectedYear) {
								   self.cardYearTextField.text = self.selectedYear;
							   }
							   else {
								   
							   }
							   
						   }];
	
    
    helperView.willShowHandler = ^(HelperView *helperView) {
        NSLog(@"%@, willShowHandler", helperView);
    };
    helperView.didShowHandler = ^(HelperView *helperView) {
        NSLog(@"%@, didShowHandler", helperView);
    };
    helperView.willDismissHandler = ^(HelperView *helperView) {
        NSLog(@"%@, willDismissHandler", helperView);
    };
    helperView.didDismissHandler = ^(HelperView *helperView) {
        NSLog(@"%@, didDismissHandler", helperView);
    };
    
    [helperView show];
}

//

- (void)displayMessage:(NSString *)message andTitle:(NSString *)title {
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
	view.backgroundColor = [UIColor clearColor];
	
	UILabel *mainLabel = [[UILabel alloc] initWithFrame:view.bounds];
	
	mainLabel.textAlignment = NSTextAlignmentCenter;
	//	mainLabel.textAlignment = NSTextAlignmentNatural;
	mainLabel.backgroundColor = [UIColor clearColor];
	mainLabel.font = [UIFont systemFontOfSize:15];
	mainLabel.textColor = [UIColor darkGrayColor];
	mainLabel.adjustsFontSizeToFitWidth = YES;
	mainLabel.minimumScaleFactor = 0.75;
	mainLabel.numberOfLines = 4;
	
	
	//INFO: setting message
	mainLabel.text = message;
	
	[view addSubview:mainLabel];
	
	//INFO: setting title
	HelperView *helperView = [[HelperView alloc] initWithTitle:title andView:view];
	
	[helperView addButtonWithTitle:@"OK"
							  type:HelperViewButtonTypeDefault
						   handler:^(HelperView *helperView) {
							   NSLog(@"Scan Product Button Clicked");
						   }];
	
	
	helperView.willShowHandler = ^(HelperView *helperView) {
		NSLog(@"%@, willShowHandler", helperView);
	};
	helperView.didShowHandler = ^(HelperView *helperView) {
		NSLog(@"%@, didShowHandler", helperView);
	};
	helperView.willDismissHandler = ^(HelperView *helperView) {
		NSLog(@"%@, willDismissHandler", helperView);
	};
	helperView.didDismissHandler = ^(HelperView *helperView) {
		NSLog(@"%@, didDismissHandler", helperView);
	};
	
	[helperView show];
	
}

//INFO: heper

static NSString * AFBase64EncodedStringFromString(NSString *string) {
    NSData *data = [NSData dataWithBytes:[string UTF8String] length:[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    NSUInteger length = [data length];
    NSMutableData *mutableData = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
	
    uint8_t *input = (uint8_t *)[data bytes];
    uint8_t *output = (uint8_t *)[mutableData mutableBytes];
	
    for (NSUInteger i = 0; i < length; i += 3) {
        NSUInteger value = 0;
        for (NSUInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
		
        static uint8_t const kAFBase64EncodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
		
        NSUInteger idx = (i / 3) * 4;
        output[idx + 0] = kAFBase64EncodingTable[(value >> 18) & 0x3F];
        output[idx + 1] = kAFBase64EncodingTable[(value >> 12) & 0x3F];
        output[idx + 2] = (i + 1) < length ? kAFBase64EncodingTable[(value >> 6)  & 0x3F] : '=';
        output[idx + 3] = (i + 2) < length ? kAFBase64EncodingTable[(value >> 0)  & 0x3F] : '=';
    }
	
    return [[NSString alloc] initWithData:mutableData encoding:NSASCIIStringEncoding];
}

@end
