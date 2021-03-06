//  -*-ObjC-*-
//  UIAlertView+.h
//  Cam Saül
//
//  Created by Cameron Saul on 7/10/13.
//  Copyright (c) 2013 Cam Saül. All rights reserved.
//

typedef void(^AlertViewButtonPressedBlock)(BOOL cancelButtonPressed, NSUInteger buttonIndex);

@interface UIAlertView (X)

/// Convenience method to alloc, init, and show an alert view with a title, message, and cancel button.
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle;

/// Similar to the standard way of showing an alert view, but uses a block instead of a delegate, which is
/// usually more convenient.
/// (This is done by making the alert view its own delegate, and keeping the block around as an Objective-C associated object)
+ (void)showAlertWithTitle:(NSString *)title
				   message:(NSString *)message
		buttonPressedBlock:(AlertViewButtonPressedBlock)buttonPressedBlock
		 cancelButtonTitle:(NSString *)cancelButtonTitle
		 otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

@end
