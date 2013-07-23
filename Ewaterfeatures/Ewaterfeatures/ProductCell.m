//
//  ProductCell.m
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 5/2/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "ProductCell.h"



static CGFloat const kMCStop1 = 0.30; // Percentage limit to trigger the first action
static CGFloat const kMCStop2 = 0.2; // Percentage limit to trigger the second action
static CGFloat const kMCBounceAmplitude = 30.0; // Maximum bounce amplitude when using the MCSwipeTableViewCellModeSwitch mode
static NSTimeInterval const kMCBounceDuration1 = 0.2; // Duration of the first part of the bounce animation
static NSTimeInterval const kMCBounceDuration2 = 0.1; // Duration of the second part of the bounce animation
static NSTimeInterval const kMCDurationLowLimit = 0.25; // Lowest duration when swipping the cell because we try to simulate velocity
static NSTimeInterval const kMCDurationHightLimit = 0.1; // Highest duration when swipping the cell because we try to simulate velocity

@interface ProductCell ()  <UIGestureRecognizerDelegate>

// Init
- (void)initializer;

// Handle Gestures
- (void)handlePanGestureRecognizer:(UIPanGestureRecognizer *)gesture;

// Utils
- (CGFloat)offsetWithPercentage:(CGFloat)percentage relativeToWidth:(CGFloat)width;

- (CGFloat)percentageWithOffset:(CGFloat)offset relativeToWidth:(CGFloat)width;

- (NSTimeInterval)animationDurationWithVelocity:(CGPoint)velocity;

- (MCSwipeTableViewCellDirection)directionWithPercentage:(CGFloat)percentage;

- (NSString *)imageNameWithPercentage:(CGFloat)percentage;

- (UIColor *)colorWithPercentage:(CGFloat)percentage;

- (MCSwipeTableViewCellState)stateWithPercentage:(CGFloat)percentage;

- (CGFloat)imageAlphaWithPercentage:(CGFloat)percentage;

- (BOOL)validateState:(MCSwipeTableViewCellState)state;

// Movement
- (void)slideImageWithPercentage:(CGFloat)percentage imageName:(NSString *)imageName isDragging:(BOOL)isDragging;

- (void)animateWithOffset:(CGFloat)offset;

- (void)moveWithDuration:(NSTimeInterval)duration andDirection:(MCSwipeTableViewCellDirection)direction;

//- (void)bounceToOrigin;

// Delegate
- (void)notifyDelegate;

@property(nonatomic, assign) MCSwipeTableViewCellDirection direction;
@property(nonatomic, assign) CGFloat currentPercentage;

@property(nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property(nonatomic, strong) UIImageView *slidingImageView;
@property(nonatomic, strong) NSString *currentImageName;
@property(nonatomic, strong) UIView *colorIndicatorView;

@property(nonatomic, strong)UIButton *slidingButton;
@property(nonatomic, strong)UIButton *slidingButton1;
@property(nonatomic, strong)UIButton *slidingButton2;
@property(nonatomic, strong)UIButton *slidingButton3;
@property(nonatomic, strong)UIButton *slidingButton4;

@end


@implementation ProductCell

#pragma mark - Initialization

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	
    if (self) {
        [self initializer];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
	
    if (self) {
        [self initializer];
    }
    return self;
}

- (id)init {
    self = [super init];
	
    if (self) {
        [self initializer];
    }
	
    return self;
}

- (void)awakeFromNib {
	//self.imageView.image = nil;
	[super awakeFromNib];
}

#pragma mark - selected 

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
	
    // Configure the view for the selected state
	NSLog(@"%s %@", __PRETTY_FUNCTION__, selected ? @"Selected" : @"Unselected");
	if (selected == NO) {
		[self.contentView setBackgroundColor:[UIColor whiteColor]];
	}
	else {
		//INFO: display swipe menu
		/*
		CGFloat percentage = 100.0;
		
		_direction = [self directionWithPercentage:percentage];
		
		[self slideImageWithPercentage:percentage imageName:_currentImageName isDragging:NO];

		NSTimeInterval animationDuration = 0.3;
		[self moveWithDuration:animationDuration andDirection:_direction];

		
		CGPoint center = {self.contentView.center.x + 320, self.contentView.center.y};
        [self.contentView setCenter:center];
        [self animateWithOffset:CGRectGetMinX(self.contentView.frame)];	
		 */
		[self bounce];
	}
}


#pragma mark Custom Initializer

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
 firstStateIconName:(NSString *)firstIconName
         firstColor:(UIColor *)firstColor
secondStateIconName:(NSString *)secondIconName
        secondColor:(UIColor *)secondColor
      thirdIconName:(NSString *)thirdIconName
         thirdColor:(UIColor *)thirdColor
     fourthIconName:(NSString *)fourthIconName
        fourthColor:(UIColor *)fourthColor
	   fithIconName:(NSString *)fithIconName fithColor:(UIColor *)fithColor {
    self = [self initWithStyle:style reuseIdentifier:reuseIdentifier];
	
    if (self) {
        [self setFirstStateIconName:firstIconName
                         firstColor:firstColor
                secondStateIconName:secondIconName
                        secondColor:secondColor
                      thirdIconName:thirdIconName
                         thirdColor:thirdColor
                     fourthIconName:fourthIconName
                        fourthColor:fourthColor
					   fithIconName:fithIconName fithColor:fithColor];
    }
	
    return self;
}

- (void)initializer {
    _mode = MCSwipeTableViewCellModeSwitch;
	
	
	//	self.translatesAutoresizingMaskIntoConstraints = NO;
    _colorIndicatorView = [[UIView alloc] initWithFrame:self.bounds];
    [_colorIndicatorView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
	
	[self.colorIndicatorView addConstraint:
	 [NSLayoutConstraint
	  constraintWithItem:_colorIndicatorView attribute:NSLayoutAttributeLeft
	  relatedBy:0
	  toItem:self.colorIndicatorView attribute:NSLayoutAttributeLeft
	  multiplier:1 constant:0]];
	
	
	[_colorIndicatorView setBackgroundColor:[UIColor clearColor]];
    [self insertSubview:_colorIndicatorView belowSubview:self.contentView];
	
	
	
	/*
	 _slidingImageView = [[UIImageView alloc] init];
	 [_slidingImageView setContentMode:UIViewContentModeCenter];
	 [_colorIndicatorView addSubview:_slidingImageView];
	 */
	
	//INFO: buttons
	_slidingButton = [UIButton buttonWithType:UIButtonTypeCustom];
	//	[_slidingButton setImage:[UIImage imageNamed:@"mathematic-multiply2-icon-white"] forState:UIControlStateNormal];
	
	[_slidingButton addTarget:self action:@selector(handlePressButton:) forControlEvents:UIControlEventTouchDown];
    [_slidingButton setContentMode:UIViewContentModeCenter];
    [_colorIndicatorView addSubview:_slidingButton];
	
	_slidingButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
	//	[_slidingButton1 setImage:[UIImage imageNamed:@"editing-delete-icon-white"] forState:UIControlStateNormal];
	
	[_slidingButton1 addTarget:self action:@selector(handlePressButton:) forControlEvents:UIControlEventTouchDown];
    [_slidingButton1 setContentMode:UIViewContentModeCenter];
    [_colorIndicatorView addSubview:_slidingButton1];
	
	_slidingButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
	//	[_slidingButton2 setImage:[UIImage imageNamed:@"lms-icon-white"] forState:UIControlStateNormal];
	
	[_slidingButton2 addTarget:self action:@selector(handlePressButton:) forControlEvents:UIControlEventTouchDown];
    [_slidingButton2 setContentMode:UIViewContentModeCenter];
    [_colorIndicatorView addSubview:_slidingButton2];
	
	_slidingButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
	//	[_slidingButton3 setImage:[UIImage imageNamed:@"very-basic-globe-icon-white"] forState:UIControlStateNormal];
	
	
	[_slidingButton3 addTarget:self action:@selector(handlePressButton:) forControlEvents:UIControlEventTouchDown];
    [_slidingButton3 setContentMode:UIViewContentModeCenter];
    [_colorIndicatorView addSubview:_slidingButton3];
	
	
	_slidingButton4 = [UIButton buttonWithType:UIButtonTypeCustom];
	//	[_slidingButton4 setImage:[UIImage imageNamed:@"very-basic-refresh-icon-white"] forState:UIControlStateNormal];
	
	
	[_slidingButton4 addTarget:self action:@selector(handlePressButton:) forControlEvents:UIControlEventTouchDown];
    [_slidingButton4 setContentMode:UIViewContentModeCenter];
    [_colorIndicatorView addSubview:_slidingButton4];
	
	//
	float deviceVersion = [[[UIDevice currentDevice] systemVersion] floatValue];

#warning UIPanGestureRecognizer disable if ios >= 7.0
	if (deviceVersion < 7.0) {
		_panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestureRecognizer:)];

		[self addGestureRecognizer:_panGestureRecognizer];
		[_panGestureRecognizer setDelegate:self];
	}
	self.isActif = NO;
}

- (void)loadImage {
	[_slidingButton setImage:[UIImage imageNamed:_firstIconName] forState:UIControlStateNormal];
	[_slidingButton1 setImage:[UIImage imageNamed:_secondIconName] forState:UIControlStateNormal];
	[_slidingButton2 setImage:[UIImage imageNamed:_thirdIconName] forState:UIControlStateNormal];
	[_slidingButton3 setImage:[UIImage imageNamed:_fourthIconName] forState:UIControlStateNormal];
	[_slidingButton4 setImage:[UIImage imageNamed:_fithIconName] forState:UIControlStateNormal];
}

#pragma mark - Handle Gestures

- (void)handlePressButton:(id)sender {
	[self notifyDelegate];
	//[self bounceToOrigin];
	//INFO: notify delegate
	MCSwipeTableViewButtonState buttonState;
	if ([sender isEqual:_slidingButton]) {
		buttonState = MCSwipeTableViewButtonState1;
		[self bounceToOrigin];
	}
	else if ([sender isEqual:_slidingButton1])
		buttonState = MCSwipeTableViewButtonState2;
	else if ([sender isEqual:_slidingButton2])
		buttonState = MCSwipeTableViewButtonState3;
	else if ([sender isEqual:_slidingButton3])
		buttonState = MCSwipeTableViewButtonState4;
	else if ([sender isEqual:_slidingButton4])
		buttonState = MCSwipeTableViewButtonState5;
	
	
	if ([self.delegate respondsToSelector:@selector(swipeStickerTableViewCell:didTriggerButtonState:)]) {
		[self.delegate swipeStickerTableViewCell:self didTriggerButtonState:buttonState];
	}
}

- (void)handlePanGestureRecognizer:(UIPanGestureRecognizer *)gesture {
		
    UIGestureRecognizerState state = [gesture state];
    CGPoint translation = [gesture translationInView:self];
    CGPoint velocity = [gesture velocityInView:self];
    CGFloat percentage = [self percentageWithOffset:CGRectGetMinX(self.contentView.frame) relativeToWidth:CGRectGetWidth(self.bounds)];
    NSTimeInterval animationDuration = [self animationDurationWithVelocity:velocity];
    _direction = [self directionWithPercentage:percentage];
	
    if (state == UIGestureRecognizerStateBegan) {
    }
    else if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged) {
		NSLog(@"%@", self.contentView.constraints);
        CGPoint center = {self.contentView.center.x + translation.x, self.contentView.center.y};
        [self.contentView setCenter:center];
        [self animateWithOffset:CGRectGetMinX(self.contentView.frame)];
        [gesture setTranslation:CGPointZero inView:self];
    }
    else if (state == UIGestureRecognizerStateEnded || state == UIGestureRecognizerStateCancelled) {
        _currentImageName = [self imageNameWithPercentage:percentage];
        _currentPercentage = percentage;
        MCSwipeTableViewCellState cellState = [self stateWithPercentage:percentage];
		
        //if (_mode == MCSwipeTableViewCellModeExit &&
		//		if (_direction == MCSwipeTableViewCellDirectionR && [self validateState:cellState])
		
		NSLog(@"%s - cellState %d - _direction %d - validateState %d", __PRETTY_FUNCTION__, cellState, _direction, [self validateState:cellState]);
		//if (cellState != MCSwipeTableViewCellStateNone)
		if (_direction != MCSwipeTableViewCellDirectionCenter && [self validateState:cellState])
			[self moveWithDuration:animationDuration andDirection:_direction];
		else
			[self bounceToOrigin];
		//else
		//	[self notifyDelegate];
		//  [self bounceToOrigin]; --> original
    }
	
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == _panGestureRecognizer) {
        UIScrollView *superview = (UIScrollView *) self.superview;
        CGPoint translation = [(UIPanGestureRecognizer *) gestureRecognizer translationInView:superview];
		
        // Make sure it is scrolling horizontally
        return ((fabs(translation.x) / fabs(translation.y) > 1) ? YES : NO && (superview.contentOffset.y == 0.0 && superview.contentOffset.x == 0.0));
    }
    return NO;
}

#pragma mark - Utils

- (CGFloat)offsetWithPercentage:(CGFloat)percentage relativeToWidth:(CGFloat)width {
    CGFloat offset = percentage * width;
	
    if (offset < -width) offset = -width;
    else if (offset > width) offset = 1.0;
	
    return offset;
}

- (CGFloat)percentageWithOffset:(CGFloat)offset relativeToWidth:(CGFloat)width {
    CGFloat percentage = offset / width;
	
    if (percentage < -1.0) percentage = -1.0;
    else if (percentage > 1.0) percentage = 1.0;
	
    return percentage;
}

- (NSTimeInterval)animationDurationWithVelocity:(CGPoint)velocity {
    CGFloat width = CGRectGetWidth(self.bounds);
    NSTimeInterval animationDurationDiff = kMCDurationHightLimit - kMCDurationLowLimit;
    CGFloat horizontalVelocity = velocity.x;
	
    if (horizontalVelocity < -width) horizontalVelocity = -width;
    else if (horizontalVelocity > width) horizontalVelocity = width;
	
    return (kMCDurationHightLimit + kMCDurationLowLimit) - fabs(((horizontalVelocity / width) * animationDurationDiff));
}

- (MCSwipeTableViewCellDirection)directionWithPercentage:(CGFloat)percentage {
    if (percentage < -kMCStop1)
        return MCSwipeTableViewCellDirectionLeft;
    else if (percentage > kMCStop1)
        return MCSwipeTableViewCellDirectionRight;
    else
        return MCSwipeTableViewCellDirectionCenter;
}

- (NSString *)imageNameWithPercentage:(CGFloat)percentage {
    NSString *imageName;
	
    // Image
    if (percentage >= 0 && percentage < kMCStop2)
        imageName = _firstIconName;
    else if (percentage >= kMCStop2)
        imageName = _secondIconName;
    else if (percentage < 0 && percentage > -kMCStop2)
        imageName = _thirdIconName;
    else if (percentage <= -kMCStop2)
        imageName = _fourthIconName;
	
    return imageName;
}

- (CGFloat)imageAlphaWithPercentage:(CGFloat)percentage {
    CGFloat alpha;
	
    if (percentage >= 0 && percentage < kMCStop1)
        alpha = percentage / kMCStop1;
    else if (percentage < 0 && percentage > -kMCStop1)
        alpha = fabsf(percentage / kMCStop1);
    else alpha = 1.0;
	
    return alpha;
}

- (CGFloat)buttonAlphaWithPercentage:(CGFloat)percentage {
    CGFloat alpha;
	
    if (percentage >= 0 && percentage < kMCStop1)
        alpha = percentage / kMCStop1;
    else if (percentage < 0 && percentage > -kMCStop1)
        alpha = fabsf(percentage / kMCStop1);
    else alpha = 1.0;
	
    return alpha;
}

- (UIColor *)colorWithPercentage:(CGFloat)percentage {
    UIColor *color;
	
    // Background Color
    if (percentage >= kMCStop1 && percentage < kMCStop2)
        color = _firstColor;
    else if (percentage >= kMCStop2)
        color = _secondColor;
    else if (percentage < -kMCStop1 && percentage > -kMCStop2)
        color = _thirdColor;
    else if (percentage <= -kMCStop2)
        color = _fourthColor;
    else
        color = [UIColor colorWithRed:227.0 / 255.0 green:227.0 / 255.0 blue:227.0 / 255.0 alpha:1.0];//[UIColor redColor];//clear
	
    return color;
}

- (MCSwipeTableViewCellState)stateWithPercentage:(CGFloat)percentage {
    MCSwipeTableViewCellState state;
	
    state = MCSwipeTableViewCellStateNone;
	
    if (percentage >= kMCStop1 && [self validateState:MCSwipeTableViewCellState1])
        state = MCSwipeTableViewCellState1;
	
    if (percentage >= kMCStop2 && [self validateState:MCSwipeTableViewCellState2])
        state = MCSwipeTableViewCellState2;
	
    if (percentage <= -kMCStop1 && [self validateState:MCSwipeTableViewCellState3])
        state = MCSwipeTableViewCellState3;
	
    if (percentage <= -kMCStop2 && [self validateState:MCSwipeTableViewCellState4])
        state = MCSwipeTableViewCellState4;
	
    return state;
}

- (BOOL)validateState:(MCSwipeTableViewCellState)state {
    BOOL isValid = YES;
	
    switch (state) {
        case MCSwipeTableViewCellStateNone: {
            isValid = NO;
        }
            break;
			
        case MCSwipeTableViewCellState1: {
            if (!_firstColor && !_firstIconName)
                isValid = NO;
        }
            break;
			
        case MCSwipeTableViewCellState2: {
            if (!_secondColor && !_secondIconName)
                isValid = NO;
        }
            break;
			
        case MCSwipeTableViewCellState3: {
            if (!_thirdColor && !_thirdIconName)
                isValid = NO;
        }
            break;
			
        case MCSwipeTableViewCellState4: {
            if (!_fourthColor && !_fourthIconName)
                isValid = NO;
        }
            break;
			
        default:
            break;
    }
	
    return isValid;
}

#pragma mark - Movement

- (void)animateWithOffset:(CGFloat)offset {
    CGFloat percentage = [self percentageWithOffset:offset relativeToWidth:CGRectGetWidth(self.bounds)];
	
    // Image Name
    NSString *imageName = [self imageNameWithPercentage:percentage];
	CGFloat buttonAlpha = [self buttonAlphaWithPercentage:percentage];
	
    // Image Position
    if (imageName != nil) {
        //[_slidingImageView setImage:[UIImage imageNamed:imageName]];
        //[_slidingImageView setAlpha:[self imageAlphaWithPercentage:percentage]];
		
		//[_slidingButton setAlpha:[self buttonAlphaWithPercentage:percentage]];
    }
    [self slideImageWithPercentage:percentage imageName:imageName isDragging:YES];
	
	[_slidingButton setAlpha:buttonAlpha];
	[_slidingButton1 setAlpha:buttonAlpha];
	[_slidingButton2 setAlpha:buttonAlpha];
	[_slidingButton3 setAlpha:buttonAlpha];
	[_slidingButton4 setAlpha:buttonAlpha];
	
    // Color
    UIColor *color = [self colorWithPercentage:percentage];
    if (color != nil) {
        [_colorIndicatorView setBackgroundColor:color];
    }
}

- (void)slideImageWithPercentage:(CGFloat)percentage imageName:(NSString *)imageName isDragging:(BOOL)isDragging {
    UIImage *slidingImage = [UIImage imageNamed:imageName];
    CGSize slidingImageSize = slidingImage.size;
    CGRect slidingImageRect;
	
    CGPoint position = CGPointZero;
	
    position.y = CGRectGetHeight(self.bounds) / 2.0;
	
    if (isDragging) {
        if (percentage >= 0 && percentage < kMCStop1) {
            position.x = [self offsetWithPercentage:(kMCStop1 / 2) relativeToWidth:CGRectGetWidth(self.bounds)];
        }
		
        else if (percentage >= kMCStop1) {
            position.x = [self offsetWithPercentage:percentage - (kMCStop1 / 2) relativeToWidth:CGRectGetWidth(self.bounds)];
        }
        else if (percentage < 0 && percentage >= -kMCStop1) {
            position.x = CGRectGetWidth(self.bounds) - [self offsetWithPercentage:(kMCStop1 / 2) relativeToWidth:CGRectGetWidth(self.bounds)];
        }
		
        else if (percentage < -kMCStop1) {
            position.x = CGRectGetWidth(self.bounds) + [self offsetWithPercentage:percentage + (kMCStop1 / 2) relativeToWidth:CGRectGetWidth(self.bounds)];
        }
    }
    else {
        if (_direction == MCSwipeTableViewCellDirectionRight) {
            position.x = [self offsetWithPercentage:percentage - (kMCStop1 / 2) relativeToWidth:CGRectGetWidth(self.bounds)];
        }
        else if (_direction == MCSwipeTableViewCellDirectionLeft) {
            position.x = CGRectGetWidth(self.bounds) + [self offsetWithPercentage:percentage + (kMCStop1 / 2) relativeToWidth:CGRectGetWidth(self.bounds)];
        }
        else {
            return;
        }
    }
	
	
    slidingImageRect = CGRectMake(position.x - slidingImageSize.width / 2.0,
								  position.y - slidingImageSize.height / 2.0,
								  slidingImageSize.width,
								  slidingImageSize.height);
	
    slidingImageRect = CGRectIntegral(slidingImageRect);
    //[_slidingImageView setFrame:slidingImageRect];
	
	//INFO: button
	CGRect slidingButtonRect;
	slidingButtonRect = slidingImageRect;//[self buttonRectSizefromRect:slidingImageRect andPosition:position];
    [_slidingButton setFrame:slidingButtonRect];
	//
	
	//INFO: button
	CGRect slidingButtonRect1;
	slidingButtonRect1 = [self buttonRectSizefromRect:slidingButtonRect andPosition:position];
    [_slidingButton1 setFrame:slidingButtonRect1];
	//
	
	//INFO: button
	CGRect slidingButtonRect2;
	slidingButtonRect2 = [self buttonRectSizefromRect:slidingButtonRect1 andPosition:position];
    [_slidingButton2 setFrame:slidingButtonRect2];
	//
	//INFO: button
	CGRect slidingButtonRect3;
	slidingButtonRect3 = [self buttonRectSizefromRect:slidingButtonRect2 andPosition:position];
    [_slidingButton3 setFrame:slidingButtonRect3];
	//
	//INFO: button
	CGRect slidingButtonRect4;
	slidingButtonRect4 = [self buttonRectSizefromRect:slidingButtonRect3 andPosition:position];
    [_slidingButton4 setFrame:slidingButtonRect4];
	//
	
}


- (CGRect)buttonRectSizefromRect:(CGRect)inputRext andPosition:(CGPoint)position {
	
	float imageSize = 60.0;
	CGRect slidingRect;
	
	if (self.direction == MCSwipeTableViewCellDirectionLeft) {
		slidingRect = CGRectMake(inputRext.origin.x + ((imageSize / 2.0) + 40),
								 position.y - imageSize / 2.0,
								 imageSize,
								 imageSize);
	}
	else {
		slidingRect = CGRectMake(inputRext.origin.x - ((imageSize / 2.0) + 30),
								 position.y - imageSize / 2.0,
								 imageSize,
								 imageSize);
		
	}
	slidingRect = CGRectIntegral(slidingRect);
	return slidingRect;
}


- (void)moveWithDuration:(NSTimeInterval)duration andDirection:(MCSwipeTableViewCellDirection)direction {
    CGFloat origin;
	
    if (direction == MCSwipeTableViewCellDirectionLeft)
        origin = -CGRectGetWidth(self.bounds);// + 40;//Margin == 40
    else
        origin = CGRectGetWidth(self.bounds);// - 40;
	
    CGFloat percentage = [self percentageWithOffset:origin relativeToWidth:CGRectGetWidth(self.bounds)];
    CGRect rect = self.contentView.frame;
    rect.origin.x = origin;
	
    // Color
    UIColor *color = [self colorWithPercentage:_currentPercentage];
    if (color != nil) {
        [_colorIndicatorView setBackgroundColor:color];
    }
	
    // Image
    if (_currentImageName != nil) {
        //[_slidingImageView setImage:[UIImage imageNamed:_currentImageName]];
		//		_slidingButton.alpha = 1.0;
    }
	
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
						 NSLog(@"%s - %@", __PRETTY_FUNCTION__, self.contentView);
                         [self.contentView setFrame:rect];
                         //[_slidingImageView setAlpha:0];
						 //[_slidingButton setAlpha:0];
                         [self slideImageWithPercentage:percentage imageName:_currentImageName isDragging:NO];
						 NSLog(@"%s - %f", __PRETTY_FUNCTION__, percentage);
						 
                     }
                     completion:^(BOOL finished) {
                         //[self notifyDelegate];
                     }];
}

- (void)bounceToOrigin {
    CGFloat bounceDistance = kMCBounceAmplitude * _currentPercentage;
	NSLog(@"bounceDistance: %f", bounceDistance);
	
    [UIView animateWithDuration:kMCBounceDuration1
                          delay:0
                        options:(UIViewAnimationOptionCurveEaseOut)
                     animations:^{
                         CGRect frame = self.contentView.frame;
                         frame.origin.x = -bounceDistance;
                         [self.contentView setFrame:frame];
                         [_slidingImageView setAlpha:0.0];
						 [_slidingButton setAlpha:0];
						 [self slideImageWithPercentage:0 imageName:_currentImageName isDragging:NO];
						 float deviceVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
						 
#warning bug fix: enable if ios >= 7.0
						 if (deviceVersion >= 7.0) {
							 _colorIndicatorView.backgroundColor = [UIColor clearColor];
						 }
                     }
                     completion:^(BOOL finished1) {
						 
                         [UIView animateWithDuration:kMCBounceDuration2
                                               delay:0
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              CGRect frame = self.contentView.frame;
                                              frame.origin.x = 0;
                                              [self.contentView setFrame:frame];
                                          }
                                          completion:^(BOOL finished2) {
											  //											  [self notifyDelegate];
											  self.direction = MCSwipeTableViewCellDirectionLeft;
											  self.currentPercentage = 0;//fabs(self.currentPercentage);
//											  self.slidingImageView.hidden = YES;
											  
											  dispatch_async(dispatch_get_main_queue(), ^{
//												  self.contentView.hidden = YES;
// _colorIndicatorView.backgroundColor = [UIColor clearColor];
											  });
											   
										  }];

                     }];
	
}

- (void)bounce {
	CGFloat percentage = 100.0;
	
	_direction = [self directionWithPercentage:percentage];
	
	[self slideImageWithPercentage:percentage imageName:_currentImageName isDragging:NO];
	
	NSTimeInterval animationDuration = 0.3;
	[self moveWithDuration:animationDuration andDirection:_direction];
	
	
	CGPoint center = {self.contentView.center.x + 320, self.contentView.center.y};
	[self.contentView setCenter:center];
	[self animateWithOffset:CGRectGetMinX(self.contentView.frame)];
}

#pragma mark - Delegate Notification

- (void)notifyDelegate {
    MCSwipeTableViewCellState state = [self stateWithPercentage:_currentPercentage];
	
    if (state != MCSwipeTableViewCellStateNone) {
        if (_delegate != nil && [_delegate respondsToSelector:@selector(swipeStickerTableViewCell:didTriggerState:withMode:)]) {
            [_delegate swipeStickerTableViewCell:self didTriggerState:state withMode:_mode];
        }
    }
}

#pragma mark - Setter

- (void)setFirstStateIconName:(NSString *)firstIconName
                   firstColor:(UIColor *)firstColor
          secondStateIconName:(NSString *)secondIconName
                  secondColor:(UIColor *)secondColor
                thirdIconName:(NSString *)thirdIconName
                   thirdColor:(UIColor *)thirdColor
               fourthIconName:(NSString *)fourthIconName
                  fourthColor:(UIColor *)fourthColor
				 fithIconName:(NSString *)fithIconName fithColor:(UIColor *)fithColor {
    [self setFirstIconName:firstIconName];
    [self setSecondIconName:secondIconName];
    [self setThirdIconName:thirdIconName];
    [self setFourthIconName:fourthIconName];
	[self setFithIconName:fithIconName];
	
    [self setFirstColor:firstColor];
    [self setSecondColor:secondColor];
    [self setThirdColor:thirdColor];
    [self setFourthColor:fourthColor];
	[self setFithColor:fithColor];
	
	[self loadImage];
	
	//	[_slidingButton setImage:[UIImage imageNamed:@"mathematic-multiply2-icon-white"] forState:UIControlStateNormal];
	//	[_slidingButton1 setImage:[UIImage imageNamed:@"editing-delete-icon-white"] forState:UIControlStateNormal];
	//	[_slidingButton2 setImage:[UIImage imageNamed:@"lms-icon-white"] forState:UIControlStateNormal];
	//	[_slidingButton3 setImage:[UIImage imageNamed:@"very-basic-globe-icon-white"] forState:UIControlStateNormal];
	//	[_slidingButton4 setImage:[UIImage imageNamed:@"very-basic-refresh-icon-white"] forState:UIControlStateNormal];
	
	
	
}

- (IBAction)handlerMapButton:(id)sender {
}

@end
