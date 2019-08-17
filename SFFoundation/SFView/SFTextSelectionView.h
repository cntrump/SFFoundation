//
//  SFTextSelectionView.h
//  SFFoundation
//
//  Created by vvveiii on 2019/8/15.
//  Copyright © 2019 lvv. All rights reserved.
//

#if SF_IOS

@class SFTextKitContext;

@interface SFTextSelectionView : UIView

@property(nonatomic, assign) NSRange selectedRange;
@property(nonatomic, assign) CGSize size;
@property(nonatomic, assign) CGPoint origin;

- (instancetype)initWithFrame:(CGRect)frame
                textContext:(SFTextKitContext *)textContext
                selectedRange:(NSRange)selectedRange
                       origin:(CGPoint)origin;

@end

#endif
