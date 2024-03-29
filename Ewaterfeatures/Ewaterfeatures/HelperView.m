//
//  HelperView.m
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 6/4/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "HelperView.h"
#import "BButton.h"

#import "AppDelegate.h"

#import <QuartzCore/QuartzCore.h>

NSString *const HelperViewWillShowNotification = @"SIAlertViewWillShowNotification";
NSString *const HelperViewDidShowNotification = @"SIAlertViewDidShowNotification";
NSString *const HelperViewWillDismissNotification = @"SIAlertViewWillDismissNotification";
NSString *const HelperViewDidDismissNotification = @"SIAlertViewDidDismissNotification";

#define DEBUG_LAYOUT 0

#define MESSAGE_MIN_LINE_COUNT 3
#define MESSAGE_MAX_LINE_COUNT 5
#define GAP 10
#define CANCEL_BUTTON_PADDING_TOP 5
#define CONTENT_PADDING_LEFT 10
#define CONTENT_PADDING_TOP 12
#define CONTENT_PADDING_BOTTOM 10
#define BUTTON_HEIGHT 44
#define CONTAINER_WIDTH 300

@class HelperViewBackgroundWindow;

static NSMutableArray *__helper_view_queue;
static BOOL __helper_view_animating;
static HelperViewBackgroundWindow *__helper_view_background_window;
static HelperView *__helper_view_current_view;

@interface HelperView ()

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) UIWindow *alertWindow;
@property (nonatomic, assign, getter = isVisible) BOOL visible;

@property (nonatomic, strong) UILabel *titleLabel;
//@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIView *helperView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) NSMutableArray *buttons;

@property (nonatomic, assign, getter = isLayoutDirty) BOOL layoutDirty;

+ (NSMutableArray *)sharedQueue;
+ (HelperView *)currentHelperView;

+ (BOOL)isAnimating;
+ (void)setAnimating:(BOOL)animating;

+ (void)showBackground;
+ (void)hideBackgroundAnimated:(BOOL)animated;

- (void)setup;
- (void)invaliadateLayout;
- (void)resetTransition;

@end

#pragma mark - SIBackgroundWindow

@interface HelperViewBackgroundWindow : UIWindow

@end

@interface HelperViewBackgroundWindow ()

@property (nonatomic, assign) HelperViewBackgroundStyle style;

@end

@implementation HelperViewBackgroundWindow

- (id)initWithFrame:(CGRect)frame andStyle:(HelperViewBackgroundStyle)style
{
    self = [super initWithFrame:frame];
    if (self) {
        self.style = style;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.opaque = NO;
        self.windowLevel = UIWindowLevelAlert;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    switch (self.style) {
        case HelperViewBackgroundStyleGradient:
        {
            size_t locationsCount = 2;
            CGFloat locations[2] = {0.0f, 1.0f};
            CGFloat colors[8] = {0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.75f};
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, locationsCount);
            CGColorSpaceRelease(colorSpace);
            
            CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
            CGFloat radius = MIN(self.bounds.size.width, self.bounds.size.height) ;
            CGContextDrawRadialGradient (context, gradient, center, 0, center, radius, kCGGradientDrawsAfterEndLocation);
            CGGradientRelease(gradient);
            break;
        }
        case HelperViewBackgroundStyleSolid:
        {
            [[UIColor colorWithWhite:0 alpha:0.5] set];
            CGContextFillRect(context, self.bounds);
            break;
        }
    }
}

@end

#pragma mark - HelperViewItem

@interface HelperViewItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) HelperViewButtonType type;
@property (nonatomic, copy) HelperViewHandler action;

@end

@implementation HelperViewItem

@end

#pragma mark - HelperViewController

@interface HelperViewController : UIViewController

@property (nonatomic, strong) HelperView *helperView;

@end

@implementation HelperViewController

#pragma mark - View life cycle

- (void)loadView
{
    self.view = self.helperView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.helperView setup];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.helperView resetTransition];
    [self.helperView invaliadateLayout];
}

@end

#pragma mark - SIAlert

@implementation HelperView

+ (void)initialize
{
    if (self != [HelperView class])
        return;
    
    HelperView *appearance = [self appearance];
    appearance.titleColor = [UIColor blackColor];
    appearance.messageColor = [UIColor darkGrayColor];
    appearance.titleFont = [UIFont boldSystemFontOfSize:20];
    appearance.messageFont = [UIFont systemFontOfSize:16];
    appearance.buttonFont = [UIFont systemFontOfSize:[UIFont buttonFontSize]];
    appearance.cornerRadius = 2;
    appearance.shadowRadius = 8;
	
	[HelperView currentHelperView].backgroundStyle = HelperViewBackgroundStyleSolid;
}

- (id)init
{
	return [self initWithTitle:nil andMessage:nil];
}

- (id)initWithTitle:(NSString *)title andMessage:(NSString *)message {
	self = [super init];
	if (self) {
		_title = title;
        _message = message;
		[self setup];
		self.items = [[NSMutableArray alloc] init];	}
	return self;
}

- (id)initWithTitle:(NSString *)title andView:(UIView *)view {
	self = [super init];
	if (self) {
		_title = title;
        _helperView = view;
		//		[self addSubview:self.helperView];
		self.items = [[NSMutableArray alloc] init];	}
	return self;
}

#pragma mark - Class methods

+ (NSMutableArray *)sharedQueue
{
    if (!__helper_view_queue) {
        __helper_view_queue = [NSMutableArray array];
    }
    return __helper_view_queue;
}

+ (HelperView *)currentHelperView
{
    return __helper_view_current_view;
}

+ (void)setCurrentHelperView:(HelperView *)alertView
{
    __helper_view_current_view = alertView;
}

+ (BOOL)isAnimating
{
    return __helper_view_animating;
}

+ (void)setAnimating:(BOOL)animating
{
    __helper_view_animating = animating;
}

+ (void)showBackground
{
    if (!__helper_view_background_window) {
        __helper_view_background_window = [[HelperViewBackgroundWindow alloc] initWithFrame:[UIScreen mainScreen].bounds
																				   andStyle:[HelperView currentHelperView].backgroundStyle];
        [__helper_view_background_window makeKeyAndVisible];
        __helper_view_background_window.alpha = 0;
        [UIView animateWithDuration:0.3
                         animations:^{
                             __helper_view_background_window.alpha = 1;
                         }];
    }
}

+ (void)hideBackgroundAnimated:(BOOL)animated
{
    if (!animated) {
        [__helper_view_background_window removeFromSuperview];
        __helper_view_background_window = nil;
        return;
    }
    [UIView animateWithDuration:0.3
                     animations:^{
                         __helper_view_background_window.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [__helper_view_background_window removeFromSuperview];
                         __helper_view_background_window = nil;
                     }];
}

#pragma mark - Setters

- (void)setTitle:(NSString *)title
{
    _title = title;
	[self invaliadateLayout];
}

- (void)setMessage:(NSString *)message
{
	_message = message;
    [self invaliadateLayout];
}

#pragma mark - Public

- (void)addButtonWithTitle:(NSString *)title type:(HelperViewButtonType)type handler:(HelperViewHandler)handler
{
    HelperViewItem *item = [[HelperViewItem alloc] init];
	item.title = title;
	item.type = type;
	item.action = handler;
	[self.items addObject:item];
}

- (void)show
{
    if (![[HelperView sharedQueue] containsObject:self]) {
        [[HelperView sharedQueue] addObject:self];
    }
    
    if ([HelperView isAnimating]) {
        return; // wait for next turn
    }
    
    if (self.isVisible) {
        return;
    }
    
    if ([HelperView currentHelperView].isVisible) {
        HelperView *alert = [HelperView currentHelperView];
        [alert dismissAnimated:YES cleanup:NO];
        return;
    }
    
    if (self.willShowHandler) {
        self.willShowHandler(self);
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:HelperViewWillShowNotification object:self userInfo:nil];
    
    self.visible = YES;
    
    [HelperView setAnimating:YES];
    [HelperView setCurrentHelperView:self];
    
    // transition background
    [HelperView showBackground];
    
    HelperViewController *viewController = [[HelperViewController alloc] initWithNibName:nil bundle:nil];
    viewController.helperView = self;
    
    if (!self.alertWindow) {
        UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        window.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        window.opaque = NO;
        window.windowLevel = UIWindowLevelAlert;
        window.rootViewController = viewController;
        self.alertWindow = window;
    }
    [self.alertWindow makeKeyAndVisible];
    
    [self validateLayout];
    
    [self transitionInCompletion:^{
        if (self.didShowHandler) {
            self.didShowHandler(self);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:HelperViewDidShowNotification object:self userInfo:nil];
        
        [HelperView setAnimating:NO];
        
        NSInteger index = [[HelperView sharedQueue] indexOfObject:self];
        if (index < [HelperView sharedQueue].count - 1) {
            [self dismissAnimated:YES cleanup:NO]; // dismiss to show next alert view
        }
    }];
}

- (void)dismissAnimated:(BOOL)animated
{
    [self dismissAnimated:animated cleanup:YES];
}

- (void)dismissAnimated:(BOOL)animated cleanup:(BOOL)cleanup
{
    BOOL isVisible = self.isVisible;
    
    if (isVisible) {
        if (self.willDismissHandler) {
            self.willDismissHandler(self);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:HelperViewWillDismissNotification object:self userInfo:nil];
    }
    
    void (^dismissComplete)(void) = ^{
        self.visible = NO;
        
        [self teardown];
        
        [HelperView setCurrentHelperView:nil];
        
        HelperView *nextHelperView;
        NSInteger index = [[HelperView sharedQueue] indexOfObject:self];
        if (index != NSNotFound && index < [HelperView sharedQueue].count - 1) {
            nextHelperView = [HelperView sharedQueue][index + 1];
        }
        
        if (cleanup) {
            [[HelperView sharedQueue] removeObject:self];
        }
        
        [HelperView setAnimating:NO];
        
        if (isVisible) {
            if (self.didDismissHandler) {
                self.didDismissHandler(self);
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:HelperViewDidDismissNotification object:self userInfo:nil];
        }
        
        // check if we should show next alert
        if (!isVisible) {
            return;
        }
        
        if (nextHelperView) {
            [nextHelperView show];
        } else {
            // show last alert view
            if ([HelperView sharedQueue].count > 0) {
                HelperView *helperView = [[HelperView sharedQueue] lastObject];
                [helperView show];
            }
        }
    };
    
    if (animated && isVisible) {
        [HelperView setAnimating:YES];
        [self transitionOutCompletion:dismissComplete];
        
        if ([HelperView sharedQueue].count == 1) {
            [HelperView hideBackgroundAnimated:YES];
        }
        
    } else {
        dismissComplete();
        
        if ([HelperView sharedQueue].count == 0) {
            [HelperView hideBackgroundAnimated:YES];
        }
    }
}

#pragma mark - Transitions

- (void)transitionInCompletion:(void(^)(void))completion
{
    switch (self.transitionStyle) {
        case HelperViewTransitionStyleSlideFromBottom:
        {
            CGRect rect = self.containerView.frame;
            CGRect originalRect = rect;
            rect.origin.y = self.bounds.size.height;
            self.containerView.frame = rect;
            [UIView animateWithDuration:0.3
                             animations:^{
                                 self.containerView.frame = originalRect;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case HelperViewTransitionStyleSlideFromTop:
        {
            CGRect rect = self.containerView.frame;
            CGRect originalRect = rect;
            rect.origin.y = -rect.size.height;
            self.containerView.frame = rect;
            [UIView animateWithDuration:0.3
                             animations:^{
                                 self.containerView.frame = originalRect;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case HelperViewTransitionStyleFade:
        {
            self.containerView.alpha = 0;
            [UIView animateWithDuration:0.3
                             animations:^{
                                 self.containerView.alpha = 1;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case HelperViewTransitionStyleBounce:
        {
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            animation.values = @[@(0.01), @(1.2), @(0.9), @(1)];
            animation.keyTimes = @[@(0), @(0.4), @(0.6), @(1)];
            animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            animation.duration = 0.5;
            animation.delegate = self;
            [animation setValue:completion forKey:@"handler"];
            [self.containerView.layer addAnimation:animation forKey:@"bouce"];
        }
            break;
        case HelperViewTransitionStyleDropDown:
        {
            CGFloat y = self.containerView.center.y;
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
            animation.values = @[@(y - self.bounds.size.height), @(y + 20), @(y - 10), @(y)];
            animation.keyTimes = @[@(0), @(0.5), @(0.75), @(1)];
            animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            animation.duration = 0.4;
            animation.delegate = self;
            [animation setValue:completion forKey:@"handler"];
            [self.containerView.layer addAnimation:animation forKey:@"dropdown"];
        }
            break;
        default:
            break;
    }
}

- (void)transitionOutCompletion:(void(^)(void))completion
{
    switch (self.transitionStyle) {
        case HelperViewTransitionStyleSlideFromBottom:
        {
            CGRect rect = self.containerView.frame;
            rect.origin.y = self.bounds.size.height;
            [UIView animateWithDuration:0.3
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 self.containerView.frame = rect;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case HelperViewTransitionStyleSlideFromTop:
        {
            CGRect rect = self.containerView.frame;
            rect.origin.y = -rect.size.height;
            [UIView animateWithDuration:0.3
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 self.containerView.frame = rect;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case HelperViewTransitionStyleFade:
        {
            [UIView animateWithDuration:0.25
                             animations:^{
                                 self.containerView.alpha = 0;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case HelperViewTransitionStyleBounce:
        {
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            animation.values = @[@(1), @(1.2), @(0.01)];
            animation.keyTimes = @[@(0), @(0.4), @(1)];
            animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            animation.duration = 0.35;
            animation.delegate = self;
            [animation setValue:completion forKey:@"handler"];
            [self.containerView.layer addAnimation:animation forKey:@"bounce"];
            
            self.containerView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        }
            break;
        case HelperViewTransitionStyleDropDown:
        {
            CGPoint point = self.containerView.center;
            point.y += self.bounds.size.height;
            [UIView animateWithDuration:0.3
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 self.containerView.center = point;
                                 self.containerView.transform = CGAffineTransformMakeRotation(0.3);
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        default:
            break;
    }
}

- (void)resetTransition {
    [self.containerView.layer removeAllAnimations];
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    [self validateLayout];
}

- (void)invaliadateLayout {
    self.layoutDirty = YES;
    [self setNeedsLayout];
}

- (void)validateLayout {
    if (!self.isLayoutDirty) {
        return;
    }
    self.layoutDirty = NO;
#if DEBUG_LAYOUT
    NSLog(@"%@, %@", self, NSStringFromSelector(_cmd));
#endif
    
    CGFloat height = [self preferredHeight];
    CGFloat left = (self.bounds.size.width - CONTAINER_WIDTH) * 0.5;
    CGFloat top = (self.bounds.size.height - height) * 0.5;
    self.containerView.transform = CGAffineTransformIdentity;
    self.containerView.frame = CGRectMake(left, top, CONTAINER_WIDTH, height);
    self.containerView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.containerView.bounds cornerRadius:self.containerView.layer.cornerRadius].CGPath;
    
    CGFloat y = CONTENT_PADDING_TOP;
	if (self.titleLabel) {
        self.titleLabel.text = self.title;
        CGFloat height = [self heightForTitleLabel];
        self.titleLabel.frame = CGRectMake(CONTENT_PADDING_LEFT, y, self.containerView.bounds.size.width - CONTENT_PADDING_LEFT * 2, height);
        y += height;
	}
    if (self.helperView) {
        if (y > CONTENT_PADDING_TOP) {
            y += GAP;
        }
		//        self.messageLabel.text = self.message;
		
#warning TODO
        CGFloat height = [self heightForMessageLabel];
        self.helperView.frame = CGRectMake(CONTENT_PADDING_LEFT, y, self.containerView.bounds.size.width - CONTENT_PADDING_LEFT * 2, height);
        y += height;
    }
    if (self.items.count > 0) {
        if (y > CONTENT_PADDING_TOP) {
            y += GAP;
        }
        if (self.items.count == 2) {
            CGFloat width = (self.containerView.bounds.size.width - CONTENT_PADDING_LEFT * 2 - GAP) * 0.5;
            BButton *button = self.buttons[0];
            button.frame = CGRectMake(CONTENT_PADDING_LEFT, y, width, BUTTON_HEIGHT);
            button = self.buttons[1];
            button.frame = CGRectMake(CONTENT_PADDING_LEFT + width + GAP, y, width, BUTTON_HEIGHT);
        } else {
            for (NSUInteger i = 0; i < self.buttons.count; i++) {
                BButton *button = self.buttons[i];
                button.frame = CGRectMake(CONTENT_PADDING_LEFT, y, self.containerView.bounds.size.width - CONTENT_PADDING_LEFT * 2, BUTTON_HEIGHT);
                if (self.buttons.count > 1) {
                    if (i == self.buttons.count - 1 && ((HelperViewItem *)self.items[i]).type == HelperViewButtonTypeCancel) {
                        CGRect rect = button.frame;
                        rect.origin.y += CANCEL_BUTTON_PADDING_TOP;
                        button.frame = rect;
                    }
                    y += BUTTON_HEIGHT + GAP;
                }
            }
        }
    }
}

- (CGFloat)preferredHeight
{
	CGFloat height = CONTENT_PADDING_TOP;
	if (self.title) {
		height += [self heightForTitleLabel];
	}
    if (self.helperView) {
        if (height > CONTENT_PADDING_TOP) {
            height += GAP;
        }
        height += [self heightForMessageLabel];
    }
    if (self.items.count > 0) {
        if (height > CONTENT_PADDING_TOP) {
            height += GAP;
        }
        if (self.items.count <= 2) {
            height += BUTTON_HEIGHT;
        } else {
            height += (BUTTON_HEIGHT + GAP) * self.items.count - GAP;
            if (self.buttons.count > 2 && ((HelperViewItem *)[self.items lastObject]).type == HelperViewButtonTypeCancel) {
                height += CANCEL_BUTTON_PADDING_TOP;
            }
        }
    }
    height += CONTENT_PADDING_BOTTOM;
	return height;
}

- (CGFloat)heightForTitleLabel
{
    if (self.titleLabel) {
        CGSize size = [self.title sizeWithFont:self.titleLabel.font
                                   minFontSize:self.titleLabel.font.pointSize * self.titleLabel.minimumScaleFactor
                                actualFontSize:nil
                                      forWidth:CONTAINER_WIDTH - CONTENT_PADDING_LEFT * 2
                                 lineBreakMode:self.titleLabel.lineBreakMode];
        return size.height;
    }
    return 0;
}

- (CGFloat)heightForMessageLabel
{
	/*
	 CGFloat minHeight = MESSAGE_MIN_LINE_COUNT * self.messageLabel.font.lineHeight;
	 if (self.messageLabel) {
	 CGFloat maxHeight = MESSAGE_MAX_LINE_COUNT * self.messageLabel.font.lineHeight;
	 CGSize size = [self.message sizeWithFont:self.messageLabel.font
	 constrainedToSize:CGSizeMake(CONTAINER_WIDTH - CONTENT_PADDING_LEFT * 2, maxHeight)
	 lineBreakMode:self.messageLabel.lineBreakMode];
	 return MAX(minHeight, size.height);
	 }
	 */
    return self.helperView.frame.size.height;
}

#pragma mark - Setup

- (void)setup
{
    [self setupContainerView];
    [self updateTitleLabel];
    [self updateMessageLabel];
    [self setupButtons];
    [self invaliadateLayout];
}

- (void)teardown
{
    [self.containerView removeFromSuperview];
    self.containerView = nil;
    self.titleLabel = nil;
    self.helperView = nil;
    [self.buttons removeAllObjects];
    [self.alertWindow removeFromSuperview];
    self.alertWindow = nil;
}

- (void)setupContainerView
{
    self.containerView = [[UIView alloc] initWithFrame:self.bounds];
    self.containerView.backgroundColor = [UIColor whiteColor];
    self.containerView.layer.cornerRadius = self.cornerRadius;
    self.containerView.layer.shadowOffset = CGSizeZero;
    self.containerView.layer.shadowRadius = self.shadowRadius;
    self.containerView.layer.shadowOpacity = 0.5;
    [self addSubview:self.containerView];
	
	[self.containerView addSubview:self.helperView];
}

- (void)updateTitleLabel
{
	if (self.title) {
		if (!self.titleLabel) {
			self.titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
			self.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.titleLabel.backgroundColor = [UIColor clearColor];
			self.titleLabel.font = self.titleFont;
            self.titleLabel.textColor = self.titleColor;
            self.titleLabel.adjustsFontSizeToFitWidth = YES;
            self.titleLabel.minimumScaleFactor = 0.75;
			[self.containerView addSubview:self.titleLabel];
#if DEBUG_LAYOUT
            self.titleLabel.backgroundColor = [UIColor redColor];
#endif
		}
		self.titleLabel.text = self.title;
	} else {
		[self.titleLabel removeFromSuperview];
		self.titleLabel = nil;
	}
    [self invaliadateLayout];
}

- (void)updateMessageLabel {
	/*
	 if (self.message) {
	 if (!self.messageLabel) {
	 self.messageLabel = [[UILabel alloc] initWithFrame:self.bounds];
	 self.messageLabel.textAlignment = NSTextAlignmentCenter;
	 self.messageLabel.backgroundColor = [UIColor clearColor];
	 self.messageLabel.font = self.messageFont;
	 self.messageLabel.textColor = self.messageColor;
	 self.messageLabel.numberOfLines = MESSAGE_MAX_LINE_COUNT;
	 [self.containerView addSubview:self.messageLabel];
	 #if DEBUG_LAYOUT
	 self.messageLabel.backgroundColor = [UIColor redColor];
	 #endif
	 }
	 self.messageLabel.text = self.message;
	 } else {
	 [self.messageLabel removeFromSuperview];
	 self.messageLabel = nil;
	 }
	 */
    [self invaliadateLayout];
}

- (void)setupButtons {
    self.buttons = [[NSMutableArray alloc] initWithCapacity:self.items.count];
    for (NSUInteger i = 0; i < self.items.count; i++) {
        BButton *button = [self buttonForItemIndex:i];
        [self.buttons addObject:button];
        [self.containerView addSubview:button];
    }
}

- (BButton *)buttonForItemIndex:(NSUInteger)index
{
    HelperViewItem *item = self.items[index];
	BButton *button = [BButton buttonWithType:UIButtonTypeCustom];//buttonWithType:UIButtonTypeCustom];
	[button setType:BButtonTypeDefault];
	
	button.tag = index;
	button.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    button.titleLabel.font = self.buttonFont;
	[button setTitle:item.title forState:UIControlStateNormal];
	UIImage *normalImage = nil;
	UIImage *highlightedImage = nil;
	switch (item.type) {
		case HelperViewButtonTypeCancel:
			//normalImage = [UIImage imageNamed:@"SIAlertView.bundle/button-cancel"];
			//highlightedImage = [UIImage imageNamed:@"SIAlertView.bundle/button-cancel-d"];
			//[button setTitleColor:[UIColor colorWithWhite:0.3 alpha:1] forState:UIControlStateNormal];
            //[button setTitleColor:[UIColor colorWithWhite:0.3 alpha:0.8] forState:UIControlStateHighlighted];
			
			[button setColor:[UIColor colorWithRed:162/255.0 green:36.0/255.0 blue:60.0/255.0 alpha:1.0]];
			break;
		case HelperViewButtonTypeDestructive:
			//normalImage = [UIImage imageNamed:@"SIAlertView.bundle/button-destructive"];
			//highlightedImage = [UIImage imageNamed:@"SIAlertView.bundle/button-destructive-d"];
			//            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
			//            [button setTitleColor:[UIColor colorWithWhite:1 alpha:0.8] forState:UIControlStateHighlighted];
			[UIColor colorWithRed:162/255.0 green:36.0/255.0 blue:60.0/255.0 alpha:1.0];
			break;
		case HelperViewButtonTypeDefault:
		default:
			//			normalImage = [UIImage imageNamed:@"SIAlertView.bundle/button-default"];
			//			highlightedImage = [UIImage imageNamed:@"SIAlertView.bundle/button-default-d"];
			//			[button setTitleColor:[UIColor colorWithWhite:0.4 alpha:1] forState:UIControlStateNormal];
			//            [button setTitleColor:[UIColor colorWithWhite:0.4 alpha:0.8] forState:UIControlStateHighlighted];
			[button setColor:[AppDelegate appDelegate].color];
			
			//			[button setColor:[UIColor colorWithRed:162/255.0 green:36.0/255.0 blue:60.0/255.0 alpha:1.0]];
			break;
	}
	/*
	 CGFloat hInset = floorf(normalImage.size.width / 2);
	 CGFloat vInset = floorf(normalImage.size.height / 2);
	 UIEdgeInsets insets = UIEdgeInsetsMake(vInset, hInset, vInset, hInset);
	 normalImage = [normalImage resizableImageWithCapInsets:insets];
	 highlightedImage = [highlightedImage resizableImageWithCapInsets:insets];
	 [button setBackgroundImage:normalImage forState:UIControlStateNormal];
	 [button setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
	 */
	[button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

#pragma mark - Actions

- (void)buttonAction:(BButton *)button
{
	[HelperView setAnimating:YES]; // set this flag to YES in order to prevent showing another alert in action block
    HelperViewItem *item = self.items[button.tag];
	if (item.action) {
		item.action(self);
	}
	[self dismissAnimated:YES];
}

#pragma mark - CAAnimation delegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    void(^completion)(void) = [anim valueForKey:@"handler"];
    if (completion) {
        completion();
    }
}

#pragma mark - UIAppearance setters

- (void)setTitleFont:(UIFont *)titleFont
{
    if (_titleFont == titleFont) {
        return;
    }
    _titleFont = titleFont;
    self.titleLabel.font = titleFont;
    [self invaliadateLayout];
}

- (void)setMessageFont:(UIFont *)messageFont
{
    if (_messageFont == messageFont) {
        return;
    }
    _messageFont = messageFont;
	//    self.messageLabel.font = messageFont;
    [self invaliadateLayout];
}

- (void)setTitleColor:(UIColor *)titleColor
{
    if (_titleColor == titleColor) {
        return;
    }
    _titleColor = titleColor;
    self.titleLabel.textColor = titleColor;
}

- (void)setMessageColor:(UIColor *)messageColor
{
    if (_messageColor == messageColor) {
        return;
    }
    _messageColor = messageColor;
	//    self.messageLabel.textColor = messageColor;
}

- (void)setButtonFont:(UIFont *)buttonFont
{
    if (_buttonFont == buttonFont) {
        return;
    }
    _buttonFont = buttonFont;
    for (UIButton *button in self.buttons) {
        button.titleLabel.font = buttonFont;
    }
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    if (_cornerRadius == cornerRadius) {
        return;
    }
    _cornerRadius = cornerRadius;
    self.containerView.layer.cornerRadius = cornerRadius;
}

- (void)setShadowRadius:(CGFloat)shadowRadius
{
    if (_shadowRadius == shadowRadius) {
        return;
    }
    _shadowRadius = shadowRadius;
    self.containerView.layer.shadowRadius = shadowRadius;
}

@end
