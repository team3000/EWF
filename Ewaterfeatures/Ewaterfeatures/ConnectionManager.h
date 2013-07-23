//
//  NetworkManager.h
//  AB
//
//  Created by Adrien Guffens on 1/18/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString* const keyNetworkStatusChanged = @"networkStatusChanged";

@class Reachability;

@interface ConnectionManager : NSObject {
    Reachability *internetReachable;
    Reachability *hostReachable;
}

@property BOOL internetActive;
@property BOOL hostActive;

- (void)checkNetworkStatus:(NSNotification *)notice;

@end
