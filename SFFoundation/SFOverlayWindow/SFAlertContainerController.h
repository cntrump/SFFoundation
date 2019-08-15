//
//  AlertContainerController.h
//  SFFoundation
//
//  Created by vvveiii on 2019/6/17.
//  Copyright © 2019 lvv. All rights reserved.
//
#if SF_IOS

#import "SFOverlayViewController.h"

@interface SFAlertContainerController : SFOverlayViewController

@property(nonatomic, copy) NSString *alertTitle;
@property(nonatomic, copy) NSString *alertMessage;
@property(nonatomic, copy, readonly) NSArray<UITextField *> *alertTextFields;

- (instancetype)initWithStyle:(UIAlertControllerStyle)style;

- (void)show;

- (void)addAction:(UIAlertAction *)action;

- (void)addPreferredAction:(UIAlertAction *)action NS_AVAILABLE_IOS(9_0);

- (void)addPreferredActionWithTitle:(NSString *)title handler:(void (^)(UIAlertAction *action))handler NS_AVAILABLE_IOS(9_0);

- (void)addDefaultActionWithTitle:(NSString *)title handler:(void (^)(UIAlertAction *action))handler;

- (void)addCancelActionWithTitle:(NSString *)title handler:(void (^)(UIAlertAction *action))handler;

- (void)addDestructiveActionWithTitle:(NSString *)title handler:(void (^)(UIAlertAction *action))handler;

- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField *textField))configurationHandler;

@end

#endif
