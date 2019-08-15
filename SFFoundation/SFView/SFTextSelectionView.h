//
//  SFTextSelectionView.h
//  SFFoundation
//
//  Created by vvveiii on 2019/8/15.
//  Copyright © 2019 lvv. All rights reserved.
//

#if SF_IOS

@interface SFTextSelectionView : UIView

@property(nonatomic, assign) NSRange selectedRange;

- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer;

@end

#endif
