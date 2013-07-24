//
//  CustomTabBarViewController.h
//  locatemystickers
//
//  Created by Adrien Guffens on 10/29/12.
//  Copyright (c) 2012 Adrien Guffens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTabBarProtocol.h"
#import "ScanWidgetController.h"
#import <pdf417/PPBarcode.h>

@interface CustomTabBarViewController : UITabBarController <ScanProtocol, PPBarcodeDelegate>

@property(nonatomic, strong)UIImage *buttonImage;
@property(nonatomic, strong)UIImage *highlightImage;
@property(nonatomic, strong)id<CustomTabBarProtocol> customTabBarDelegate;

@property (nonatomic, strong) ScanWidgetController *scanWidgetController;

- (id)initWithButtonImageName:(NSString *)imageName  highlightImageName:(NSString *)highlightImageName;


@end
