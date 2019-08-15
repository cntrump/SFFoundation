//
//  SFActionSheetWindow.m
//  SFFoundation
//
//  Created by vvveiii on 2019/6/17.
//  Copyright © 2019 lvv. All rights reserved.
//
#if SF_IOS

#import "SFActionSheetWindow.h"
#import "SFAlertContainerController.h"

@interface SFActionSheetContainerController : SFAlertContainerController

@end

@implementation SFActionSheetContainerController

- (instancetype)init {
    return [self initWithStyle:UIAlertControllerStyleActionSheet];
}

@end

#pragma mark - SFActionSheetWindow

@implementation SFActionSheetWindow

+ (Class)rootViewControllerClass {
    return SFActionSheetContainerController.class;
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

- (void)addDefaultActionWithTitle:(NSString *)title handler:(void (^)(UIAlertAction *action))handler {
    [(SFAlertContainerController *)self.rootViewController addDefaultActionWithTitle:title handler:handler];
}

- (void)addCancelActionWithTitle:(NSString *)title handler:(void (^)(UIAlertAction *action))handler {
    [(SFAlertContainerController *)self.rootViewController addCancelActionWithTitle:title handler:handler];
}

- (void)addDestructiveActionWithTitle:(NSString *)title handler:(void (^)(UIAlertAction *action))handler {
    [(SFAlertContainerController *)self.rootViewController addDestructiveActionWithTitle:title handler:handler];
}

@end

#endif
