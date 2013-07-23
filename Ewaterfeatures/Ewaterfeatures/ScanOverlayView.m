/**
 * Copyright 2009 Jeff Verkoeyen
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "ScanOverlayView.h"
//#import "iToast.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
//#import "AppData.h"
//#import "ConfigManager.h"
//#import "DebugTools.h"

static const CGFloat kPadding = 5;

@interface ScanOverlayView()
@property (nonatomic,strong) UIBarButtonItem *cancelButton;
@property (nonatomic,strong) UIBarButtonItem *torchButton;
@property (nonatomic,retain) UILabel *topLabel;
@end

@implementation ScanOverlayView

@synthesize delegate, oneDMode;
@synthesize points = _points;
@synthesize cancelButton, torchButton;
@synthesize cropRect;
@synthesize topLabel;
@synthesize displayedMessage;
@synthesize viseurRect;

#pragma mark - Constructor

- (id) initWithFrame:(CGRect)theFrame cancelEnabled:(BOOL)isCancelEnabled oneDMode:(BOOL)isOneDModeEnabled {
	self = [super initWithFrame:theFrame];
	if (self) {
		CGFloat rectSize = self.frame.size.width - kPadding - kPadding * 2;
		if (!oneDMode) {
			cropRect = CGRectMake(kPadding, kPadding + kPadding + 40, rectSize, rectSize);
		} else {
			CGFloat rectSize2 = self.frame.size.height - kPadding * 2;
			cropRect = CGRectMake(kPadding, kPadding, rectSize, rectSize2);
		}
		//
		float coeff = 0.5;//[[[AppDelegate getAppData].configManager getParam:@"dol"] floatValue ];
		viseurRect = CGRectMake((self.frame.size.width - (self.frame.size.width * coeff)) / 2, (self.frame.size.height - (self.frame.size.width * coeff)) / 2 - 30,
								self.frame.size.width * coeff, self.frame.size.width*coeff);
			
		self.backgroundColor = [UIColor clearColor];
		self.oneDMode = isOneDModeEnabled;				
		
		// Black background around target
		UIColor *FillingColor = [UIColor blackColor];		
		UILabel *lab1 = [[UILabel alloc] init];
		[lab1 setBackgroundColor:FillingColor];
		lab1.frame = CGRectMake(0, 0, self.frame.size.width, viseurRect.origin.y);
		lab1.alpha = 0.4;
		[self addSubview:lab1];		
		UILabel *lab2 = [[UILabel alloc] init];
		[lab2 setBackgroundColor:FillingColor];
		lab2.frame = CGRectMake(0, viseurRect.origin.y, viseurRect.origin.x, viseurRect.size.height);
		lab2.alpha = 0.4;
		[self addSubview:lab2];		
		UILabel *lab3 = [[UILabel alloc] init];
		[lab3 setBackgroundColor:FillingColor];
		lab3.frame = CGRectMake(viseurRect.origin.x + viseurRect.size.width, viseurRect.origin.y,viseurRect.origin.x ,viseurRect.size.height);
		lab3.alpha = 0.4;
		[self addSubview:lab3];		
		UILabel *lab4 = [[UILabel alloc] init];
		[lab4 setBackgroundColor:FillingColor];
		lab4.frame = CGRectMake(0, viseurRect.origin.y + viseurRect.size.height, self.frame.size.width,self.frame.size.height - viseurRect.size.height - viseurRect.origin.y);
		lab4.alpha = 0.4;
		[self addSubview:lab4];
		/*
		// Top label
		self.topLabel = [[UILabel alloc] init];
		[self.topLabel setText:@""];
		[topLabel setFrame:CGRectMake(0,0,(self.frame.size.width),50)];
        centerLabel.font = [UIFont boldSystemFontOfSize: 35.0f];
		//topLabel.textAlignment = UITextAlignmentCenter;
		topLabel.alpha = 0.8;
        topLabel.numberOfLines = 2;
		[topLabel setHidden:YES];
		[self addSubview:topLabel];

		// Center label for extended information
		centerLabel = [[UILabel alloc] init];
		[centerLabel setText:@"Sortie"];
		[centerLabel setFrame:CGRectMake(0,55,(self.frame.size.width), 44)];
		centerLabel.alpha = 0.8;
		centerLabel.backgroundColor = [UIColor clearColor];
		centerLabel.font = [UIFont boldSystemFontOfSize: 58.0f];
		centerLabel.textColor = [UIColor whiteColor];
		//centerLabel.textAlignment = UITextAlignmentCenter;
		[centerLabel setHidden:YES];
		[self addSubview:centerLabel];
		

		// Bottom image for event
		self->bottomImage = [[UIImageView alloc] init];
		[bottomImage setFrame:CGRectMake(0,self.frame.size.height - 100,(self.frame.size.width), 100)];
		bottomImage.backgroundColor = [UIColor redColor];
		[bottomImage setHidden:YES];
		[self addSubview:bottomImage];
		*/
		
		// Battery image
		/*
		UIImage *imageBattery = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"battery.png" ofType:nil]];
		batteryButtonImg = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-85,40,100,100)];
		[batteryButtonImg setBackgroundImage:imageBattery forState:UIControlStateNormal];
		[batteryButtonImg setTitle:[NSString stringWithFormat:@"%1.0f%%",95.0] forState:UIControlStateNormal];
		[batteryButtonImg setHidden:YES];
		[self addSubview:batteryButtonImg];
		//INFO: batteryLevelWarning
		batteryLevelWarning = 1;//[[[AppDelegate getAppData].configManager getParam:@"BatteryLevelWarning"] floatValue ];
		if ( batteryLevelWarning <= 0 )
            batteryLevelWarning = 0;  
		 */
//		[self refreshBattery];
		
		
		//INFO: toolBar
		
		UIToolbar *topToolBar = [[UIToolbar alloc] init];
		
		
//		const float colorMask[6] = {222, 255, 222, 255, 222, 255};
//		UIImage *img = [[UIImage alloc] init];
//		UIImage *maskedImage = [UIImage imageWithCGImage: CGImageCreateWithMaskingColors(img.CGImage, colorMask)];
		UIImage *topBarImage = [UIImage imageNamed:@"navigation-bar"];
		
		[topToolBar setBackgroundImage:topBarImage forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
		//		[topToolBar setBarStyle:UIBarStyleBlack];
		//UIImage *navBarImage = [UIImage imageNamed:@"lms-navigation-bar"];
		//[topToolBar setBackgroundImage:navBarImage forToolbarPosition:UIToolbarPositionTop barMetrics:UIBarMetricsDefault];
		[topToolBar setBackgroundColor:[UIColor clearColor]];
		CGRect theRectForTopToolBar = CGRectMake(0, 0, self.frame.size.width, 64);
		[topToolBar setFrame:theRectForTopToolBar];

		

		NSMutableArray *items = [[NSMutableArray alloc] init];

		UIImage *cancelImage = [UIImage imageNamed:@"cancel-top_bar"];
		cancelButton = [[UIBarButtonItem alloc] initWithImage:cancelImage style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
		[items addObject:cancelButton];
		 
		 UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
		 [items addObject:spacer];

		
		UIImage *torchImage = [UIImage imageNamed:@"light-top_bar"];
		torchButton = [[UIBarButtonItem alloc] initWithImage:torchImage style:UIBarButtonItemStylePlain target:self action:@selector(torch:)];
		[items addObject:torchButton];

		
		/*
		 BOOL allowManualInput = true;
		 //allowManualInput = [[[AppDelegate getAppData].configManager getParam:@"AllowManualInput"] isEqualToString:@"true"];
		 if (allowManualInput)
		 {
		 UIBarButtonItem *manualEntry = [[UIBarButtonItem alloc] initWithTitle:@"Manual" style:UIBarButtonItemStyleBordered target:self action:@selector(manualEntryPressed)];
		 [items addObject:manualEntry];
		 }
		 */
		 //UIBarButtonItem *showList = [[UIBarButtonItem alloc] initWithTitle:@"Show list" style:UIBarButtonItemStyleBordered target:self action:@selector(showListPressed)];
		 //[items addObject:showList];
		 
		 [topToolBar setItems:items animated:YES];
		 
		 [self addSubview:topToolBar];

		
		
	}
	
	return self;
}

#pragma mark - Battery management

/*
-(void)refreshBattery {	
	UIDevice *myDevice = [UIDevice currentDevice];	
	[myDevice setBatteryMonitoringEnabled:YES];
	float batLeft = [myDevice batteryLevel] * 100;	
	NCLog(YES, @"battery left: %f", batLeft);
	if(batLeft < batteryLevelWarning && batLeft > 0) {
		[batteryButtonImg setTitle:[NSString stringWithFormat:@"%1.0f%%", batLeft] forState:UIControlStateNormal];
		[batteryButtonImg setHidden:NO];
	}
	else {
		[batteryButtonImg setHidden:YES];
	}
}
*/
- (void)cancel:(id)sender {	
	
	// call delegate to cancel this scanner
	if (delegate != nil) {
		[delegate cancelled];
	}	
}

- (void)torch:(id)sender {
	if (delegate != nil) {
		[delegate torch];
	}
}

- (void) dealloc {
}

#pragma mark - Graphics

- (void)drawRect:(CGRect)rect inContext:(CGContextRef)context {
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, rect.origin.x, rect.origin.y);
	CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y);
	CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
	CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + rect.size.height);
	CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y);
	CGContextStrokePath(context);
}

- (CGPoint)map:(CGPoint)point {
    CGPoint center;
    center.x = cropRect.size.width/2;
    center.y = cropRect.size.height/2;
    float x = point.x - center.x;
    float y = point.y - center.y;
    int rotation = 90;
    switch(rotation) {
		case 0:
			point.x = x;
			point.y = y;
			break;
		case 90:
			point.x = -y;
			point.y = x;
			break;
		case 180:
			point.x = -x;
			point.y = -y;
			break;
		case 270:
			point.x = y;
			point.y = -x;
			break;
    }
    point.x = point.x + center.x;
    point.y = point.y + center.y;
    return point;
}

#define kTextMargin 10

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	if (displayedMessage == nil) {
		self.displayedMessage = @"Placez le codebarre dans la fenetre pour le scanner.";
	}
	CGContextRef c = UIGraphicsGetCurrentContext();
	
	if (nil != _points) {
		//		[imageView.image drawAtPoint:cropRect.origin];
	}
	
	CGFloat white[4] = {1.0f, 1.0f, 1.0f, 1.0f};
	CGContextSetStrokeColor(c, white);
	CGContextSetFillColor(c, white);
	//[self drawRect:cropRect inContext:c];	
	
	[self drawRect:viseurRect inContext:c];
	CGContextSaveGState(c);
	if (oneDMode) {
		char *text = "Place a red line over the bar code to be scanned.";
		CGContextSelectFont(c, "Helvetica", 15, kCGEncodingMacRoman);
		CGContextScaleCTM(c, -1.0, 1.0);
		CGContextRotateCTM(c, M_PI/2);
		CGContextShowTextAtPoint(c, 74.0, 285.0, text, 49);
	}
	else {
	/*	UIFont *font = [UIFont systemFontOfSize:18];
		CGSize constraint = CGSizeMake(rect.size.width  - 2 * kTextMargin, cropRect.origin.y);
		CGSize displaySize = [self.displayedMessage sizeWithFont:font constrainedToSize:constraint];
		CGRect displayRect = CGRectMake((rect.size.width - displaySize.width) / 2 , cropRect.origin.y - displaySize.height, displaySize.width, displaySize.height);
		[self.displayedMessage drawInRect:displayRect withFont:font lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentCenter];*/
	}
	CGContextRestoreGState(c);
	int offset = rect.size.width / 2;
	
	if (oneDMode) {
		CGFloat red[4] = {1.0f, 0.0f, 0.0f, 1.0f};
		CGContextSetStrokeColor(c, red);
		CGContextSetFillColor(c, red);
		CGContextBeginPath(c);
		//		CGContextMoveToPoint(c, rect.origin.x + kPadding, rect.origin.y + offset);
		//		CGContextAddLineToPoint(c, rect.origin.x + rect.size.width - kPadding, rect.origin.y + offset);
		CGContextMoveToPoint(c, rect.origin.x + offset, rect.origin.y + kPadding);
		CGContextAddLineToPoint(c, rect.origin.x + offset, rect.origin.y + rect.size.height - kPadding);
		CGContextStrokePath(c);
	}
	if( nil != _points ) {
		CGFloat blue[4] = {0.0f, 1.0f, 0.0f, 1.0f};
		CGContextSetStrokeColor(c, blue);
		CGContextSetFillColor(c, blue);
		if (oneDMode) {
			CGPoint val1 = [self map:[[_points objectAtIndex:0] CGPointValue]];
			CGPoint val2 = [self map:[[_points objectAtIndex:1] CGPointValue]];
			CGContextMoveToPoint(c, offset, val1.x);
			CGContextAddLineToPoint(c, offset, val2.x);
			CGContextStrokePath(c);
		}
		else {
			CGRect smallSquare = CGRectMake(0, 0, 10, 10);
			for( NSValue* value in _points ) {
				CGPoint point = [self map:[value CGPointValue]];
				smallSquare.origin = CGPointMake(
												 cropRect.origin.x + point.x - smallSquare.size.width / 2,
												 cropRect.origin.y + point.y - smallSquare.size.height / 2);
				
				
				[self drawRect:smallSquare inContext:c];
			}
		}
	}
}

#pragma mark - Display infos methods

- (void)displayInfo:(NSString *)infos withColor:(UIColor *)backColor withImage:(UIImage *)img withComplement:(NSString *)complement {
	//[self refreshBattery];
	
	[bottomImage setFrame:CGRectMake(0, self.frame.size.height, (self.frame.size.width), 100)];
	[topLabel setFrame:CGRectMake(0, -topLabel.frame.size.height, 0, topLabel.frame.size.height)];
	[centerLabel setAlpha:0.0];
	
	[UIView beginAnimations:@"show" context:nil];
	[UIView setAnimationDuration:0.4];
	[UIView setAnimationDelegate:self];
	
	[topLabel setFrame:CGRectMake(0, 0, (self.frame.size.width), topLabel.frame.size.height)];
	[topLabel setHidden:NO];
	[self.topLabel setText:infos];	
	[self.topLabel setBackgroundColor:backColor];
	
	[centerLabel setHidden:YES];
	if (complement != nil && complement.length > 0) {
		[centerLabel setAlpha:1.0];
		[centerLabel setText:complement];
	    [centerLabel setHidden:NO];
	}
	
	[bottomImage setHidden:YES];
	if (img != nil) {
		[bottomImage setFrame:CGRectMake(0, self.frame.size.height - 100, (self.frame.size.width), 100)];
		[bottomImage setImage:img];
		[bottomImage setHidden:NO];
	}
	
	[UIView commitAnimations];
	
	if( displayTimer != nil )
		[displayTimer invalidate];
	displayTimer = [NSTimer scheduledTimerWithTimeInterval:3.0
												  target:self 
												selector:@selector(handleDisplayTimer:) 
												userInfo:nil repeats:NO];
	[[NSRunLoop mainRunLoop] addTimer:displayTimer forMode:NSDefaultRunLoopMode];
}

- (void)handleDisplayTimer:(NSTimer*)theTimer {
//	NCLog(YES, @"handleRestartTimer");	
	[UIView beginAnimations:@"hide" context:nil];
	[UIView setAnimationDuration:0.4];
	[UIView setAnimationDelegate:self];	
	[bottomImage setFrame:CGRectMake(0, self.frame.size.height + 120, (self.frame.size.width), 100)];
	[topLabel setFrame:CGRectMake(0, -topLabel.frame.size.height, (self.frame.size.width), topLabel.frame.size.height)];
	[centerLabel setAlpha:0.0];	
	[UIView commitAnimations];	
}	

- (UIImage*)image {
	return imageView.image;
}

@end
