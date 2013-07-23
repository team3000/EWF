//
//  SessionManager.m
//  AB
//
//  Created by Adrien Guffens on 1/13/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "SessionManager.h"

#import "Customer.h"
#import "Customer+Manager.h"

#import "Employee.h"
#import "Employee+Manager.h"

#import "EwaterFeaturesAPI.h"

#import "AFNetworking.h"

#import "NSString+MD5.h"

#import "AppDelegate.h"

@interface SessionManager ()

@property (nonatomic, strong) NSOperationQueue* parseQueue;
@property (nonatomic, strong) NSString *tmpInnerTagText;


@end

@implementation SessionManager

- (id)initWithHost:(NSString *)host key:(NSString *)key cookieKey:(NSString *)cookieKey {
	self = [super init];
	if (self) {
		self.session = [Session new];
		
		self.session.host = host;
		self.session.key = key;
		self.session.cookieKey = cookieKey;
	}
	return  self;
}


- (void)setupSessionWithLogin:(NSString *)login password:(NSString *)password host:(NSString *)host key:(NSString *)key {
	
	
	self.session.login = login;
	self.session.password = password;
	self.session.host = host;
	self.session.key = key;
	
	[self setup];
}

- (void)setupSessionWithLogin:(NSString *)login password:(NSString *)password  {
	self.session.login = login;
	self.session.password = password;
	
	[self setup];
}

- (void)setupSessionWithCustomer:(Customer *)customer {
	self.session.login = customer.email;
	self.session.password = customer.passwd;
	
	self.session.customer = customer;
}

- (void)setup {
	self.sessionState = unAuthenticated;
	self.parseQueue = [[NSOperationQueue alloc] init];
}

- (BOOL)isAuthentified {
	return self.sessionState == authenticated;
}

- (BOOL)passwordIsValidForPassword:(NSString *)passwordEncoded {
	BOOL result = NO;
	
	if ([passwordEncoded length] > 0) {
		NSString *password = [NSString stringWithFormat:@"%@%@", self.session.cookieKey, self.session.password];
//		NSString *passwordEncoded = [password MD5String];
		
		if ([passwordEncoded isEqualToString:[password MD5String]])
			result = YES;
	}
	return result;
}


- (BOOL)passwordIsValidForCustomer:(Customer *)customer {
	BOOL result = NO;
	
	if (customer) {
		result = [self passwordIsValidForPassword:customer.passwd];//Email:self.session.login];
		/*
		 NSString *password = [NSString stringWithFormat:@"%@%@", self.session.cookieKey, self.session.password];
		 NSString *passwordEncoded = [password MD5String];
		 
		 if ([customer.passwd isEqualToString:passwordEncoded])
		 result = YES;
		 */
	}
	return result;
}

- (BOOL)passwordIsValidForEmployee:(Employee *)employee {
	BOOL result = NO;
	
	if (employee) {
		result = [self passwordIsValidForPassword:employee.passwd];
		/*
		 NSString *password = [NSString stringWithFormat:@"%@%@", self.session.cookieKey, self.session.password];
		 NSString *passwordEncoded = [password MD5String];
		 
		 if ([customer.passwd isEqualToString:passwordEncoded])
		 result = YES;
		 */
	}
	return result;
}

- (void)login:(SuccessSessionManagerHandler)success failure:(FailureSessionManagerHandler)failure {
	self.sessionState = authentication;
	self.successLogin = success;
	self.failureLogin = failure;
	
	
	[self employee:^(id result) {
		success(self);
	} failure:^(NSHTTPURLResponse *response, NSError *error) {
		[self customer:^(id result) {
			success(self);
		} failure:^(NSHTTPURLResponse *response, NSError *error) {
			failure(response, error);
		}];
	}];
	
#warning TODO
	//TODO: do for employees
	//- set the type of user in appDelegate
	/*
	[EwaterFeaturesAPI customerWithEmail:self.session.login success:^(NSMutableDictionary *result) {
		Customer *customer = [Customer addUpdateCustomerWithDictionary:result];
		//TODO: check if good password
		if ([self passwordIsValidForCustomer:customer] == YES) {
			self.session.employee = nil;
			self.session.customer = customer;
			[AppDelegate appDelegate].userType = UserTypeClient;
//
//			[EwaterFeaturesAPI updateForCustomer:^{
//#warning TO COMPLETE
//				NSLog(@"END updateForCustomer -- TO COMPLETE");
//			}];

			success(self);
		}
		else {
			//failure(nil, nil);
//			[self employee:success failure:failure];
			
			}
		NSLog(@"%s | %@",  __PRETTY_FUNCTION__, customer);
	} failure:^(NSHTTPURLResponse *response, NSError *error) {
//		failure(response, error);

	}];
	*/
	
//	[self employee:success failure:failure];
}

- (void)customer:(SuccessSessionManagerHandler)success failure:(FailureSessionManagerHandler)failure {
	
	[EwaterFeaturesAPI customerWithEmail:self.session.login success:^(NSMutableDictionary *result) {
		Customer *customer = [Customer addUpdateCustomerWithDictionary:result];
		//TODO: check if good password
		if ([self passwordIsValidForCustomer:customer] == YES) {
			self.session.employee = nil;
			self.session.customer = customer;
			[AppDelegate appDelegate].userType = UserTypeClient;
			/*
			 [EwaterFeaturesAPI updateForCustomer:^{
			 #warning TO COMPLETE
			 NSLog(@"END updateForCustomer -- TO COMPLETE");
			 }];
			 */
			success(self);
		}
		else {
			failure(nil, nil);
			//			[self employee:success failure:failure];
			
		}
		NSLog(@"%s | %@",  __PRETTY_FUNCTION__, customer);
	} failure:^(NSHTTPURLResponse *response, NSError *error) {
		//		failure(response, error);
		
	}];

}

- (void)employee:(SuccessSessionManagerHandler)success failure:(FailureSessionManagerHandler)failure {
	//ELSE for employee
	[EwaterFeaturesAPI employeeWithEmail:self.session.login success:^(NSMutableDictionary *result) {
		Employee *employee = [Employee addUpdateEmployeeWithDictionary:result];
		//TODO: check if good password
		if ([self passwordIsValidForEmployee:employee] == YES) {
			self.session.customer = nil;
			self.session.employee = employee;
			[AppDelegate appDelegate].userType = UserTypeSeller;
			/*
			 [EwaterFeaturesAPI updateForEmployee:^{
			 NSLog(@"--------------------------------------- END updateForEmployee");
			 }];
			 */
			success(self);
		}
		else {
			failure(nil, nil);
		}
		NSLog(@"%s | %@",  __PRETTY_FUNCTION__, employee);
	} failure:^(NSHTTPURLResponse *response, NSError *error) {
		failure(response, error);
	}];
}

+ (NSMutableURLRequest *)requestForRoute:(NSString *)route {
	SessionManager *sessionManager = [AppDelegate appDelegate].sessionManager;
	
	NSString *requestString = [NSString stringWithFormat:@"http://%@:@%@/api/%@", sessionManager.session.key, sessionManager.session.host, route];
	
	NSLog(@"%s | requestString: %@", __PRETTY_FUNCTION__, requestString);
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestString]];
	return request;
}

/*
 - (void)handleLoginResult {
 if ([self.delegate respondsToSelector:@selector(didFailLogin)])
 [self.delegate didFailLogin];
 
 self.sessionState = errorAuthentication;
 }
 */
- (void)logout {
	//TODO: remove the file [OK]
	self.sessionState = unAuthenticated;
	[AppDelegate appDelegate].userType = UserTypeUnknown;
	self.session.customer = nil;
	self.session.employee = nil;
#warning TODO
	
	/*NSURL *accessTokenFileUrl = [[AppDelegate applicationDocumentsDirectory] URLByAppendingPathComponent:@"accessToken"];
	 
	 NSFileManager *fileManager = [NSFileManager defaultManager];
	 [fileManager removeItemAtURL:accessTokenFileUrl error:NULL];
	 */
}

/*
 - (BOOL)saveFile:(NSData *)data {
 
 if (data) {
 NSURL *url = [[ABAppDelegate applicationDocumentsDirectory] URLByAppendingPathComponent:@"activityList"];
 return [data writeToURL:url atomically:YES];
 }
 return NO;
 }
 */

- (void)productList {
	
}

@end
