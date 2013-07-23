//
//  HelperView.h
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 6/4/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const HelperViewWillShowNotification;
extern NSString *const HelperViewDidShowNotification;
extern NSString *const HelperViewWillDismissNotification;
extern NSString *const HelperViewDidDismissNotification;

typedef enum {
    HelperViewButtonTypeDefault = 0,
    HelperViewButtonTypeDestructive,
    HelperViewButtonTypeCancel
} HelperViewButtonType;

typedef enum {
    HelperViewBackgroundStyleGradient = 0,
    HelperViewBackgroundStyleSolid,
} HelperViewBackgroundStyle;

typedef enum {
    HelperViewTransitionStyleSlideFromBottom = 0,
    HelperViewTransitionStyleSlideFromTop,
    HelperViewTransitionStyleFade,
    HelperViewTransitionStyleBounce,
    HelperViewTransitionStyleDropDown
} HelperViewTransitionStyle;

@class HelperView;

typedef void(^HelperViewHandler)(HelperView *alertView);


@interface HelperView : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) HelperViewTransitionStyle transitionStyle; // default is SIAlertViewTransitionStyleSlideFromBottom
@property (nonatomic, assign) HelperViewBackgroundStyle backgroundStyle; // default is SIAlertViewButtonTypeGradient

@property (nonatomic, copy) HelperViewHandler willShowHandler;
@property (nonatomic, copy) HelperViewHandler didShowHandler;
@property (nonatomic, copy) HelperViewHandler willDismissHandler;
@property (nonatomic, copy) HelperViewHandler didDismissHandler;

@property (nonatomic, readonly, getter = isVisible) BOOL visible;

@property (nonatomic, strong) UIColor *titleColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *messageColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *titleFont NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *messageFont NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *buttonFont NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat cornerRadius NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR; // default is 2.0
@property (nonatomic, assign) CGFloat shadowRadius NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR; // default is 8.0

- (id)initWithTitle:(NSString *)title andView:(UIView *)view;
- (void)addButtonWithTitle:(NSString *)title type:(HelperViewButtonType)type handler:(HelperViewHandler)handler;


- (void)show;
- (void)dismissAnimated:(BOOL)animated;

@end
