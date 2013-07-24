//
//  EwaterFeaturesAPI.h
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 6/10/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Product;
@class Cart;
@class Order;
@class Address;
@class CountryState;
@class Customer;

typedef void (^SuccesHandler)(NSMutableDictionary *result);
typedef void (^FailureHandler)(NSHTTPURLResponse *response, NSError *error);

@interface EwaterFeaturesAPI : NSObject <NSXMLParserDelegate>

@property (nonatomic, copy) SuccesHandler succesHandler;

@property (nonatomic, copy) SuccesHandler succesProductsHandler;
@property (nonatomic, copy) SuccesHandler succesCategoriesHandler;
@property (nonatomic, copy) SuccesHandler succesEmployeesHandler;

//
@property (nonatomic, copy) SuccesHandler succesProductHandler;
@property (nonatomic, copy) SuccesHandler succesOrderHandler;
//

@property (nonatomic, copy) SuccesHandler succesCustomersHandler;
@property (nonatomic, copy) SuccesHandler succesAddressesHandler;

@property (nonatomic, copy) FailureHandler failHandler;


@property (nonatomic, copy) SuccesHandler succesOrdersHandler;
@property (nonatomic, copy) SuccesHandler succesCartsHandler;
@property (nonatomic, copy) SuccesHandler succesCountriesHandler;
@property (nonatomic, copy) SuccesHandler succesStatesHandler;
@property (nonatomic, copy) SuccesHandler succesOrderStatesHandler;

@property (nonatomic, strong) NSNumber *numberOfCurrentResquest;

+ (NSMutableURLRequest *)defaultImageUrlRequestForProduct:(Product *)product;
+ (void)customerWithEmail:(NSString *)email success:(void (^)(NSMutableDictionary *result))success failure:(void (^)(NSHTTPURLResponse *response, NSError *error))failure;
+ (void)employeeWithEmail:(NSString *)email success:(void (^)(NSMutableDictionary *result))success failure:(void (^)(NSHTTPURLResponse *response, NSError *error))failure;

+ (void)customerListWithFirstName:(NSString *)firstName lastName:(NSString *)lastName company:(NSString *)company success:(void (^)(NSMutableDictionary *result))success failure:(void (^)(NSHTTPURLResponse *response, NSError *error))failure;

//

+ (void)sendCart:(Cart *)cart success:(void (^)(NSMutableDictionary *result))success failure:(void (^)(NSHTTPURLResponse *response, NSError *error))failure;
+ (void)sendOrder:(Order *)order success:(void (^)(NSMutableDictionary *result))success failure:(void (^)(NSHTTPURLResponse *response, NSError *error))failure;
+ (void)sendAddress:(Address *)address success:(void (^)(NSMutableDictionary *result))success failure:(void (^)(NSHTTPURLResponse *response, NSError *error))failure;
+ (void)sendCustomer:(Customer *)customer success:(void (^)(NSMutableDictionary *result))success failure:(void (^)(NSHTTPURLResponse *response, NSError *error))failure;
//


//

+ (void)updateAddress:(Address *)address success:(void (^)(NSMutableDictionary *result))success failure:(void (^)(NSHTTPURLResponse *response, NSError *error))failure;

//

+ (void)updateProducts:(SuccesHandler)success failure:(FailureHandler)failure;

+ (void)updateCategories:(SuccesHandler)success failure:(FailureHandler)failure;
+ (void)updateEmployees:(SuccesHandler)success failure:(FailureHandler)failure;

+ (void)updateCustomers:(SuccesHandler)success failure:(FailureHandler)failure;
+ (void)updateAddresses:(SuccesHandler)success failure:(FailureHandler)failure;

+ (void)updateOrders:(SuccesHandler)success failure:(FailureHandler)failure;
+ (void)updateCarts:(SuccesHandler)success failure:(FailureHandler)failure;
+ (void)updateCountries:(SuccesHandler)success failure:(FailureHandler)failure;
+ (void)updateStates:(SuccesHandler)success failure:(FailureHandler)failure;
+ (void)updateOrderStates:(SuccesHandler)success failure:(FailureHandler)failure;

//
+ (void)updateProductWithId:(NSString *)id_product success:(SuccesHandler)success failure:(FailureHandler)failure;
+ (void)updateOrderWithId:(NSString *)id_product success:(SuccesHandler)success failure:(FailureHandler)failure;
//

+ (void)parse:(NSMutableURLRequest *)request;
+ (void)parse:(NSMutableURLRequest *)request success:(SuccesHandler)success failure:(FailureHandler)failure;

//---

+ (void)updateForCustomer:(void (^)(void))end;
+ (void)updateForEmployee:(void (^)(void))end;
+ (void)updateBase:(void (^)(void))end;


@end
