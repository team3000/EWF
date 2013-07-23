//
//  ProductCell.h
//  Ewaterfeatures
//
//  Created by Adrien Guffens on 5/2/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProductCell;


typedef NS_ENUM(NSUInteger, MCSwipeTableViewCellState){
    MCSwipeTableViewCellStateNone = 0,
    MCSwipeTableViewCellState1,
    MCSwipeTableViewCellState2,
    MCSwipeTableViewCellState3,
    MCSwipeTableViewCellState4
};

typedef NS_ENUM(NSUInteger, MCSwipeTableViewButtonState){
    MCSwipeTableViewButtonStateNone = 0,
    MCSwipeTableViewButtonState1,
    MCSwipeTableViewButtonState2,
    MCSwipeTableViewButtonState3,
    MCSwipeTableViewButtonState4,
	MCSwipeTableViewButtonState5
};

typedef NS_ENUM(NSUInteger, MCSwipeTableViewCellDirection){
    MCSwipeTableViewCellDirectionLeft = 0,
    MCSwipeTableViewCellDirectionCenter,
    MCSwipeTableViewCellDirectionRight
};

typedef NS_ENUM(NSUInteger, MCSwipeTableViewCellMode){
    MCSwipeTableViewCellModeExit = 0,
    MCSwipeTableViewCellModeSwitch
};


@protocol MCSwipeStickerTableViewCellDelegate <NSObject>

@optional
- (void)swipeStickerTableViewCell:(ProductCell *)cell didTriggerState:(MCSwipeTableViewCellState)state withMode:(MCSwipeTableViewCellMode)mode;
- (void)swipeStickerTableViewCell:(ProductCell *)cell didTriggerButtonState:(MCSwipeTableViewButtonState)buttonState;

@end

@interface ProductCell : UITableViewCell

@property(nonatomic, assign) id <MCSwipeStickerTableViewCellDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIImageView *productImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *referenceLabel;

//TODO: add others
@property(nonatomic, assign) BOOL isActif;

//INFO: menu view stuff
@property(nonatomic, copy) NSString *firstIconName;
@property(nonatomic, copy) NSString *secondIconName;
@property(nonatomic, copy) NSString *thirdIconName;
@property(nonatomic, copy) NSString *fourthIconName;
@property(nonatomic, copy) NSString *fithIconName;

@property(nonatomic, strong) UIColor *firstColor;
@property(nonatomic, strong) UIColor *secondColor;
@property(nonatomic, strong) UIColor *thirdColor;
@property(nonatomic, strong) UIColor *fourthColor;
@property(nonatomic, strong) UIColor *fithColor;

@property(nonatomic, assign) MCSwipeTableViewCellMode mode;

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
	   fithIconName:(NSString *)fithIconName
		  fithColor:(UIColor *)fithColor;

- (void)setFirstStateIconName:(NSString *)firstIconName
                   firstColor:(UIColor *)firstColor
          secondStateIconName:(NSString *)secondIconName
                  secondColor:(UIColor *)secondColor
                thirdIconName:(NSString *)thirdIconName
                   thirdColor:(UIColor *)thirdColor
               fourthIconName:(NSString *)fourthIconName
                  fourthColor:(UIColor *)fourthColor
				 fithIconName:(NSString *)fithIconName
					fithColor:(UIColor *)fithColor;

- (void)bounce;
- (void)bounceToOrigin;

@end
