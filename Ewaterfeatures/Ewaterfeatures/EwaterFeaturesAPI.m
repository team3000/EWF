//
//  EwaterFeaturesAPI.m
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 6/10/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "EwaterFeaturesAPI.h"
#import "AFJSONRequestOperation.h"
#import "Product.h"
#import "Product+Manager.h"
#import "SessionManager.h"
#import "AFNetworking.h"

#import "Cart.h"
#import "Cart+Manager.h"

#import "Order+Manager.h"
#import "OrderState+Manager.h"

#import "Product+Manager.h"
#import "Category+Manager.h"
#import "Employee+Manager.h"
#import "Customer+Manager.h"
#import "Address+Manager.h"
#import "Order+Manager.h"
#import "Cart+Manager.h"
#import "Country+Manager.h"
#import "CountryState+Manager.h"

#import "AppDelegate.h"


@interface EwaterFeaturesAPI ()

@property (nonatomic, strong) NSString *tmpInnerTagText;
@property (nonatomic, strong) NSMutableDictionary *prestashopDictionary;
@property (nonatomic, strong) NSString *tmpKeyString;

@end

@implementation EwaterFeaturesAPI

- (id)init {
	self = [super init];
	if (self) {
		self.numberOfCurrentResquest = [NSNumber numberWithInt:0];
	}
	return  self;
}

#pragma mark - Update list

+ (void)updateProducts:(void (^)(NSMutableDictionary *result))success failure:(void (^)(NSHTTPURLResponse *response, NSError *error))failure {
	
	[AppDelegate appDelegate].ewaterFeaturesAPI.succesProductsHandler = success;
	if (failure) {
		[AppDelegate appDelegate].ewaterFeaturesAPI.failHandler = failure;
	}

	
	
	//INFO: define the route
	NSString *routeString = @"products";
	
	//INFO: define the requeste
	NSMutableURLRequest *request = [SessionManager requestForRoute:routeString];
	[request setHTTPMethod:@"GET"];
	
	NSLog(@"%s | %@", __PRETTY_FUNCTION__, [request description]);
	
	//INFO: start parsing
	[EwaterFeaturesAPI parse:request success:success failure:failure];
}

+ (void)updateCategories:(void (^)(NSMutableDictionary *result))success failure:(void (^)(NSHTTPURLResponse *response, NSError *error))failure {
	
	
	[AppDelegate appDelegate].ewaterFeaturesAPI.succesCategoriesHandler = success;
	if (failure) {
		[AppDelegate appDelegate].ewaterFeaturesAPI.failHandler = failure;
	}

	
	
	//INFO: define the route
	NSString *routeString = @"categories";
	
	//INFO: define the requeste
	NSMutableURLRequest *request = [SessionManager requestForRoute:routeString];
	[request setHTTPMethod:@"GET"];
	
	NSLog(@"%s | %@", __PRETTY_FUNCTION__, [request description]);
	
	//INFO: start parsing
	[EwaterFeaturesAPI parse:request success:success failure:failure];
}

+ (void)updateEmployees:(void (^)(NSMutableDictionary *result))success failure:(void (^)(NSHTTPURLResponse *response, NSError *error))failure {
	
	[AppDelegate appDelegate].ewaterFeaturesAPI.succesEmployeesHandler = success;
	if (failure) {
		[AppDelegate appDelegate].ewaterFeaturesAPI.failHandler = failure;
	}

	
	
	//INFO: define the route
	NSString *routeString = @"employees";
	
	//INFO: define the requeste
	NSMutableURLRequest *request = [SessionManager requestForRoute:routeString];
	[request setHTTPMethod:@"GET"];
	
	NSLog(@"%s | %@", __PRETTY_FUNCTION__, [request description]);
	
	//INFO: start parsing
	[EwaterFeaturesAPI parse:request success:success failure:failure];
}

+ (void)updateCustomers:(void (^)(NSMutableDictionary *result))success failure:(void (^)(NSHTTPURLResponse *response, NSError *error))failure {
	
	[AppDelegate appDelegate].ewaterFeaturesAPI.succesCustomersHandler = success;
	if (failure) {
		[AppDelegate appDelegate].ewaterFeaturesAPI.failHandler = failure;
	}

	
	
	//INFO: define the route
	NSString *routeString = @"customers";
	
	//INFO: define the requeste
	NSMutableURLRequest *request = [SessionManager requestForRoute:routeString];
	[request setHTTPMethod:@"GET"];
	
	NSLog(@"%s | %@", __PRETTY_FUNCTION__, [request description]);
	
	//INFO: start parsing
	[EwaterFeaturesAPI parse:request success:success failure:failure];
}

+ (void)updateAddresses:(void (^)(NSMutableDictionary *result))success failure:(void (^)(NSHTTPURLResponse *response, NSError *error))failure {
	
	[AppDelegate appDelegate].ewaterFeaturesAPI.succesAddressesHandler = success;
	if (failure) {
		[AppDelegate appDelegate].ewaterFeaturesAPI.failHandler = failure;
	}

	
	
	//INFO: define the route
	NSNumber *id_customer = [AppDelegate appDelegate].sessionManager.session.customer.id_customer;
	NSString *routeString = [NSString stringWithFormat:@"addresses?filter[id_customer]=[%@]", id_customer];
	
	//INFO: define the requeste
	NSMutableURLRequest *request = [SessionManager requestForRoute:routeString];
	[request setHTTPMethod:@"GET"];
	
	NSLog(@"%s | %@", __PRETTY_FUNCTION__, [request description]);
	
	//INFO: start parsing
	[EwaterFeaturesAPI parse:request success:success failure:failure];
}

//

+ (void)updateOrders:(void (^)(NSMutableDictionary *result))success failure:(void (^)(NSHTTPURLResponse *response, NSError *error))failure {
	
	[AppDelegate appDelegate].ewaterFeaturesAPI.succesOrdersHandler = success;
	if (failure) {
		[AppDelegate appDelegate].ewaterFeaturesAPI.failHandler = failure;
	}

	
	
	//INFO: define the route
	NSNumber *id_customer = [AppDelegate appDelegate].sessionManager.session.customer.id_customer;
	NSString *routeString = [NSString stringWithFormat:@"orders?filter[id_customer]=[%@]", id_customer];//@"orders";
	
	//INFO: define the requeste
	NSMutableURLRequest *request = [SessionManager requestForRoute:routeString];
	[request setHTTPMethod:@"GET"];
	
	NSLog(@"%s | %@", __PRETTY_FUNCTION__, [request description]);
	
	//INFO: start parsing
	[EwaterFeaturesAPI parse:request success:success failure:failure];
}

+ (void)updateCarts:(void (^)(NSMutableDictionary *result))success failure:(void (^)(NSHTTPURLResponse *response, NSError *error))failure {
	
	[AppDelegate appDelegate].ewaterFeaturesAPI.succesCartsHandler = success;
	if (failure) {
		[AppDelegate appDelegate].ewaterFeaturesAPI.failHandler = failure;
	}

	
	
	//INFO: define the route
	NSNumber *id_customer = [AppDelegate appDelegate].sessionManager.session.customer.id_customer;
	NSString *routeString = [NSString stringWithFormat:@"carts?filter[id_customer]=[%@]", id_customer];//@"carts";
	
	//INFO: define the requeste
	NSMutableURLRequest *request = [SessionManager requestForRoute:routeString];
	[request setHTTPMethod:@"GET"];
	
	NSLog(@"%s | %@", __PRETTY_FUNCTION__, [request description]);
	
	//INFO: start parsing
	[EwaterFeaturesAPI parse:request success:success failure:failure];
}

+ (void)updateCountries:(void (^)(NSMutableDictionary *result))success failure:(void (^)(NSHTTPURLResponse *response, NSError *error))failure {
	
	[AppDelegate appDelegate].ewaterFeaturesAPI.succesCountriesHandler = success;
	if (failure) {
		[AppDelegate appDelegate].ewaterFeaturesAPI.failHandler = failure;
	}

	
	
	//INFO: define the route
	NSString *routeString = @"countries?filter[id_zone]=[5]";//INFO: here we limit the country in Oceania
	
	//INFO: define the requeste
	NSMutableURLRequest *request = [SessionManager requestForRoute:routeString];
	[request setHTTPMethod:@"GET"];
	
	NSLog(@"%s | %@", __PRETTY_FUNCTION__, [request description]);
	
	//INFO: start parsing
	[EwaterFeaturesAPI parse:request success:success failure:failure];
}

+ (void)updateStates:(void (^)(NSMutableDictionary *result))success failure:(void (^)(NSHTTPURLResponse *response, NSError *error))failure {
	
	[AppDelegate appDelegate].ewaterFeaturesAPI.succesStatesHandler = success;
	if (failure) {
		[AppDelegate appDelegate].ewaterFeaturesAPI.failHandler = failure;
	}

	
	
	//INFO: define the route
	NSString *routeString = @"states?filter[id_zone]=[5]";//INFO: here we limit the country in Oceania
	
	//INFO: define the requeste
	NSMutableURLRequest *request = [SessionManager requestForRoute:routeString];
	[request setHTTPMethod:@"GET"];
	
	NSLog(@"%s | %@", __PRETTY_FUNCTION__, [request description]);
	
	//INFO: start parsing
	[EwaterFeaturesAPI parse:request success:success failure:failure];
}

+ (void)updateOrderStates:(void (^)(NSMutableDictionary *result))success failure:(void (^)(NSHTTPURLResponse *response, NSError *error))failure {
	
	[AppDelegate appDelegate].ewaterFeaturesAPI.succesOrderStatesHandler = success;
	if (failure) {
		[AppDelegate appDelegate].ewaterFeaturesAPI.failHandler = failure;
	}

	
	//INFO: define the route
	NSString *routeString = @"order_states";
	
	//INFO: define the requeste
	NSMutableURLRequest *request = [SessionManager requestForRoute:routeString];
	[request setHTTPMethod:@"GET"];
	
	NSLog(@"%s | %@", __PRETTY_FUNCTION__, [request description]);
	
	//INFO: start parsing
	[EwaterFeaturesAPI parse:request success:success failure:failure];
}

//

+ (void)updateProductWithId:(NSString *)id_product success:(void (^)(NSMutableDictionary *result))success failure:(void (^)(NSHTTPURLResponse *response, NSError *error))failure {
	
	if (success) {
		[AppDelegate appDelegate].ewaterFeaturesAPI.succesProductHandler = success;
	}
	if (failure) {
		[AppDelegate appDelegate].ewaterFeaturesAPI.failHandler = failure;
	}
	NSString *routeString = [NSString stringWithFormat:@"products/%@", id_product];
	
	NSMutableURLRequest *request = [SessionManager requestForRoute:routeString];
	[request setHTTPMethod:@"GET"];
	
	[EwaterFeaturesAPI parse:request success:success failure:failure];
}

+ (void)updateOrderWithId:(NSString *)id_order success:(void (^)(NSMutableDictionary *result))success failure:(void (^)(NSHTTPURLResponse *response, NSError *error))failure {
	
	if (success) {
		[AppDelegate appDelegate].ewaterFeaturesAPI.succesOrderHandler = success;
	}
	if (failure) {
		[AppDelegate appDelegate].ewaterFeaturesAPI.failHandler = failure;
	}
	
	NSString *routeString = [NSString stringWithFormat:@"orders/%@", id_order];
	
	NSMutableURLRequest *request = [SessionManager requestForRoute:routeString];
	[request setHTTPMethod:@"GET"];
	
	[EwaterFeaturesAPI parse:request success:success failure:failure];
}


//

#pragma mark - Update Item

+ (void)updateProductWithId:(NSString *)id_product {
	/*
	 NSString *routeString = [NSString stringWithFormat:@"products/%@", id_product];
	 
	 NSMutableURLRequest *request = [SessionManager requestForRoute:routeString];
	 [request setHTTPMethod:@"GET"];
	 
	 [EwaterFeaturesAPI parse:request];
	 */
	[EwaterFeaturesAPI updateProductWithId:id_product success:nil failure:nil];
}

+ (void)updateCategoryWithId:(NSString *)id_category {
	NSString *routeString = [NSString stringWithFormat:@"categories/%@", id_category];
	
	NSMutableURLRequest *request = [SessionManager requestForRoute:routeString];
	[request setHTTPMethod:@"GET"];
	
	[EwaterFeaturesAPI parse:request];
}

+ (void)updateEmployeeWithId:(NSString *)id_employee {
	NSString *routeString = [NSString stringWithFormat:@"employees/%@", id_employee];
	
	NSMutableURLRequest *request = [SessionManager requestForRoute:routeString];
	[request setHTTPMethod:@"GET"];
	
	[EwaterFeaturesAPI parse:request];
}

+ (void)updateCustomerWithId:(NSString *)id_customer {
	NSString *routeString = [NSString stringWithFormat:@"customers/%@", id_customer];
	
	NSMutableURLRequest *request = [SessionManager requestForRoute:routeString];
	[request setHTTPMethod:@"GET"];
	
	[EwaterFeaturesAPI parse:request];
}

+ (void)updateAddressWithId:(NSString *)id_address {
	NSString *routeString = [NSString stringWithFormat:@"addresses/%@", id_address];
	
	NSMutableURLRequest *request = [SessionManager requestForRoute:routeString];
	[request setHTTPMethod:@"GET"];
	
	[EwaterFeaturesAPI parse:request];
}

+ (void)updateOrderWithId:(NSString *)id_order {
	NSString *routeString = [NSString stringWithFormat:@"orders/%@", id_order];
	
	NSMutableURLRequest *request = [SessionManager requestForRoute:routeString];
	[request setHTTPMethod:@"GET"];
	
	[EwaterFeaturesAPI parse:request];
}

+ (void)updateCartWithId:(NSString *)id_cart {
	NSString *routeString = [NSString stringWithFormat:@"carts/%@", id_cart];
	
	NSMutableURLRequest *request = [SessionManager requestForRoute:routeString];
	[request setHTTPMethod:@"GET"];
	
	[EwaterFeaturesAPI parse:request];
}

+ (void)updateCountryWithId:(NSString *)id_country {
	NSString *routeString = [NSString stringWithFormat:@"countries/%@", id_country];
	
	NSMutableURLRequest *request = [SessionManager requestForRoute:routeString];
	[request setHTTPMethod:@"GET"];
	
	[EwaterFeaturesAPI parse:request];
}

+ (void)updateStateWithId:(NSString *)id_state {
	NSString *routeString = [NSString stringWithFormat:@"states/%@", id_state];
	
	NSMutableURLRequest *request = [SessionManager requestForRoute:routeString];
	[request setHTTPMethod:@"GET"];
	
	[EwaterFeaturesAPI parse:request];
}

+ (void)updateOrderStateWithId:(NSString *)id_state {
	NSString *routeString = [NSString stringWithFormat:@"order_states/%@", id_state];
	
	NSMutableURLRequest *request = [SessionManager requestForRoute:routeString];
	[request setHTTPMethod:@"GET"];
	
	[EwaterFeaturesAPI parse:request];
}

//

+ (void)customerWithEmail:(NSString *)email success:(void (^)(NSMutableDictionary *result))success failure:(void (^)(NSHTTPURLResponse *response, NSError *error))failure {
	//TODO: set success handdler [OK]
	[AppDelegate appDelegate].ewaterFeaturesAPI.succesCustomersHandler = success;
	[AppDelegate appDelegate].ewaterFeaturesAPI.failHandler = failure;
	
	NSString *routeString = [NSString stringWithFormat:@"customers/?filter[email]=[%@]", email];
	
	NSMutableURLRequest *request = [SessionManager requestForRoute:routeString];
	[request setHTTPMethod:@"GET"];
	
	[EwaterFeaturesAPI parse:request success:success failure:nil];
}

+ (void)employeeWithEmail:(NSString *)email success:(void (^)(NSMutableDictionary *result))success failure:(void (^)(NSHTTPURLResponse *response, NSError *error))failure {
	//TODO: set success handdler [OK]
	[AppDelegate appDelegate].ewaterFeaturesAPI.succesEmployeesHandler = success;
	[AppDelegate appDelegate].ewaterFeaturesAPI.failHandler = failure;
	
	NSString *routeString = [NSString stringWithFormat:@"employees/?filter[email]=[%@]", email];
	
	NSMutableURLRequest *request = [SessionManager requestForRoute:routeString];
	[request setHTTPMethod:@"GET"];
	
	[EwaterFeaturesAPI parse:request success:success failure:failure];
}

+ (void)customerListWithFirstName:(NSString *)firstName lastName:(NSString *)lastName company:(NSString *)company success:(void (^)(NSMutableDictionary *))success failure:(void (^)(NSHTTPURLResponse *, NSError *))failure {
	[AppDelegate appDelegate].ewaterFeaturesAPI.succesCustomersHandler = success;
	[AppDelegate appDelegate].ewaterFeaturesAPI.failHandler = failure;
#warning TO COMPLETE
	NSString *routeString = [NSString stringWithFormat:@"customers/?filter[firstname]=%[%@]", firstName];
	
	NSMutableURLRequest *request = [SessionManager requestForRoute:routeString];
	[request setHTTPMethod:@"GET"];
	
	[EwaterFeaturesAPI parse:request success:success failure:failure];

}


//

+ (void)updateAddress:(Address *)address success:(void (^)(NSMutableDictionary *result))success failure:(void (^)(NSHTTPURLResponse *response, NSError *error))failure {
	
#warning NOT WORKING
	[AppDelegate appDelegate].ewaterFeaturesAPI.succesAddressesHandler = success;
	[AppDelegate appDelegate].ewaterFeaturesAPI.failHandler = failure;
	
	//INFO: define the route
	NSString *routeString = @"addresses";
	
	NSLog(@"%s | routeString: %@", __PRETTY_FUNCTION__, routeString);
	
	//INFO: define the requeste
	NSMutableURLRequest *request = [SessionManager requestForRoute:routeString];
	[request setHTTPMethod:@"PUT"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setValue:@"application/xml" forHTTPHeaderField:@"Accept"];
	
	
	NSString *xmlString = [NSString stringWithFormat:@"xml=%@", [Address convertToXML:address] ];
	NSLog(@"%s | xmlString: %@", __PRETTY_FUNCTION__, xmlString);
	
	[request setHTTPBody:[xmlString dataUsingEncoding:NSUTF8StringEncoding]];
	NSLog(@"%s | Request body A %@", __PRETTY_FUNCTION__, [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding]);
	
	NSLog(@"%s | %@", __PRETTY_FUNCTION__, [request description]);
	
	[EwaterFeaturesAPI parse:request success:success failure:failure];
}

//

+ (void)sendCart:(Cart *)cart success:(void (^)(NSMutableDictionary *result))success failure:(void (^)(NSHTTPURLResponse *response, NSError *error))failure {
	
	[AppDelegate appDelegate].ewaterFeaturesAPI.succesCartsHandler = success;
	[AppDelegate appDelegate].ewaterFeaturesAPI.failHandler = failure;
	
	//INFO: define the route
	NSString *routeString = @"carts";
	
	NSLog(@"%s | routeString: %@", __PRETTY_FUNCTION__, routeString);
	
	//INFO: define the requeste
	NSMutableURLRequest *request = [SessionManager requestForRoute:routeString];
	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setValue:@"application/xml" forHTTPHeaderField:@"Accept"];
	
	
	NSString *xmlString = [NSString stringWithFormat:@"xml=%@", [Cart convertToXML:cart] ];
	NSLog(@"%s | xmlString: %@", __PRETTY_FUNCTION__, xmlString);
	
	[request setHTTPBody:[xmlString dataUsingEncoding:NSUTF8StringEncoding]];
	NSLog(@"%s | Request body A %@", __PRETTY_FUNCTION__, [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding]);
	
	NSLog(@"%s | %@", __PRETTY_FUNCTION__, [request description]);
	
	//INFO: start parsing
	[EwaterFeaturesAPI parse:request success:success failure:failure];
}


+ (void)sendOrder:(Order *)order success:(void (^)(NSMutableDictionary *result))success failure:(void (^)(NSHTTPURLResponse *response, NSError *error))failure {
	[AppDelegate appDelegate].ewaterFeaturesAPI.succesOrdersHandler = success;
	[AppDelegate appDelegate].ewaterFeaturesAPI.failHandler = failure;
	
	//INFO: define the route
	NSString *routeString = @"orders";
	
	NSLog(@"%s | routeString: %@", __PRETTY_FUNCTION__, routeString);
	
	//INFO: define the requeste
	NSMutableURLRequest *request = [SessionManager requestForRoute:routeString];
	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setValue:@"application/xml" forHTTPHeaderField:@"Accept"];
	
	
	NSString *xmlString = [NSString stringWithFormat:@"xml=%@", [Order convertToXML:order] ];
	NSLog(@"%s | xmlString: %@", __PRETTY_FUNCTION__, xmlString);
	
	[request setHTTPBody:[xmlString dataUsingEncoding:NSUTF8StringEncoding]];
	NSLog(@"%s | Request body A %@", __PRETTY_FUNCTION__, [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding]);
	
	NSLog(@"%s | %@", __PRETTY_FUNCTION__, [request description]);
	
	//INFO: start parsing
	/*
	 [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *res, NSData *data, NSError *err){
	 NSLog(@"data error: %@", err);
	 NSLog(@"NSURLResponse: %@", res);
	 
	 NSLog(@"%s | result: %@", __PRETTY_FUNCTION__, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
	 //		[self didReceiveData:data];
	 }];
	 */
	[EwaterFeaturesAPI parse:request success:success failure:failure];
}

+ (void)sendAddress:(Address *)address success:(void (^)(NSMutableDictionary *result))success failure:(void (^)(NSHTTPURLResponse *response, NSError *error))failure {
	[AppDelegate appDelegate].ewaterFeaturesAPI.succesAddressesHandler = success;
	[AppDelegate appDelegate].ewaterFeaturesAPI.failHandler = failure;
	
	//INFO: define the route
	NSString *routeString = @"addresses";
	
	NSLog(@"%s | routeString: %@", __PRETTY_FUNCTION__, routeString);
	
	//INFO: define the requeste
	NSMutableURLRequest *request = [SessionManager requestForRoute:routeString];
	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setValue:@"application/xml" forHTTPHeaderField:@"Accept"];
	
	
	NSString *xmlString = [NSString stringWithFormat:@"xml=%@", [Address convertToXML:address] ];
	NSLog(@"%s | xmlString: %@", __PRETTY_FUNCTION__, xmlString);
	
	[request setHTTPBody:[xmlString dataUsingEncoding:NSUTF8StringEncoding]];
	NSLog(@"%s | Request body A %@", __PRETTY_FUNCTION__, [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding]);
	
	NSLog(@"%s | %@", __PRETTY_FUNCTION__, [request description]);
	
	[EwaterFeaturesAPI parse:request success:success failure:failure];
}

+ (void)sendCustomer:(Customer *)customer success:(void (^)(NSMutableDictionary *result))success failure:(void (^)(NSHTTPURLResponse *response, NSError *error))failure {
	[AppDelegate appDelegate].ewaterFeaturesAPI.succesCustomersHandler = success;
	[AppDelegate appDelegate].ewaterFeaturesAPI.failHandler = failure;
	
	//INFO: define the route
	NSString *routeString = @"customers";
	
	NSLog(@"%s | routeString: %@", __PRETTY_FUNCTION__, routeString);
	
	//INFO: define the requeste
	NSMutableURLRequest *request = [SessionManager requestForRoute:routeString];
	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setValue:@"application/xml" forHTTPHeaderField:@"Accept"];
	
	
	NSString *xmlString = [NSString stringWithFormat:@"xml=%@", [Customer convertToXML:customer] ];
	NSLog(@"%s | xmlString: %@", __PRETTY_FUNCTION__, xmlString);
	
	[request setHTTPBody:[xmlString dataUsingEncoding:NSUTF8StringEncoding]];
	NSLog(@"%s | Request body A %@", __PRETTY_FUNCTION__, [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding]);
	
	NSLog(@"%s | %@", __PRETTY_FUNCTION__, [request description]);
	
	[EwaterFeaturesAPI parse:request success:success failure:failure];
}

+ (NSMutableURLRequest *)defaultImageUrlRequestForProduct:(Product *)product {
	NSString *imageUrlString = [NSString stringWithFormat:@"images/products/%@/%@", product.id_product, product.id_default_image];
	NSMutableURLRequest *request = [SessionManager requestForRoute:imageUrlString];
	
	request.cachePolicy = NSURLRequestReturnCacheDataElseLoad; // this will make sure the request always returns the cached image
    request.HTTPShouldHandleCookies = NO;
    request.HTTPShouldUsePipelining = YES;
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
	
	return request;
}


#pragma make - Static parse methods

+ (void)parse:(NSMutableURLRequest *)request success:(void (^)(NSMutableDictionary *result))success failure:(void (^)(NSHTTPURLResponse *response, NSError *error))failure  {
	NSLog(@"%s | %@", __PRETTY_FUNCTION__, [request description]);
	
	[AppDelegate appDelegate].ewaterFeaturesAPI.numberOfCurrentResquest = [NSNumber numberWithInt:[[AppDelegate appDelegate].ewaterFeaturesAPI.numberOfCurrentResquest intValue] + 1];
	
	AFXMLRequestOperation *operation = [AFXMLRequestOperation XMLParserRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser) {
		
		XMLParser.delegate = [AppDelegate appDelegate].ewaterFeaturesAPI;
		
		NSLog(@"%s | %@", __PRETTY_FUNCTION__, [XMLParser description]);
		
		[AppDelegate appDelegate].ewaterFeaturesAPI.numberOfCurrentResquest = [NSNumber numberWithInt:[[AppDelegate appDelegate].ewaterFeaturesAPI.numberOfCurrentResquest intValue] - 1];
		
		[XMLParser parse];
		
	} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSXMLParser *XMLParser) {
		
		XMLParser.delegate = [AppDelegate appDelegate].ewaterFeaturesAPI;
		
		NSLog(@"%s | response: %@", __PRETTY_FUNCTION__, [response description]);
		NSLog(@"%s | error: %@", __PRETTY_FUNCTION__, [error description]);
		
		[AppDelegate appDelegate].ewaterFeaturesAPI.numberOfCurrentResquest = [NSNumber numberWithInt:[[AppDelegate appDelegate].ewaterFeaturesAPI.numberOfCurrentResquest intValue] - 1];
		
		[AppDelegate appDelegate].ewaterFeaturesAPI.failHandler = failure;
		NSLog(@"%s | parserError: %@", __PRETTY_FUNCTION__, [XMLParser.parserError description]);
		[XMLParser parse];
		
		NSLog(@"%s | parserError: %@", __PRETTY_FUNCTION__, [XMLParser.parserError description]);
		
		//INFO: fix
//		if (failure != nil)
//			failure(response, error);
		
	}];
	[operation start];
}

+ (void)parse:(NSMutableURLRequest *)request {
	[EwaterFeaturesAPI parse:request success:nil failure:nil];
}

#pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
	if (self.tmpKeyString != nil && [self.tmpKeyString length] > 0)
		self.tmpKeyString = [NSString stringWithFormat:@"%@:%@", self.tmpKeyString, elementName];
	else
		self.tmpKeyString = elementName;
	
	/*
	 NSLog(@"%s | attributeDict: %@", __PRETTY_FUNCTION__, attributeDict);
	 NSLog(@"%s | elementName: %@", __PRETTY_FUNCTION__, elementName);
	 NSLog(@"%s | START | key: %@", __PRETTY_FUNCTION__, self.tmpKeyString);
	 */
	
	if ([self.tmpKeyString isEqualToString:@"prestashop"]) {
		self.prestashopDictionary = [[NSMutableDictionary alloc] init];
	}
	else if ([self.tmpKeyString isEqualToString:@"prestashop:products:product"]) {
		if ([attributeDict valueForKey:@"id"]) {
			[EwaterFeaturesAPI updateProductWithId:[attributeDict valueForKey:@"id"]];
		}
	}
	else if ([self.tmpKeyString isEqualToString:@"prestashop:employees:employee"]) {
		if ([attributeDict valueForKey:@"id"]) {
			[EwaterFeaturesAPI updateEmployeeWithId:[attributeDict valueForKey:@"id"]];
		}
	}
	else if ([self.tmpKeyString isEqualToString:@"prestashop:categories:category"]) {
		if ([attributeDict valueForKey:@"id"]) {
			[EwaterFeaturesAPI updateCategoryWithId:[attributeDict valueForKey:@"id"]];
		}
	}
	else if ([self.tmpKeyString isEqualToString:@"prestashop:customers:customer"]) {
		if ([attributeDict valueForKey:@"id"]) {
			[EwaterFeaturesAPI updateCustomerWithId:[attributeDict valueForKey:@"id"]];
		}
	}
	else if ([self.tmpKeyString isEqualToString:@"prestashop:addresses:address"]) {
		if ([attributeDict valueForKey:@"id"]) {
			[EwaterFeaturesAPI updateAddressWithId:[attributeDict valueForKey:@"id"]];
		}
	}//
	else if ([self.tmpKeyString isEqualToString:@"prestashop:orders:order"]) {
		if ([attributeDict valueForKey:@"id"]) {
			[EwaterFeaturesAPI updateOrderWithId:[attributeDict valueForKey:@"id"]];
		}
	}
	else if ([self.tmpKeyString isEqualToString:@"prestashop:carts:cart"]) {
		if ([attributeDict valueForKey:@"id"]) {
			[EwaterFeaturesAPI updateCartWithId:[attributeDict valueForKey:@"id"]];
		}
	}
	else if ([self.tmpKeyString isEqualToString:@"prestashop:countries:country"]) {
		if ([attributeDict valueForKey:@"id"]) {
			[EwaterFeaturesAPI updateCountryWithId:[attributeDict valueForKey:@"id"]];
		}
	}
	else if ([self.tmpKeyString isEqualToString:@"prestashop:states:state"]) {
		if ([attributeDict valueForKey:@"id"]) {
			[EwaterFeaturesAPI updateStateWithId:[attributeDict valueForKey:@"id"]];
		}
	}
	else if ([self.tmpKeyString isEqualToString:@"prestashop:order_states:order_state"]) {
		if ([attributeDict valueForKey:@"id"]) {
			[EwaterFeaturesAPI updateOrderStateWithId:[attributeDict valueForKey:@"id"]];
		}
	}
	
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    self.tmpInnerTagText = string; //INFO: text between tags
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	
	/*
	 NSLog(@"%s | tmpInnerTagText: %@", __PRETTY_FUNCTION__, self.tmpInnerTagText);
	 NSLog(@"%s | elementName: %@", __PRETTY_FUNCTION__, elementName);
	 NSLog(@"%s | END | key: %@", __PRETTY_FUNCTION__, self.tmpKeyString);
	 */
    
	if ([self.prestashopDictionary objectForKey:self.tmpKeyString] == nil) {
		NSMutableArray *values = [[NSMutableArray alloc] init];
		[values addObject:self.tmpInnerTagText];
		[self.prestashopDictionary setObject:values forKey:self.tmpKeyString];
	}
	else {
		NSMutableArray *values = [self.prestashopDictionary objectForKey:self.tmpKeyString];
		[values addObject:self.tmpInnerTagText];
		[self.prestashopDictionary setObject:values forKey:self.tmpKeyString];
	}
	
	//	[self.prestashopDictionary setObject:self.tmpInnerTagText forKey:self.tmpKeyString];
	
	if ([self.tmpKeyString isEqualToString:@"prestashop:product:associations:images:image:id"]) {
		NSLog(@"prestashop:product:associations:images:image:id = %@", self.tmpInnerTagText);
	}
	
	if ([self.tmpKeyString isEqualToString:@"prestashop:product"]) {
		//if (self.succesProductsHandler)
		if (self.succesProductHandler) {
			self.succesProductHandler(self.prestashopDictionary);
			self.succesProductHandler = nil;
		}
		else {
			self.succesProductsHandler(self.prestashopDictionary);
			self.prestashopDictionary = nil;
		}
	}
	else if ([self.tmpKeyString isEqualToString:@"prestashop:category"]) {
		if (self.succesCategoriesHandler)
			self.succesCategoriesHandler(self.prestashopDictionary);
		self.prestashopDictionary = nil;
	}
	else if ([self.tmpKeyString isEqualToString:@"prestashop:employee"]) {
		if (self.succesEmployeesHandler)
			self.succesEmployeesHandler(self.prestashopDictionary);
		[self.prestashopDictionary removeAllObjects];
		self.prestashopDictionary = nil;
	}
	else if ([self.tmpKeyString isEqualToString:@"prestashop:customer"]) {
		if (self.succesCustomersHandler)
			self.succesCustomersHandler(self.prestashopDictionary);
		self.prestashopDictionary = nil;
	}
	else if ([self.tmpKeyString isEqualToString:@"prestashop:address"]) {
		if (self.succesAddressesHandler)
			self.succesAddressesHandler(self.prestashopDictionary);
		self.prestashopDictionary = nil;
	}//
	else if ([self.tmpKeyString isEqualToString:@"prestashop:order"]) {
		if (self.succesOrderHandler) {
			self.succesOrderHandler(self.prestashopDictionary);
		}
		else if (self.succesOrdersHandler)
			self.succesOrdersHandler(self.prestashopDictionary);
		self.prestashopDictionary = nil;
	}
	else if ([self.tmpKeyString isEqualToString:@"prestashop:cart"]) {
		if (self.succesCartsHandler)
			self.succesCartsHandler(self.prestashopDictionary);
		self.prestashopDictionary = nil;
	}
	else if ([self.tmpKeyString isEqualToString:@"prestashop:country"]) {
		if (self.succesCountriesHandler)
			self.succesCountriesHandler(self.prestashopDictionary);
		self.prestashopDictionary = nil;
	}
	else if ([self.tmpKeyString isEqualToString:@"prestashop:state"]) {
		if (self.succesStatesHandler)
			self.succesStatesHandler(self.prestashopDictionary);
		self.prestashopDictionary = nil;
	}
	else if ([self.tmpKeyString isEqualToString:@"prestashop:order_state"]) {
		if (self.succesStatesHandler)
			self.succesOrderStatesHandler(self.prestashopDictionary);
		self.prestashopDictionary = nil;
	}
	else if ([self.tmpKeyString isEqualToString:@"prestashop:errors"]) {
		if (self.failHandler) {
			NSError *error = [[NSError alloc] initWithDomain:@"prestasop" code:42 userInfo:self.prestashopDictionary];
			NSLog(@"%s | prestashopDictionary: %@", __PRETTY_FUNCTION__, self.prestashopDictionary);
			self.failHandler(nil, error);//self.prestashopDictionary);
			self.failHandler = nil;
		}
		self.prestashopDictionary = nil;
	}
	else if ([self.tmpKeyString isEqualToString:@"prestashop"]) {
		NSLog(@"%s -- END parsing prestashop", __PRETTY_FUNCTION__);
		//		NSLog(@"%s | prestashopDictionary: %@", __PRETTY_FUNCTION__, self.prestashopDictionary);
		
		self.prestashopDictionary = nil;
	}
	
	int lengthToKeep = [self.tmpKeyString length] - ([elementName length] + 1);
	lengthToKeep = (lengthToKeep < 0) ? 0 : lengthToKeep;
	
	self.tmpKeyString = [self.tmpKeyString substringToIndex:lengthToKeep];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"Paser Error = %@", parseError);
	
    //TODO: Create Alert message error
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	NSLog(@"%s | prestashopDictionary: %@", __PRETTY_FUNCTION__, self.prestashopDictionary);
	
	//	[AppDelegate appDelegate].ewaterFeaturesAPI.numberOfCurrentResquest = [NSNumber numberWithInt:[[AppDelegate appDelegate].ewaterFeaturesAPI.numberOfCurrentResquest intValue] - 1];
	
	if (self.prestashopDictionary == nil || [self.prestashopDictionary count] == 0) {
		if (self.failHandler) {
			self.failHandler(nil, nil);
			NSLog(@"%s | %@", __PRETTY_FUNCTION__, @"No data");
			self.failHandler = nil;
			
		}
	}
	
}

//-------------------------------------------- UPDATE --------------------------------------------

+ (void)updateForCustomer:(void (^)(void))end {
	[Address truncateAll];
	
	[EwaterFeaturesAPI updateAddresses:^(NSMutableDictionary *result) {
//		NSLog(@"%s | Success update Address List: %@", __PRETTY_FUNCTION__, result);
		NSLog(@"%s | %@", __PRETTY_FUNCTION__, [AppDelegate appDelegate].ewaterFeaturesAPI.numberOfCurrentResquest);
		Address *address = [Address addUpdateAddressWhithDictionary:result];
		address = nil;
		result = nil;
//		NSLog(@"%s | %@", __PRETTY_FUNCTION__, [address description]);
		NSLog(@"%s | %@", __PRETTY_FUNCTION__, [AppDelegate appDelegate].ewaterFeaturesAPI.numberOfCurrentResquest);
		if ([[AppDelegate appDelegate].ewaterFeaturesAPI.numberOfCurrentResquest isEqualToNumber:@(0)]) {
			NSLog(@"END");
			end();
		}
		
	} failure:^(NSHTTPURLResponse *response, NSError *error) {
		NSLog(@"%s | Fail update Address List", __PRETTY_FUNCTION__);
		NSLog(@"%s | %@", __PRETTY_FUNCTION__, [AppDelegate appDelegate].ewaterFeaturesAPI.numberOfCurrentResquest);
		if ([[AppDelegate appDelegate].ewaterFeaturesAPI.numberOfCurrentResquest isEqualToNumber:@(0)]) {
			end();
		}
	}];
	
	//
	
	[Order truncateAll];
	//INFO: FAIL
	[EwaterFeaturesAPI updateOrders:^(NSMutableDictionary *result) {
//		NSLog(@"%s | Success update Order List: %@", __PRETTY_FUNCTION__, result);
//		NSLog(@"%s | %@", __PRETTY_FUNCTION__, [AppDelegate appDelegate].ewaterFeaturesAPI.numberOfCurrentResquest);
		Order *order = [Order addUpdateOrderWhithDictionary:result];
		order = nil;
		result = nil;
//		NSLog(@"%s | %@", __PRETTY_FUNCTION__, [order description]);
		NSLog(@"%s | %@", __PRETTY_FUNCTION__, [AppDelegate appDelegate].ewaterFeaturesAPI.numberOfCurrentResquest);
		if ([[AppDelegate appDelegate].ewaterFeaturesAPI.numberOfCurrentResquest isEqualToNumber:@(0)]) {
			end();
		}
		
	} failure:^(NSHTTPURLResponse *response, NSError *error) {
		NSLog(@"%s | Fail update Order List", __PRETTY_FUNCTION__);
		NSLog(@"%s | %@", __PRETTY_FUNCTION__, [AppDelegate appDelegate].ewaterFeaturesAPI.numberOfCurrentResquest);
		if ([[AppDelegate appDelegate].ewaterFeaturesAPI.numberOfCurrentResquest isEqualToNumber:@(0)]) {
			end();
		}
	}];
	
	[Product truncateAll];
	[EwaterFeaturesAPI updateProducts:^(NSMutableDictionary *result) {
		//		NSLog(@"%s | Success update Product List: %@", __PRETTY_FUNCTION__, result);
		Product *product = [Product addUpdateProductWithDictionary:result];
		product = nil;
		result = nil;
//		NSLog(@"%s | %@", __PRETTY_FUNCTION__, product);
		NSLog(@"%s | %@", __PRETTY_FUNCTION__, [AppDelegate appDelegate].ewaterFeaturesAPI.numberOfCurrentResquest);
		if ([[AppDelegate appDelegate].ewaterFeaturesAPI.numberOfCurrentResquest isEqualToNumber:@(0)]) {
			end();
		}
	} failure:^(NSHTTPURLResponse *response, NSError *error) {
		NSLog(@"%s | Fail update Product List", __PRETTY_FUNCTION__);
		if ([[AppDelegate appDelegate].ewaterFeaturesAPI.numberOfCurrentResquest isEqualToNumber:@(0)]) {
			end();
		}
	}];
	
	[Category truncateAll];
	[EwaterFeaturesAPI updateCategories:^(NSMutableDictionary *result) {
//		NSLog(@"%s | Success update Category List: %@", __PRETTY_FUNCTION__, result);
		
		NSLog(@"%s | %@", __PRETTY_FUNCTION__, [AppDelegate appDelegate].ewaterFeaturesAPI.numberOfCurrentResquest);
		Category *category = [Category addUpdateCategoryWithDictionary:result];
		category = nil;
		result = nil;
//		NSLog(@"%s | %@", __PRETTY_FUNCTION__, [category description]);
		if ([[AppDelegate appDelegate].ewaterFeaturesAPI.numberOfCurrentResquest isEqualToNumber:@(0)]) {
			end();
		}
	} failure:^(NSHTTPURLResponse *response, NSError *error) {
		NSLog(@"%s | Fail update Category List", __PRETTY_FUNCTION__);
		NSLog(@"%s | %@", __PRETTY_FUNCTION__, [AppDelegate appDelegate].ewaterFeaturesAPI.numberOfCurrentResquest);
		if ([[AppDelegate appDelegate].ewaterFeaturesAPI.numberOfCurrentResquest isEqualToNumber:@(0)]) {
			end();
		}
	}];
	
}

+ (void)updateForEmployee:(void (^)(void))end {
	[EwaterFeaturesAPI updateCustomers:^(NSMutableDictionary *result) {
//		NSLog(@"%s | Success update Customer List: %@", __PRETTY_FUNCTION__, result);
		NSLog(@"%s | %@", __PRETTY_FUNCTION__, [AppDelegate appDelegate].ewaterFeaturesAPI.numberOfCurrentResquest);
		if (result) {
			Customer *customer = [Customer addUpdateCustomerWithDictionary:result];
			customer = nil;
			result = nil;
//			NSLog(@"%s | %@", __PRETTY_FUNCTION__, [customer description]);
		}
		if ([[AppDelegate appDelegate].ewaterFeaturesAPI.numberOfCurrentResquest isEqualToNumber:@(0)]) {
			end();
		}
	} failure:^(NSHTTPURLResponse *response, NSError *error) {
		NSLog(@"%s | Fail update Customer List", __PRETTY_FUNCTION__);
		NSLog(@"%s | %@", __PRETTY_FUNCTION__, [AppDelegate appDelegate].ewaterFeaturesAPI.numberOfCurrentResquest);
		if ([[AppDelegate appDelegate].ewaterFeaturesAPI.numberOfCurrentResquest isEqualToNumber:@(0)]) {
			end();
		}

	}];
	
}

+ (void)updateBase:(void (^)(void))end {
	/*
	 [EwaterFeaturesAPI updateProducts:^(NSMutableDictionary *result) {
	 //		NSLog(@"%s | Success update Product List: %@", __PRETTY_FUNCTION__, result);
	 Product *product = [Product addUpdateProductWithDictionary:result];
	 NSLog(@"%s | %@", __PRETTY_FUNCTION__, product);
	 } failure:^(NSHTTPURLResponse *response, NSError *error) {
	 NSLog(@"%s | Fail update Product List", __PRETTY_FUNCTION__);
	 }];
	 
	 
	 
	 [EwaterFeaturesAPI updateEmployees:^(NSMutableDictionary *result) {
	 NSLog(@"%s | Success update Employee List: %@", __PRETTY_FUNCTION__, result);
	 Employee *employee = [Employee addUpdateEmployeeWithDictionary:result];
	 NSLog(@"%s | %@", __PRETTY_FUNCTION__, [employee description]);
	 
	 } failure:^(NSHTTPURLResponse *response, NSError *error) {
	 NSLog(@"%s | Fail update Employees List", __PRETTY_FUNCTION__);
	 }];
	 
	 */
	/*
	[EwaterFeaturesAPI updateCategories:^(NSMutableDictionary *result) {
		NSLog(@"%s | Success update Category List: %@", __PRETTY_FUNCTION__, result);
		
		NSLog(@"%s | %@", __PRETTY_FUNCTION__, [AppDelegate appDelegate].ewaterFeaturesAPI.numberOfCurrentResquest);
		Category *category = [Category addUpdateCategoryWithDictionary:result];
		NSLog(@"%s | %@", __PRETTY_FUNCTION__, [category description]);
		if ([[AppDelegate appDelegate].ewaterFeaturesAPI.numberOfCurrentResquest isEqualToNumber:@(0)]) {
			end();
		}
	} failure:^(NSHTTPURLResponse *response, NSError *error) {
		NSLog(@"%s | Fail update Category List", __PRETTY_FUNCTION__);
		NSLog(@"%s | %@", __PRETTY_FUNCTION__, [AppDelegate appDelegate].ewaterFeaturesAPI.numberOfCurrentResquest);
		if ([[AppDelegate appDelegate].ewaterFeaturesAPI.numberOfCurrentResquest isEqualToNumber:@(0)]) {
			end();
		}
	}];
	*/
	//	 */
	//	/*
	[EwaterFeaturesAPI updateCountries:^(NSMutableDictionary *result) {
		//	 NSLog(@"%s | Success update Country List: %@", __PRETTY_FUNCTION__, result);
		Country *country = [Country addUpdateCountryWithDictionary:result];
		country = nil;
		result = nil;
//		NSLog(@"%s | %@", __PRETTY_FUNCTION__, [country description]);
		NSLog(@"%s | %@", __PRETTY_FUNCTION__, [AppDelegate appDelegate].ewaterFeaturesAPI.numberOfCurrentResquest);
		if ([[AppDelegate appDelegate].ewaterFeaturesAPI.numberOfCurrentResquest isEqualToNumber:@(0)]) {
			end();
		}
	} failure:^(NSHTTPURLResponse *response, NSError *error) {
		NSLog(@"%s | Fail update Country List", __PRETTY_FUNCTION__);
		NSLog(@"%s | %@", __PRETTY_FUNCTION__, [AppDelegate appDelegate].ewaterFeaturesAPI.numberOfCurrentResquest);
		if ([[AppDelegate appDelegate].ewaterFeaturesAPI.numberOfCurrentResquest isEqualToNumber:@(0)]) {
			end();
		}
	}];
	//	 */
	
	[EwaterFeaturesAPI updateStates:^(NSMutableDictionary *result) {
		//	 NSLog(@"%s | Success update Country List: %@", __PRETTY_FUNCTION__, result);
		CountryState *countryState = [CountryState addUpdateStateWithDictionary:result];
		countryState = nil;
		result = nil;
//		NSLog(@"%s | %@", __PRETTY_FUNCTION__, [countryState description]);
		NSLog(@"%s | %@", __PRETTY_FUNCTION__, [AppDelegate appDelegate].ewaterFeaturesAPI.numberOfCurrentResquest);
		if ([[AppDelegate appDelegate].ewaterFeaturesAPI.numberOfCurrentResquest isEqualToNumber:@(0)]) {
			end();
		}
	} failure:^(NSHTTPURLResponse *response, NSError *error) {
		NSLog(@"%s | Fail update Country State List", __PRETTY_FUNCTION__);
		NSLog(@"%s | %@", __PRETTY_FUNCTION__, [AppDelegate appDelegate].ewaterFeaturesAPI.numberOfCurrentResquest);
		if ([[AppDelegate appDelegate].ewaterFeaturesAPI.numberOfCurrentResquest isEqualToNumber:@(0)]) {
			end();
		}
	}];
	
	[EwaterFeaturesAPI updateOrderStates:^(NSMutableDictionary *result) {
//		NSLog(@"%s | Success update Country List: %@", __PRETTY_FUNCTION__, result);
		OrderState *orderState = [OrderState addUpdateOrderStateWithDictionary:result];
		orderState = nil;
		result = nil;
//		NSLog(@"%s | %@", __PRETTY_FUNCTION__, [orderState description]);
		NSLog(@"%s | %@", __PRETTY_FUNCTION__, [AppDelegate appDelegate].ewaterFeaturesAPI.numberOfCurrentResquest);
		if ([[AppDelegate appDelegate].ewaterFeaturesAPI.numberOfCurrentResquest isEqualToNumber:@(0)]) {
			end();
		}
	} failure:^(NSHTTPURLResponse *response, NSError *error) {
//		NSLog(@"%s | Fail update Order State List", __PRETTY_FUNCTION__);
		NSLog(@"%s | %@", __PRETTY_FUNCTION__, [AppDelegate appDelegate].ewaterFeaturesAPI.numberOfCurrentResquest);
		if ([[AppDelegate appDelegate].ewaterFeaturesAPI.numberOfCurrentResquest isEqualToNumber:@(0)]) {
			end();
		}
	}];
	
	
	
}

@end
