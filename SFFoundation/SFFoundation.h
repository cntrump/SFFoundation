//
//  SFFoundation.h
//  SFFoundation
//
//  Created by vvveiii on 2019/6/26.
//  Copyright © 2019 lvv. All rights reserved.
//

#import <TargetConditionals.h>

#ifndef __MAC_10_15
#   define __MAC_10_15         101500
#endif

#ifndef __IPHONE_13_0
#   define __IPHONE_13_0    130000
#endif

#if TARGET_OS_OSX
#   define SF_MACOS  1

#   ifndef NSFoundationVersionNumber10_12_Max
#       define NSFoundationVersionNumber10_12_Max 1399
#   endif

#   ifndef NSFoundationVersionNumber10_13_Max
#       define NSFoundationVersionNumber10_13_Max 1499
#   endif

#   ifndef NSFoundationVersionNumber10_14_Max
#       define NSFoundationVersionNumber10_14_Max 1599
#   endif

#   ifndef NSFoundationVersionNumber10_15_Max
#       define NSFoundationVersionNumber10_15_Max 1699
#   endif
#endif

#if TARGET_OS_IOS
#   define SF_IOS  1

#   ifndef NSFoundationVersionNumber_iOS_10_x_Max
#       define NSFoundationVersionNumber_iOS_10_x_Max 1399
#   endif

#   ifndef NSFoundationVersionNumber_iOS_11_x_Max
#       define NSFoundationVersionNumber_iOS_11_x_Max 1499
#   endif

#   ifndef NSFoundationVersionNumber_iOS_12_x_Max
#       define NSFoundationVersionNumber_iOS_12_x_Max 1599
#   endif

#   ifndef NSFoundationVersionNumber_iOS_13_x_Max
#       define NSFoundationVersionNumber_iOS_13_x_Max 1699
#   endif
#endif

#if SF_IOS
#import <UIKit/UIKit.h>
#endif

#if SF_MACOS
#import <AppKit/AppKit.h>
#endif

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>

#import <SFFoundation/SFBitOPS.h>
#import <SFFoundation/SFPlatformDefine.h>
#import <SFFoundation/SFDispatchDefine.h>
#import <SFFoundation/SFDispatchQueuePool.h>
#import <SFFoundation/SFDispatchSemaphore.h>
#import <SFFoundation/SFDispatchGroup.h>
#import <SFFoundation/SFDispatchQueue.h>
#import <SFFoundation/SFDispatchWorkItem.h>
#import <SFFoundation/SFNotificationObserver.h>
#import <SFFoundation/SFColor.h>
#import <SFFoundation/SFImage.h>
#import <SFFoundation/SFImageSource.h>
#import <SFFoundation/SFImageDestination.h>
#import <SFFoundation/SFTextStorage.h>
#import <SFFoundation/SFTextContainer.h>
#import <SFFoundation/SFURLSessionTask.h>
#import <SFFoundation/SFURLSessionManager.h>
#import <SFFoundation/SFRuntime.h>
#import <SFFoundation/SFDelegateForwarder.h>
#import <SFFoundation/SFButton.h>
#import <SFFoundation/SFISO8601DateFormatter.h>
#import <SFFoundation/NSDate+SFTime.h>
#import <SFFoundation/SFGeometry.h>
#import <SFFoundation/SFImageView.h>
#import <SFFoundation/SFAnimatedImage.h>
#import <SFFoundation/SFAsyncImageView.h>
#import <SFFoundation/SFGraphics.h>
#import <SFFoundation/SFRunLoopObserver.h>
#import <SFFoundation/SFAsyncLayer.h>
#import <SFFoundation/SFTextKitContext.h>
#import <SFFoundation/NSString+SFExtension.h>
#import <SFFoundation/SFStringTokenizer.h>
#import <SFFoundation/SFCardNumberFormatter.h>
#import <SFFoundation/SFAsyncOperation.h>
#import <SFFoundation/SFDeInitHelper.h>

// IOS
#import <SFFoundation/UIViewController+SFOverlayWindow.h>
#import <SFFoundation/SFOverlayWindow.h>
#import <SFFoundation/SFAlertWindow.h>
#import <SFFoundation/SFActionSheetWindow.h>
#import <SFFoundation/SFPagingScrollView.h>
#import <SFFoundation/SFImageScrollView.h>
#import <SFFoundation/SFMagnifierView.h>
#import <SFFoundation/SFTextSelectionView.h>
#import <SFFoundation/SFKeyboardListener.h>

// MACOS
#import <SFFoundation/SFDisplayLink.h>
#import <SFFoundation/NSScrollView+SFExtension.h>

@interface SFFoundation : NSObject

@property(class, nonatomic, assign) BOOL enableAssertions; // default is NO

@end
