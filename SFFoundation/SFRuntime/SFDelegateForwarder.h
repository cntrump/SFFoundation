//
//  SFDelegateForwarder.h
//  SFFoundation
//
//  Created by vvveiii on 2019/7/16.
//  Copyright © 2019 lvv. All rights reserved.
//  Referer: https://github.com/WebKit/webkit/blob/master/Source/WebKit/UIProcess/ios/WKScrollView.mm

@interface SFDelegateForwarder : NSObject

@property(nonatomic, weak, readonly) id internalDelegate;
@property(nonatomic, weak, readonly) id externalDelegate;

- (instancetype)initWithInternalDelegate:(id)internalDelegate externalDelegate:(id)externalDelegate;

@end
