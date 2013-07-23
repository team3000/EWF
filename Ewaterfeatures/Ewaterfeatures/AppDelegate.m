//
//  AppDelegate.m
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 3/31/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "AppDelegate.h"
#import "HelperView.h"
/*
 #import "Product+Manager.h"
 #import "Category+Manager.h"
 #import "Employee+Manager.h"
 
 #import "Address+Manager.h"
 #import "Order+Manager.h"
 #import "Cart+Manager.h"
 #import "Country+Manager.h"
 
 #import "EwaterFeaturesAPI.h"
 */
#import "Customer+Manager.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:(v) options:NSNumericSearch] != NSOrderedAscending)

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	
	[self UIAppearances];
	
	//	[[UIFont fontWithName:@"" size:10] ]
	//	[[UILabel appearance] setFont:[UIFont fontWithName:@"Helvetica Neue-Light" size:17.0]];
	[self cleanUpCach];
	
	self.debug = YES;
	self.color = [UIColor colorWithRed:16/255.0 green:90.0/255.0 blue:165.0/255.0 alpha:1.0];
	self.userType = UserTypeClient;
	
	//	[MagicalRecord setupCoreDataStackWithStoreNamed:@"EwaterfeaturesModel"];
	
	//	[MagicalRecord setupAutoMigratingCoreDataStack];
	[MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"EwaterfeaturesModel"];
	
	
	//	self.sessionManager = [[SessionManager alloc] initWithHost:@"ks4003958.ip-142-4-212.net" key:@"2PWDS94YZUOT4TA2H3XRBY29DDJRTXCN" cookieKey:@"IKwsgN4bd74dCHAsMx5aOehpoxwJOxPZguY0Ibru68MOO4ydgAth2P9u"];
	self.sessionManager = [[SessionManager alloc] initWithHost:@"142.4.212.137" key:@"2PWDS94YZUOT4TA2H3XRBY29DDJRTXCN" cookieKey:@"IKwsgN4bd74dCHAsMx5aOehpoxwJOxPZguY0Ibru68MOO4ydgAth2P9u"];
	
	self.connectionManager = [ConnectionManager new];
	
	self.ewaterFeaturesAPI = [EwaterFeaturesAPI new];
	
	//TODO: finish to implement
	//[self commonLauchInitialization:launchOptions];
	
	//return YES;
	/*
	 Customer *customer = [Customer createEntity];
	 
	 customer.passwd =  @"12345678";
	 customer.lastname = @"Test";
	 customer.firstname = @"Adril";
	 customer.email = @"test@43.com";
	 customer.id_gender = @(3);
	 customer.newsletter = @(NO);
	 customer.optin = @(NO);
	 
	 [EwaterFeaturesAPI sendCustomer:customer success:^(NSMutableDictionary *result) {
	 [customer deleteEntity];
	 NSLog(@"%s | Success send Customer: %@", __PRETTY_FUNCTION__, result);
	 
	 Customer *customer = [Customer addUpdateCustomerWithDictionary:result];
	 NSLog(@"%s | %@", __PRETTY_FUNCTION__, [customer description]);
	 } failure:^(NSHTTPURLResponse *response, NSError *error) {
	 NSLog(@"%s | Fail send Customer", __PRETTY_FUNCTION__);
	 [customer deleteEntity];
	 }];
	 */
	
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
	 
	 
	 
	 [EwaterFeaturesAPI updateCategories:^(NSMutableDictionary *result) {
	 NSLog(@"%s | Success update Category List: %@", __PRETTY_FUNCTION__, result);
	 Category *category = [Category addUpdateCategoryWithDictionary:result];
	 NSLog(@"%s | %@", __PRETTY_FUNCTION__, [category description]);
	 } failure:^(NSHTTPURLResponse *response, NSError *error) {
	 NSLog(@"%s | Fail update Category List", __PRETTY_FUNCTION__);
	 }];
	 
	 [EwaterFeaturesAPI updateCustomers:^(NSMutableDictionary *result) {
	 NSLog(@"%s | Success update Customer List: %@", __PRETTY_FUNCTION__, result);
	 if (result) {
	 Customer *customer = [Customer addUpdateCustomerWithDictionary:result];
	 NSLog(@"%s | %@", __PRETTY_FUNCTION__, [customer description]);
	 }
	 } failure:^(NSHTTPURLResponse *response, NSError *error) {
	 NSLog(@"%s | Fail update Customer List", __PRETTY_FUNCTION__);
	 }];
	 
	 
	 [EwaterFeaturesAPI updateAddresses:^(NSMutableDictionary *result) {
	 NSLog(@"%s | Success update Address List: %@", __PRETTY_FUNCTION__, result);
	 Address *address = [Address addUpdateAddressWhithDictionary:result];
	 NSLog(@"%s | %@", __PRETTY_FUNCTION__, [address description]);
	 } failure:^(NSHTTPURLResponse *response, NSError *error) {
	 NSLog(@"%s | Fail update Address List", __PRETTY_FUNCTION__);
	 }];
	 */
	//
	
	/*
	 //INFO: FAIL
	 [EwaterFeaturesAPI updateOrders:^(NSMutableDictionary *result) {
	 NSLog(@"%s | Success update Order List: %@", __PRETTY_FUNCTION__, result);
	 Order *order = [Order addUpdateOrderWhithDictionary:result];
	 NSLog(@"%s | %@", __PRETTY_FUNCTION__, [order description]);
	 } failure:^(NSHTTPURLResponse *response, NSError *error) {
	 NSLog(@"%s | Fail update Order List", __PRETTY_FUNCTION__);
	 }];
	 */
	
	/*
	 [EwaterFeaturesAPI updateCarts:^(NSMutableDictionary *result) {
	 NSLog(@"%s | Success update Cart List: %@", __PRETTY_FUNCTION__, result);
	 Cart *cart = [Cart addUpdateCartWhithDictionary:result];
	 NSLog(@"%s | %@", __PRETTY_FUNCTION__, [cart description]);
	 } failure:^(NSHTTPURLResponse *response, NSError *error) {
	 NSLog(@"%s | Fail update Cart List", __PRETTY_FUNCTION__);
	 }];
	 */
	/*
	 [EwaterFeaturesAPI updateCountries:^(NSMutableDictionary *result) {
	 NSLog(@"%s | Success update Country List: %@", __PRETTY_FUNCTION__, result);
	 Country *country = [Country addUpdateCountryWithDictionary:result];
	 NSLog(@"%s | %@", __PRETTY_FUNCTION__, [country description]);
	 } failure:^(NSHTTPURLResponse *response, NSError *error) {
	 NSLog(@"%s | Fail update Country List", __PRETTY_FUNCTION__);
	 }];
	 
	 */
	
	
	//	[EwaterFeaturesAPI updateBase];
	
	
	
	/*
	 
	 Cart *cart = [Cart createEntity];
	 
	 cart.id_address_delivery = [NSNumber numberWithInt:5];
	 cart.id_address_invoice = [NSNumber numberWithInt:5];
	 cart.id_currency = [NSNumber numberWithInt:1];
	 cart.id_shop_group =[NSNumber numberWithInt:0];
	 cart.id_shop = [NSNumber numberWithInt:1];
	 cart.id_carrier = [NSNumber numberWithInt:0];
	 cart.secure_key = @"8285e12cb31256fb756c94937e629b7a";
	 NSNumber *id_customer = [AppDelegate appDelegate].sessionManager.session.customer.id_customer;
	 cart.id_customer = [NSNumber numberWithInt:2];
	 
	 [EwaterFeaturesAPI sendCart:cart success:^(NSMutableDictionary *result) {
	 NSLog(@"%s | Success send Cart: %@", __PRETTY_FUNCTION__, result);
	 Cart *cart = [Cart addUpdateCartWhithDictionary:result];
	 NSLog(@"%s | cart: %@", __PRETTY_FUNCTION__, [cart description]);
	 
	 
	 Order *order = [Order createEntity];
	 order.id_address_delivery = [NSNumber numberWithInt:5];
	 order.id_address_invoice = [NSNumber numberWithInt:5];
	 order.id_currency = [NSNumber numberWithInt:1];
	 order.id_cart = cart.id_cart;//[NSNumber numberWithInt:18];
	 order.id_carrier = [NSNumber numberWithInt:0];
	 order.id_currency = [NSNumber numberWithInt:1];
	 order.id_shop = [NSNumber numberWithInt:1];
	 order.id_shop_group = [NSNumber numberWithInt:0];
	 
	 
	 order.id_lang = [NSNumber numberWithInt:1];
	 order.id_customer = [NSNumber numberWithInt:2];
	 order.id_carrier = [NSNumber numberWithInt:1];
	 order.current_state = [NSNumber numberWithInt:1];
	 order.module = @"cheque";
	 order.secure_key = @"8285e12cb31256fb756c94937e629b7a";
	 order.payment = @"Cheque";
	 order.total_paid = [NSNumber numberWithDouble:160.26];
	 order.total_paid_real = [NSNumber numberWithDouble:160.26];
	 order.total_products = [NSNumber numberWithInt:129];
	 order.total_products_wt = [NSNumber numberWithDouble:154.28];
	 order.conversion_rate = [NSNumber numberWithDouble:1.0];
	 
	 
	 
	 [EwaterFeaturesAPI sendOrder:order success:^(NSMutableDictionary *result) {
	 NSLog(@"%s | Success send Order: %@", __PRETTY_FUNCTION__, result);
	 Order *order = [Order addUpdateOrderWhithDictionary:result];
	 NSLog(@"%s | order: %@", __PRETTY_FUNCTION__, [order description]);
	 
	 } failure:^(NSHTTPURLResponse *response, NSError *error) {
	 NSLog(@"%s | Fail send Order", __PRETTY_FUNCTION__);
	 }];
	 
	 
	 
	 } failure:^(NSHTTPURLResponse *response, NSError *error) {
	 NSLog(@"%s | Fail send Cart", __PRETTY_FUNCTION__);
	 }];
	 
	 */
	//	*/
    return YES;
}

- (void)commonLauchInitialization:(NSDictionary *)launchOptions
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		//		[MagicalRecord setupCoreDataStackWithStoreNamed:@"EwaterfeaturesModel"];
	});
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)cleanUpCach {
	/*
	 NSError *error;
	 NSURL *url = [[AppDelegate applicationDocumentsDirectory] URLByAppendingPathComponent:@"activityList"];
	 
	 [[NSFileManager defaultManager] removeItemAtURL:url error:&error];
	 
	 if (error) {
	 NSLog(@"ABAppDelegate: No cach to clean");
	 }
	 else
	 NSLog(@"ABAppDelegate: Cach clean");
	 */
}



#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
+ (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Tools

+ (AppDelegate *)appDelegate {
    return [[UIApplication sharedApplication] delegate];
}

+ (UIStoryboard *)mainStoryBoard {
	UIStoryboard *mainStoryboard = nil;
	if ([AppDelegate deviceIsIpad]) {
		//TODO: the same with ipad
		if ([AppDelegate deviceIsIO6]) {
			mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil];//6
		} else {
			mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad_iOS5" bundle:nil];//5
		}
		
	}
	else {
		if ([AppDelegate deviceIsIO6]) {
			mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];//6
		} else {
			mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone_iOS5" bundle:nil];//5
		}
	}
	return mainStoryboard;
}

+ (BOOL)deviceIsIpad {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
		return YES;
	}
	return NO;
}

+ (BOOL)deviceIsIO6 {
	return SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0");
}

+ (BOOL)deviceIsIO7 {
	return SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0");
}

#pragma mark - UIAppearances

- (void)UIAppearances {
	float deviceVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
	/*
	 if (deviceVersion >= 7.0) {
	 UIImage *tabBarImage = [UIImage imageNamed:@"navigation-bar"];//
	 [[UITabBar appearance] setBackgroundImage:tabBarImage];
	 
	 }
	 else */
	
	
	
	if (deviceVersion > 4.9) {
		
		
		UIImage *navBarImage = [UIImage imageNamed:@"navigation-bar"];//barre320x44
		[[UINavigationBar appearance] setBackgroundImage:navBarImage forBarMetrics:UIBarMetricsDefault];
		
		UIImage *tabBarBackground = [UIImage imageNamed:@"tabBar"];
		
		[[UITabBar appearance] setBackgroundImage:tabBarBackground];

		
		
		
		if (deviceVersion <= 7.0) {//INFO: remove = when 7 available
			
			NSDictionary *textTitleOptions = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, [UIColor whiteColor], UITextAttributeTextShadowColor, nil];
			[[UINavigationBar appearance] setTitleTextAttributes:textTitleOptions];

			
			//			UIImage *navBarImage = [UIImage imageNamed:@"navigation-bar"];//barre320x44
			//			[[UINavigationBar appearance] setBackgroundImage:navBarImage forBarMetrics:UIBarMetricsDefault];
			
			//[[UIToolbar appearance] setColor:[UIColor redColor]];//setBackgroundImage:navBarImage];
			
			
			UIImage *backButtonImage = [[UIImage imageNamed:@"blueBackButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 6)];
			[[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
			
			//INFO: Change the appearance of other navigation button
			UIImage *barButtonImage = [[UIImage imageNamed:@"blueNormalButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 6, 0, 6)];
			[[UIBarButtonItem appearance] setBackgroundImage:barButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
			
		}
	}
    else {
        //INFO: iOS 4.whatever and below
        //[self.tabBarController.tabBar insertSubview:imageView atIndex:0];
		
    }
	
	//INFO: set tabBar
	/*
	 */
	//[[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"selection-tab"]];
	
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
	
	//
	
	//	[[HelperView appearance] setMessageFont:[UIFont systemFontOfSize:13]];
	//    [[HelperView appearance] setTitleColor:[UIColor greenColor]];
	//    [[HelperView appearance] setMessageColor:[UIColor purpleColor]];
	
    [[HelperView appearance] setCornerRadius:12];
    [[HelperView appearance] setShadowRadius:20];
}

@end
