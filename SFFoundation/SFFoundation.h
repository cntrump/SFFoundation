//
//  SFFoundation.h
//  SFFoundation
//
//  Created by vvveiii on 2019/6/26.
//  Copyright © 2019 lvv. All rights reserved.
//

#import <TargetConditionals.h>

#if TARGET_OS_OSX
#define SF_MACOS  1
#endif

#if TARGET_OS_IOS
#define SF_IOS  1
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

// IOS
#import <SFFoundation/UIViewController+SFOverlayWindow.h>
#import <SFFoundation/SFOverlayWindow.h>
#import <SFFoundation/SFAlertWindow.h>
#import <SFFoundation/SFActionSheetWindow.h>
#import <SFFoundation/SFPagingScrollView.h>
#import <SFFoundation/SFImageScrollView.h>
#import <SFFoundation/SFMagnifierView.h>
#import <SFFoundation/SFTextSelectionView.h>

// MACOS
#import <SFFoundation/SFDisplayLink.h>
#import <SFFoundation/NSScrollView+SFExtension.h>
