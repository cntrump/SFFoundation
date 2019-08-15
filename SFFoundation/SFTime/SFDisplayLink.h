//
//  SFDisplayLink.h
//  SFFoundation
//
//  Created by vvveiii on 2019/7/23.
//  Copyright © 2019 lvv. All rights reserved.
//

#if SF_MACOS

@interface SFDisplayLink : NSObject

@property(nonatomic, assign, getter=isPaused) BOOL paused;
@property(nonatomic, readonly) NSTimeInterval duration;

+ (instancetype)displayLinkWithTarget:(id)target selector:(SEL)sel;

- (void)invalidate;

@end

#endif
