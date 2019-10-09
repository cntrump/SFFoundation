//
//  AlertContainerController.m
//  SFFoundation
//
//  Created by vvveiii on 2019/6/17.
//  Copyright © 2019 lvv. All rights reserved.
//
#if SF_IOS

#import "SFAlertContainerController.h"

@interface SFAlertContainerController () {
    UIAlertController *_alertController;
    UIView *_sourceView;
}

@end

@implementation SFAlertContainerController

- (instancetype)init {
    return [self initWithStyle:UIAlertControllerStyleAlert];
}

- (instancetype)initWithStyle:(UIAlertControllerStyle)style {
    if (self = [super init]) {
        if (style == UIAlertControllerStyleActionSheet &&
            UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            _sourceView = [[UIView alloc] init];
            [self.view addSubview:_sourceView];
            _sourceView.translatesAutoresizingMaskIntoConstraints = NO;
            [self.view addConstraints:@[
                                        [NSLayoutConstraint constraintWithItem:_sourceView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0],
                                        [NSLayoutConstraint constraintWithItem:_sourceView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0],
                                        [NSLayoutConstraint constraintWithItem:_sourceView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0],
                                        [NSLayoutConstraint constraintWithItem:_sourceView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]
                                        ]];
        }

        _alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:style];
    }

    return self;
}

- (void)setAlertTitle:(NSString *)alertTitle {
    _alertTitle = alertTitle.copy;
    _alertController.title = alertTitle;
}

- (void)setAlertMessage:(NSString *)alertMessage {
    _alertMessage = alertMessage.copy;
    _alertController.message = alertMessage;
}

- (NSArray<UITextField *> *)alertTextFields {
    return _alertController.textFields;
}

- (void)show {
    UIPopoverPresentationController *popoverPresentationController = _alertController.popoverPresentationController;
    if (_sourceView && popoverPresentationController) {
        popoverPresentationController.permittedArrowDirections = (UIPopoverArrowDirection)0;
        popoverPresentationController.sourceView = _sourceView;
        popoverPresentationController.sourceRect = _sourceView.bounds;
    }

    [self presentViewController:_alertController animated:YES completion:nil];
}

- (void)addAction:(UIAlertAction *)action {
    if (action) {
        [_alertController addAction:action];
    }
}

- (void)addPreferredAction:(UIAlertAction *)action NS_AVAILABLE_IOS(9_0) {
    if (action && ![_alertController.actions containsObject:action]) {
        [self addAction:action];
    }
    
    _alertController.preferredAction = action;
}

- (void)addPreferredActionWithTitle:(NSString *)title handler:(void (^)(UIAlertAction *action))handler NS_AVAILABLE_IOS(9_0) {
    if (!title) {
        return;
    }

    UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:handler];
    [self addPreferredAction:action];
}

- (void)addActionWithTitle:(NSString *)title style:(UIAlertActionStyle)style handler:(void (^)(UIAlertAction *action))handler {
    if (!title) {
        return;
    }
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:title style:style handler:handler];
    [self addAction:action];
}

- (void)addDefaultActionWithTitle:(NSString *)title handler:(void (^)(UIAlertAction *action))handler {
    [self addActionWithTitle:title style:UIAlertActionStyleDefault handler:handler];
}

- (void)addCancelActionWithTitle:(NSString *)title handler:(void (^)(UIAlertAction *action))handler {
    [self addActionWithTitle:title style:UIAlertActionStyleCancel handler:handler];
}

- (void)addDestructiveActionWithTitle:(NSString *)title handler:(void (^)(UIAlertAction *action))handler {
    [self addActionWithTitle:title style:UIAlertActionStyleDestructive handler:handler];
}

- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField *textField))configurationHandler {
    [_alertController addTextFieldWithConfigurationHandler:configurationHandler];
}

@end

#endif
