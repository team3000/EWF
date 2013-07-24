//
//  LoginTableViewController.m
//  AB
//
//  Created by Adrien Guffens on 1/10/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "LoginTableViewController.h"
#import "UITextField+Extended.h"
#import "BButton.h"

#import "Customer.h"

#import "AppDelegate.h"
#import "Reachability.h"
#import <QuartzCore/QuartzCore.h>

#import "Config.h"


#import "AccountViewController.h"

static NSString* const keyHideKeyboard = @"hideKeyboard";
static NSString* const keyLoginResult = @"loginResult";

@interface LoginTableViewController ()

@end

@implementation LoginTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyboard:) name:keyHideKeyboard object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginResult:) name:keyLoginResult object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStatusChanged:) name:keyNetworkStatusChanged object:nil];
	
	[self setupSessionManager];
	[self setupStyle];
	
	self.loginTextField.nextTextField = self.passwordTextField;
	self.passwordTextField.nextTextField = nil;
	//
	
	//
	
	//INFO: hide keyboard
	UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
	[self.tableView addGestureRecognizer:gestureRecognizer];
	gestureRecognizer.cancelsTouchesInView = NO;
	
	
	//INFO: to save the cofig state
	
	Config *config = [Config findFirstByAttribute:@"id_config" withValue:@(1)];
	if (config == nil) {
		config = [Config createEntity];
		config.id_config = @(1);
		config.db_base_is_configured = @(NO);
		[[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];//save:nil];
	}
	
	if ([config.db_base_is_configured isEqualToNumber:@(NO)]) {
		[self.view addSubview:self.waitingView];
		[EwaterFeaturesAPI updateBase:^{
			[self.view addSubview:self.waitingView];
			//		self.waitingView.alpha = 1;
			[UIView animateWithDuration:0.3
							 animations:^{
								 self.waitingView.alpha = 0;
							 }
							 completion:^(BOOL finished) {
								 config.db_base_is_configured = @(YES);
//								 [[NSManagedObjectContext defaultContext] save:nil];
								 [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
								 [self.waitingView removeFromSuperview];
							 }];
		}];
	}

}

- (void)setupSessionManager {
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	
	[appDelegate.sessionManager setupSessionWithLogin:self.loginTextField.text password:self.passwordTextField.text];
}

- (void)setupStyle {
	
	//INFO: Background
	//	Default@2x.png
	///*
	//UIImage *backgroundImage = [UIImage imageNamed:@"BackgroundWhite"];
	UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.view.bounds];
	backgroundView.backgroundColor = [UIColor whiteColor];
	 [self.tableView setBackgroundView:backgroundView];
	//*/
	//INFO: Password TextField
	self.passwordTextField.borderStyle = UITextBorderStyleNone;
	
	self.passwordTextField.layer.masksToBounds = YES;
	self.passwordTextField.backgroundColor = [UIColor whiteColor];
    self.passwordTextField.layer.borderWidth = 1.0f;
	
	[[self.passwordTextField layer] setBorderColor:[[UIColor colorWithRed:231/255.0 green:238.0/255.0 blue:245.0/255.0 alpha:1.0] CGColor]];
	
	//INFO: Login TextField
	self.loginTextField.borderStyle = UITextBorderStyleNone;
	
	self.loginTextField.layer.masksToBounds = YES;
	self.loginTextField.backgroundColor = [UIColor whiteColor];
    self.loginTextField.layer.borderWidth = 1.0f;
	
	[[self.loginTextField layer] setBorderColor:[[UIColor colorWithRed:231/255.0 green:238.0/255.0 blue:245.0/255.0 alpha:1.0] CGColor]];
	
	//INFO: login Button
	[self.loginButton setType:BButtonTypeDefault];
	[self.loginButton setColor:[AppDelegate appDelegate].color];

	[self.signupButton setType:BButtonTypeDefault];
	[self.signupButton setColor:[UIColor colorWithRed:231/255.0 green:238.0/255.0 blue:245.0/255.0 alpha:1.0]];

}

- (void)viewDidAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
//	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	
	//TODO: check if the user is already connected
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:keyHideKeyboard];
	[[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:keyLoginResult];
	[[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:keyNetworkStatusChanged];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)awakeFromNib {
	[super awakeFromNib];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"loginSegue"]) {
		
		/*
		if ([self.loginTextField.text isEqualToString:@"adril.gu@gmail.com"]) {
			[AppDelegate appDelegate].userType = UserTypeSeller;
		}
		else if ([self.loginTextField.text isEqualToString:@"adril@hotmail.fr"]) {
			[AppDelegate appDelegate].userType = UserTypeClient;
		}
*/
		NSLog(@"login: %@ - password: %@", self.loginTextField.text, self.passwordTextField.text);
	}
}

#pragma mark - TextFields delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField;
{
	UITextField *next = textField.nextTextField;
	if (next) {
		[next becomeFirstResponder];
//		[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] atScrollPosition:0 animated:YES];//2
	} else {
		[textField resignFirstResponder];
		if (textField == self.passwordTextField)
			[self loginButton:nil];
	}
	//INFO: We do not want UITextField to insert line-breaks
	return NO;
}

#pragma mark - NSNotification - Hide Keyaboard

- (void)hideKeyboard:(NSNotification *)notification {
	if ([self.loginTextField isFirstResponder])
		[self.loginTextField resignFirstResponder];
	else if ([self.passwordTextField isFirstResponder])
		[self.passwordTextField resignFirstResponder];
//	[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:0 animated:YES];
}

#pragma mark - login

- (IBAction)loginButton:(id)sender {
	
	
	//
#warning TO REMOOVE
//	[EwaterFeaturesAPI updateForCustomer];
	
	//
	
	//INFO: to delete BEGIN
	//[self performSelectorOnMainThread:@selector(loadActivityViewController) withObject:nil waitUntilDone:NO];
	//return;
	//END
	
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	/*
	if (appDelegate.debug == YES) {
		[self performSegueWithIdentifier:@"loginSegue" sender:self];
		return;
	}
	*/
	if (appDelegate.connectionManager.hostActive == NO) {
		[self performSelectorOnMainThread:@selector(displayNetworkError) withObject:nil waitUntilDone:NO];
		return;
	}
	if ([self.loginTextField.text length] > 0 &&
		[self.passwordTextField.text length] > 0) {
		//TODO: do the login --> if success performSegueWithIdentifier
		
		self.loginAcivityIndicator.hidden = NO;
		self.loginButton.hidden = YES;
		[self.loginAcivityIndicator startAnimating];
		
		[self setupSessionManager];
		
		[appDelegate.sessionManager login:^(id result) {
			NSLog(@"%s | LOGGED", __PRETTY_FUNCTION__);
						
			SessionManager *sessionManager = (SessionManager *)result;

			
			NSLog(@"%s | loged with Customer: %@", __PRETTY_FUNCTION__, [sessionManager.session.customer description]);
			
			
//			[EwaterFeaturesAPI updateBase];
//			[EwaterFeaturesAPI updateForCustomer];
			[self performSegueWithIdentifier:@"loginSegue" sender:self];
			

		} failure:^(NSHTTPURLResponse *response, NSError *error) {
			NSLog(@"%s | LOGGED ERROR", __PRETTY_FUNCTION__);
			[self.loginAcivityIndicator stopAnimating];
			self.loginButton.hidden = NO;
			
		}];
		
	}
	else {
		//TODO: display error
	}
	//INFO: debug
}

#pragma mark - Signup

- (IBAction)signupButton:(id)sender {
	UIStoryboard *storyboard = [AppDelegate mainStoryBoard];
//	if (self.registrationMode == tracking) {
	{
	AccountViewController *accountViewController  = (AccountViewController *)[storyboard instantiateViewControllerWithIdentifier:@"account"];
		accountViewController.isSignup = YES;
	
		UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:accountViewController];
		
		[self presentViewController:navigationController animated:YES completion:nil];
	}
}

#pragma mark - Message Error

- (void)displayError {
#warning maybe bad alert message
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incorrect login" message:@"Username or password are incorrect." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	
	self.loginAcivityIndicator.hidden = YES;
	self.loginButton.hidden = NO;
	[self.loginAcivityIndicator stopAnimating];
}

- (void)displayNetworkError {
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incorrect login" message:@"Ingen Internett-tilkobling" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];
	
	self.loginAcivityIndicator.hidden = YES;
	self.loginButton.hidden = NO;
	[self.loginAcivityIndicator stopAnimating];
}

#pragma mark OAuth2

#pragma mark - Session Manager

- (void)loginResult:(NSNotification *)notification {
	//INFO: old way to be notify
}

- (void)networkStatusChanged:(NSNotification *)notification {
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if (appDelegate.connectionManager.hostActive == NO) {
		NSLog(@"Host unavailable");
		self.loginAcivityIndicator.hidden = YES;
		self.loginButton.hidden = NO;
		[self.loginAcivityIndicator stopAnimating];
		
		[self performSelectorOnMainThread:@selector(displayNetworkError) withObject:nil waitUntilDone:NO];
	}
}

#pragma mark - SessionDelegate

- (void)didFailLogin {
	self.loginAcivityIndicator.hidden = YES;
	self.loginButton.hidden = NO;
	[self.loginAcivityIndicator stopAnimating];
	
	[self performSelectorOnMainThread:@selector(displayNetworkError) withObject:nil waitUntilDone:NO];
	//[self performSelectorOnMainThread:@selector(displayError) withObject:nil waitUntilDone:NO];
}

- (void)didLogin {
	[self performSelectorOnMainThread:@selector(loadActivityViewController) withObject:nil waitUntilDone:NO];
}

/*
- (void)didReceiveValidToken {
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if ([appDelegate.sessionManager isAuthentified] == YES) {
		[self performSelectorOnMainThread:@selector(loadActivityViewController) withObject:nil waitUntilDone:NO];
	}
	else {
		//TODO: delete cookie
		//GO on login view
		self.loginAcivityIndicator.hidden = YES;
		self.loginButton.hidden = NO;
		[self.loginAcivityIndicator stopAnimating];
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Feil innlogging" message:@"Brukernavn eller passord er feil." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
	}
}
*/
@end
