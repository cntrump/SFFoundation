//
//  SFAlertWindow.m
//  SFFoundation
//
//  Created by vvveiii on 2019/6/17.
//  Copyright © 2019 lvv. All rights reserved.
//
#if SF_IOS

#import "SFAlertWindow.h"
#import "SFAlertContainerController.h"

@interface SFAlertWindow ()

@end

@implementation SFAlertWindow

+ (Class)rootViewControllerClass {
    return SFAlertContainerController.class;
}

+ (instancetype)windowWithTitle:(NSString *)title message:(NSString *)message {
    return [[self alloc] initWithTitle:title message:message];
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message {
    if (self = [super initWithFrame:CGRectZero]) {
        self.title = title.copy;
        self.message = message.copy;
        self.windowLevel = (UIWindowLevel)10000002;
    }

    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title.copy;
    ((SFAlertContainerController *)self.rootViewController).alertTitle = title;
}

- (void)setMessage:(NSString *)message {
    _message = message.copy;
    ((SFAlertContainerController *)self.rootViewController).alertMessage = message;
}

- (NSArray<UITextField *> *)textFields {
    return ((SFAlertContainerController *)self.rootViewController).alertTextFields;
}

- (void)show {
    [super show];

    [(SFAlertContainerController *)self.rootViewController show];
}

- (void)addAction:(UIAlertAction *)action {
    [(SFAlertContainerController *)self.rootViewController addAction:action];
}

- (void)addPreferredAction:(UIAlertAction *)action NS_AVAILABLE_IOS(9_0) {
    [(SFAlertContainerController *)self.rootViewController addPreferredAction:action];
}

- (void)addPreferredActionWithTitle:(NSString *)title handler:(void (^)(UIAlertAction *action))handler NS_AVAILABLE_IOS(9_0) {
    [(SFAlertContainerController *)self.rootViewController addPreferredActionWithTitle:title handler:handler];
}

- (void)addDefaultActionWithTitle:(NSString *)title handler:(void (^)(UIAlertAction *action))handler {
    [(SFAlertContainerController *)self.rootViewController addDefaultActionWithTitle:title handler:handler];
}

- (void)addCancelActionWithTitle:(NSString *)title handler:(void (^)(UIAlertAction *action))handler {
    [(SFAlertContainerController *)self.rootViewController addCancelActionWithTitle:title handler:handler];
}

- (void)addDestructiveActionWithTitle:(NSString *)title handler:(void (^)(UIAlertAction *action))handler {
    [(SFAlertContainerController *)self.rootViewController addDestructiveActionWithTitle:title handler:handler];
}

- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField *textField))configurationHandler {
    [(SFAlertContainerController *)self.rootViewController addTextFieldWithConfigurationHandler:configurationHandler];
}

@end

#endif
