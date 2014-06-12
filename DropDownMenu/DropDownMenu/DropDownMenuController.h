//
//  DropDownMenuController.h
//  DropDownMenu
//
//  Created by Kevin Chen on 6/11/14.
//  Copyright (c) 2014 KnightLord Universe Technologies Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const DropDownMenuTitleKey;

@protocol DropDownMenuDelegate;

@interface DropDownMenuController : UIViewController

@property (nonatomic, weak) id<DropDownMenuDelegate> delegate;

/**
 *  Array of NSDictionary object, object must have DropDownMenuTitleKey key value pair
 */
@property (nonatomic, strong) NSArray *menuItems;

- (BOOL)isShow;

/**
 *  Show DropDownMenu
 *
 *  @param sender The Control ask for showing DropDownMenu
 */
- (void)show:(id)sender;

///**
// *  Show DropDownMenu
// *
// *  @param rect     from
// *  @param view     superview
// *  @param animated 
// */
//- (void)showFromRect:(CGRect)rect;
//
///**
// *  Show DropDownMenu from UINavigationBar or UIToolbar
// *
// *  @param item     UIBarButtonItem
// *  @param animated 
// */
//- (void)showFromBarButtomItem:(UIBarButtonItem *)item;

/**
 *  Hide DropDownMenu
 */
- (void)hide;

@end

@protocol DropDownMenuDelegate <NSObject>

@optional
/**
 *
 *
 *  @param controller
 *  @param indexPath
 */
- (void)menu:(DropDownMenuController *)controller didSelectMenuItem:(NSDictionary *)menuItem atIndexPath:(NSIndexPath *)indexPath;

@end
