//
//  AppDelegate.h
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 3/31/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import "LocationManager.h"
#import "SessionManager.h"
#import "ConnectionManager.h"
#import "EwaterFeaturesAPI.h"
#import "UCTabBarItem.h"
#import "User.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//@property (nonatomic, strong) LocationManager *locationManager;
@property (nonatomic, strong) SessionManager *sessionManager;
@property (nonatomic, strong) ConnectionManager *connectionManager;
@property (nonatomic, strong) EwaterFeaturesAPI *ewaterFeaturesAPI;

@property (nonatomic, assign) BOOL debug;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) UserType userType;

@property(strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property(strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property(strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


+ (NSURL *)applicationDocumentsDirectory;
+ (AppDelegate *)appDelegate;

+ (UIStoryboard *)mainStoryBoard;
+ (BOOL)deviceIsIpad;
+ (BOOL)deviceIsIO6;
+ (BOOL)deviceIsIO7;
/*
<prestashop xmlns:xlink="http://www.w3.org/1999/xlink">
<cart>
</id>
<id_address_delivery>5</id_address_delivery>
<id_address_invoice>5</id_address_invoice><id_currency>1</id_currency><id_customer>(null)</id_customer><id_guest>0</id_guest><id_lang>2</id_lang><id_shop_group>0</id_shop_group><id_shop>1</id_shop><id_carrier>0</id_carrier><gift>0</gift><associations><cart_rows><cart_row><id_product>2</id_product><id_product_attribute>18</id_product_attribute><quantity>1</quantity></cart_row>
</cart>
</prestashop>
 */

@end
