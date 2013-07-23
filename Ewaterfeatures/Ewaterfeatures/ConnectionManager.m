//
//  NetworkManager.m
//  AB
//
//  Created by Adrien Guffens on 1/18/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "ConnectionManager.h"
#import "Reachability.h"

@implementation ConnectionManager
@synthesize internetActive, hostActive;

-(id)init {
    self = [super init];
    if (self) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
		
		internetReachable = [Reachability reachabilityForInternetConnection];
		[internetReachable startNotifier];
		
		hostReachable = [Reachability reachabilityWithHostName:@"locatemystickers.com"];
		[hostReachable startNotifier];
	}
    return self;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

- (void)checkNetworkStatus:(NSNotification *)notice {
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];

	//BOOL savInternetActive = self.internetActive;
	BOOL savHostActive = self.hostActive;
	
    switch (internetStatus)
    {
        case NotReachable:
        {
#ifdef DEBUG
            NSLog(@"The internet is down.");
#endif
            self.internetActive = NO;
            break;
			
        }
        case ReachableViaWiFi:
        {
#ifdef DEBUG
            NSLog(@"The internet is working via WIFI.");
#endif
            self.internetActive = YES;
			
            break;
			
        }
        case ReachableViaWWAN:
        {
#ifdef DEBUG
            NSLog(@"The internet is working via WWAN.");
#endif
            self.internetActive = YES;
			
            break;
			
        }
    }
	
    NetworkStatus hostStatus = [hostReachable currentReachabilityStatus];
    switch (hostStatus)
    {
        case NotReachable:
        {
#ifdef DEBUG
            NSLog(@"A gateway to the host server is down.");
#endif
            self.hostActive = NO;
			
            break;
			
        }
        case ReachableViaWiFi:
        {
#ifdef DEBUG
            NSLog(@"A gateway to the host server is working via WIFI.");
#endif
            self.hostActive = YES;
			
            break;
			
        }
        case ReachableViaWWAN:
        {
#ifdef DEBUG
            NSLog(@"A gateway to the host server is working via WWAN.");
#endif
            self.hostActive = YES;
			
            break;
			
        }
    }
	if (hostActive != savHostActive)
		[[NSNotificationCenter defaultCenter] postNotificationName:keyNetworkStatusChanged object:self];
	/*else if (internetActive != savInternetActive)
		[[NSNotificationCenter defaultCenter] postNotificationName:keyNetworkStatusChanged object:self];*/
}

@end