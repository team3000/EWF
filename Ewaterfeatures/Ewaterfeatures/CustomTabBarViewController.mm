//
//  CustomTabBarViewController.m
//  locatemystickers
//
//  Created by Adrien Guffens on 10/29/12.
//  Copyright (c) 2012 Adrien Guffens. All rights reserved.
//

#import <QRCodeReader.h>

#import "CustomTabBarViewController.h"
#import "Customer.h"
#import "ProductDetailViewController.h"

#import "Product+Manager.h"
#import "UserSelectorViewController.h"

//#import "MainScreen.h"
#import <pdf417/PPBarcode.h>
#import "AccountViewController.h"

#import "HelperView.h"
#import "User.h"
#import "AppDelegate.h"

@interface CustomTabBarViewController ()

//@property (nonatomic, strong) MWScannerViewController *pdfScannerViewController;
@property (nonatomic, strong)NSMutableDictionary *coordinatorSettings;
 
@end

@implementation CustomTabBarViewController

- (id)initWithButtonImageName:(NSString *)imageName highlightImageName:(NSString *)highlightImageName {
	self.buttonImage = [UIImage imageNamed:imageName];
	self.highlightImage = [UIImage imageNamed:highlightImageName];
	
	self = [super init];
	if (self) {
		
	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
	self.buttonImage = [UIImage imageNamed:@"qrcode"];
	self.highlightImage = [UIImage imageNamed:@"qrcode"];
	
	
	
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	
	[button addTarget:self action:@selector(didTouchButton:) forControlEvents:UIControlEventTouchUpInside];
	
	button.frame = CGRectMake(0.0, 0.0, 38, 36);
	//ButtonImage.size.width, ButtonImage.size.height);
	//	button.frame = CGRectMake(0.0, 0.0, 60, 80);//ButtonImage.size.width, ButtonImage.size.height);
	//	button.frame = CGRectMake(0.0, 0.0, 60, 60);//ButtonImage.size.width, ButtonImage.size.height);
	
	[button setBackgroundImage:self.buttonImage forState:UIControlStateNormal];
	[button setBackgroundImage:self.highlightImage forState:UIControlStateHighlighted];
	
	CGFloat heightDifference = button.frame.size.height - self.tabBar.frame.size.height;
	if (heightDifference < 0) {
		CGPoint center = self.tabBar.center;
		center.y = center.y - 0.0;
		button.center = center;
	}
	
	else {
		CGPoint center = self.tabBar.center;
		center.y = (center.y - heightDifference / 2.0) - 0.0;
		button.center = center;
	}
	
	//[ImageTools addBorderToLayer:button.layer withBorderRaduis:4.0];
	
	[self.view addSubview:button];

	
	//
	
	[self isScanningUnsupported];
	[self setupPdfReader];
}

- (void)setupPdfReader {
	// Create object which stores pdf417 framework settings
	self.coordinatorSettings = [[NSMutableDictionary alloc] init];
	
	// Set YES/NO for scanning pdf417 barcode standard (default YES)
	[self.coordinatorSettings setValue:[NSNumber numberWithBool:YES] forKey:kPPRecognizePdf417Key];
	
	// Set YES/NO for scanning qr code barcode standard (default NO)
	[self.coordinatorSettings setValue:[NSNumber numberWithBool:YES] forKey:kPPRecognizeQrCodeKey];
	
	// Set the license key
//	[self.coordinatorSettings setValue:@"Enter_License_Key_Here" forKey:kPPLicenseKey];
	
	// present modal (recommended and default) - make sure you dismiss the view controller when done
	// you also can set this to NO and push camera view controller to navigation view controller
	[self.coordinatorSettings setValue:[NSNumber numberWithBool:YES] forKey:kPPPresentModal];
	
	// You can set orientation mask for allowed orientations, default is UIInterfaceOrientationMaskAll
	[self.coordinatorSettings setValue:[NSNumber numberWithInt:UIInterfaceOrientationMaskAll] forKey:kPPHudOrientation];
	
	// Define the sound filename played on successful recognition
//	NSString* soundPath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"mp3"];
//	[coordinatorSettings setValue:soundPath forKey:kPPSoundFile];
	
	[self.coordinatorSettings setValue:@"en" forKey:kPPLanguage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CustomTabBarProtocol




#pragma mark - ZXingWidgetController


- (void)handleProductAdding:(NSString *)result {
	UIStoryboard *storyboard = [AppDelegate mainStoryBoard];
	
	ProductDetailViewController *productDetailViewController = (ProductDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"productDetail"];

	
	
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:productDetailViewController];
	productDetailViewController.title = @"Product Details";
	productDetailViewController.customBackButtonEnable = YES;
	
	NSString *reference = [result stringByReplacingOccurrencesOfString:@"http://www.ewaterfeatures.com.au/products/" withString:@""];

	//INFO: setting product
	Product *product = [Product findFirstByAttribute:@"reference" withValue:reference];
	if (product) {
		productDetailViewController.product = product;
		[self presentViewController:navigationController animated:YES completion:nil];
	}
	
	
	
	
	/*
	 UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	 
	 [backButton setFrame:CGRectMake(10, 10, 60, 40)];
	 [backButton setImage:[UIImage imageNamed:@"blueBackButton"] forState:UIControlStateNormal];
	 UIBarButtonItem * leftBarButton =[[UIBarButtonItem alloc] initWithCustomView:backButton];
	 navigationController.navigationItem.leftBarButtonItem = leftBarButton;
	 
	 */
	
	

	//	[self.navigationController pushViewController:productDetailViewController animated:YES]; //presentViewController:productDetailViewController animated:YES completion:nil];
}



- (void)handleCustomerAdding:(NSString *)result {
	
	NSLog(@"%s %@", __PRETTY_FUNCTION__, result);
	
	if ([result rangeOfString:@"\t"].location == NSNotFound)
		return;
	NSArray* decodedResultList = [result componentsSeparatedByString: @"\t"];
	NSLog(@"%s | decodedResultList: %@", __PRETTY_FUNCTION__, decodedResultList);
	
	NSLog(@"firstname: %@", [decodedResultList objectAtIndex:2]);
	NSLog(@"lastname: %@", [decodedResultList objectAtIndex:4]);
	NSLog(@"company: %@", [decodedResultList objectAtIndex:6]);
	
	//TODO: check if already exist
	
	Customer *customer = [Customer createEntity];
	
	customer.firstname = [decodedResultList objectAtIndex:2];
	customer.lastname = [decodedResultList objectAtIndex:4];
	customer.company = [decodedResultList objectAtIndex:6];


	
	
	//Display a user list with a new button
	// if new button pressed display accountVC
	// else login
	
	UIStoryboard *storyboard = [AppDelegate mainStoryBoard];
	
	UserSelectorViewController *userSelectorViewController  = (UserSelectorViewController *)[storyboard instantiateViewControllerWithIdentifier:@"userSelector"];
	userSelectorViewController.selectedCustomer = customer;
	
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:userSelectorViewController];
	
	[self presentViewController:navigationController animated:YES completion:nil];
	

}


//-----


- (void)scanProduit {
	UIStoryboard *storyboard = [AppDelegate mainStoryBoard];
	
	self.scanWidgetController = (ScanWidgetController *)[storyboard instantiateViewControllerWithIdentifier:@"scanner"];
	
	[self.scanWidgetController setupWithDelegate:self showCancel:YES OneDMode:NO];
	QRCodeReader *qrcodeReader = [[QRCodeReader alloc] init];
	NSSet *readers = [[NSSet alloc ] initWithObjects:qrcodeReader, nil];
	self.scanWidgetController.readers = readers;
	
	[self presentViewController:self.scanWidgetController animated:YES completion:nil];
	
	if ([self.customTabBarDelegate respondsToSelector:@selector(didTouchButton:)]) {
		[self.customTabBarDelegate didTouchButton:self];
	}
}

- (void)scanClient {
	
	
	
	
	// Allocate the recognition coordinator object
	PPBarcodeCoordinator *coordinator = [[PPBarcodeCoordinator alloc] initWithSettings:self.coordinatorSettings];
//	[coordinatorSettings release];
	
	// Create camera view controller
	UIViewController *cameraViewController = [coordinator cameraViewControllerWithDelegate:self];
	
	// present it modally
	cameraViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[self presentViewController:cameraViewController animated:YES completion:nil];
	/*
	UIStoryboard *storyboard = [AppDelegate mainStoryBoard];
	
	self.pdfScannerViewController = (MWScannerViewController *)[storyboard instantiateViewControllerWithIdentifier:@"pdfScanner"];
	
	//PDF417
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(decodeResultNotification:) name:DecoderResultNotification object: nil];
	
	 
	 [self presentViewController:self.pdfScannerViewController animated:YES completion:nil];	
	 */
	
	//

	
//	[self.scanWidgetController setupWithDelegate:self showCancel:YES OneDMode:NO];
//	QRCodeReader *qrcodeReader = [[QRCodeReader alloc] init];
//	NSSet *readers = [[NSSet alloc ] initWithObjects:qrcodeReader, nil];
//	self.scanWidgetController.readers = readers;
	
}

#pragma mark - CustomTabBarProtocol

- (void)didTouchButton:(id)sender {
	
	if ([AppDelegate appDelegate].userType != UserTypeClient) {
		UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 0)];
		view.backgroundColor = [UIColor clearColor];
		
		HelperView *helperView = [[HelperView alloc] initWithTitle:@"Select Scanner Type" andView:view];
		
		[helperView addButtonWithTitle:@"Scan Product"
								  type:HelperViewButtonTypeDefault
							   handler:^(HelperView *helperView) {
								   NSLog(@"Scan Product Button Clicked");
								   [self performSelectorOnMainThread:@selector(scanProduit) withObject:nil waitUntilDone:NO];
							   }];
		
		[helperView addButtonWithTitle:@"Scan Client"
								  type:HelperViewButtonTypeDefault
							   handler:^(HelperView *helperView) {
								   NSLog(@"Scan Client Button Clicked");
								   [self performSelectorOnMainThread:@selector(scanClient) withObject:nil waitUntilDone:NO];
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
	else {
//		[self performSelectorOnMainThread:@selector(scanClient) withObject:nil waitUntilDone:NO];
		[self performSelectorOnMainThread:@selector(scanProduit) withObject:nil waitUntilDone:NO];
//		[self scanClient];
//		[self scanProduit];
	}
}

#pragma mark - ZXingWidgetController

- (void)zxingController:(ScanWidgetController *)controller didScanResult:(NSString *)result manualMode:(BOOL)manual {
	NSLog(@"result: %@", result);
	
	//INFO: dissmiss cureent view
	[self.scanWidgetController dismissViewControllerAnimated:YES completion:^ {
		[self performSelectorOnMainThread:@selector(handleProductAdding:) withObject:result waitUntilDone:NO];
	}];
	
	//INFO: show Sticker adding view
	
}

- (void)zxingControllerDidCancel:(ScanWidgetController *)controller {
	[self.scanWidgetController dismissViewControllerAnimated:YES completion:^ {
		//if ([AppDelegate appDelegate].debug == YES)
		//[self performSelectorOnMainThread:@selector(handleProductAdding:) withObject:@"DEBUG" waitUntilDone:NO];
	}];
	
}

#pragma mark - MWScannerViewController
/*
- (void)decodeResultNotification: (NSNotification *)notification {
	
	if ([notification.object isKindOfClass:[DecoderResult class]])
	{
		DecoderResult *obj = (DecoderResult*)notification.object;
		if (obj.succeeded)
		{
            NSString *decodeResult = [[NSString alloc] initWithString:obj.result];
			
			[self.pdfScannerViewController dismissViewControllerAnimated:YES completion:^ {
				[self performSelectorOnMainThread:@selector(handleCustomerAdding:) withObject:decodeResult waitUntilDone:NO];
			}];
//			[messageDlg show];
			
			//TODO: remove observer
		}
	}
}
*/

- (void)isScanningUnsupported {
	NSError *error;
	if ([PPBarcodeCoordinator isScanningUnsupported:&error]) {
		NSString *messageString = [error localizedDescription];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
														message:messageString
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil, nil];
		[alert show];
		return;
	}
}

#pragma mark - PPBarcodeDelegate

- (void)cameraViewControllerWasClosed:(UIViewController *)cameraViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cameraViewController:(UIViewController *)cameraViewController obtainedResult:(PPScanningResult *)result {
	
    NSString *message = [[NSString alloc] initWithData:[result data] encoding:NSUTF8StringEncoding];
	
    if (message == nil) {
        message = [[NSString alloc] initWithData:[result data] encoding:NSASCIIStringEncoding];
    }
	/*
    // log the result
    NSLog(@"Barcode text:\n%@", message);
	
    NSString* type = @"Result:";
    if ([result type] == PPScanningResultPdf417) {
        type = @"PDF417:";
    } else if ([result type] == PPScanningResultQrCode) {
        type = @"QR Code:";
    }
	
    // log the barcode type
    NSLog(@"Barcode type:\n%@", type);
	*/
	
//    [self setScanResult:result];
    [self dismissViewControllerAnimated:YES completion:^{
		[self performSelectorOnMainThread:@selector(handleCustomerAdding:) withObject:message waitUntilDone:NO];
	}];
}

@end
