//
//  SFTextKitContext.h
//  SFFoundation
//
//  Created by vvveiii on 2019/7/20.
//  Copyright © 2019 lvv. All rights reserved.
//

typedef void (^SFTextKitContextBlock)(NSLayoutManager *layoutManager,
                                      NSTextContainer *textContainer,
                                      NSTextStorage *textStorage);

@interface SFTextKitContext : NSObject

@property(nonatomic, strong, readonly) NSLayoutManager *layoutManager;
@property(nonatomic, strong, readonly) NSTextContainer *textContainer;
@property(nonatomic, strong, readonly) NSTextStorage *textStorage;
@property(nonatomic, assign) CGSize size;

+ (instancetype)contextWithSize:(CGSize)size attributedText:(NSAttributedString *)attributedText;

- (instancetype)initWithSize:(CGSize)size attributedText:(NSAttributedString *)attributedText;

- (instancetype)initWithSize:(CGSize)size
              attributedText:(NSAttributedString *)attributedText
                 layoutClass:(Class)layoutClass
              containerClass:(Class)containerClass;

- (void)performWithBlock:(SFTextKitContextBlock)block;

@end
