//
//  SFMagnifierView.h
//  SFFoundation
//
//  Created by vvveiii on 2019/8/15.
//  Copyright © 2019 lvv. All rights reserved.
//

#if SF_IOS

@interface SFMagnifierView : UIView

@property(nonatomic, assign) CGFloat scale;
@property(nonatomic, weak) UIView *targetView;

@end

#endif
