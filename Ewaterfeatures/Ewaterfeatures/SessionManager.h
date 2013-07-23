//
//  ABSessionManager.h
//  AB
//
//  Created by Adrien Guffens on 1/13/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Session.h"
#import "SessionDelegate.h"

typedef enum SessionState {
	authentication,
	authenticated,
	unAuthenticated,
	errorAuthentication
} SessionState;

@class SessionManager;
@class Customer;

typedef void(^SuccessSessionManagerHandler)(id result);
typedef void(^FailureSessionManagerHandler)(NSHTTPURLResponse *response, NSError *error);

@interface SessionManager : NSObject

@property (nonatomic, strong) Session *session;
@property (nonatomic, assign) SessionState sessionState;
@property (nonatomic, strong) id<SessionDelegate> delegate;

@property (nonatomic, copy) SuccessSessionManagerHandler successLogin;
@property (nonatomic, copy) FailureSessionManagerHandler failureLogin;

- (id)initWithHost:(NSString *)host key:(NSString *)key cookieKey:(NSString *)cookieKey;
- (void)setupSessionWithLogin:(NSString *)login password:(NSString *)password host:(NSString *)host key:(NSString *)key;
- (void)setupSessionWithLogin:(NSString *)login password:(NSString *)password;
- (void)setupSessionWithCustomer:(Customer *)customer;

- (BOOL)isAuthentified;

- (void)login:(SuccessSessionManagerHandler)success failure:(FailureSessionManagerHandler)failure;
//- (void)handleLoginResult;
- (void)logout;

//
+ (NSMutableURLRequest *)requestForRoute:(NSString *)route;

- (void)productList;

@end
