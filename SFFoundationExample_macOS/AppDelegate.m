//
//  AppDelegate.m
//  SFFoundationExample_macOS
//
//  Created by vvveiii on 2019/6/28.
//  Copyright © 2019 lvv. All rights reserved.
//

#import "AppDelegate.h"
@import SFFoundation;

@interface AsyncView : NSView {

}

@property(nonatomic, copy) NSString *text;
@property(nonatomic, strong) NSFont *font;
@property(nonatomic, strong) NSColor *textColor;
@property(nonatomic, assign) NSUInteger numberOfLines;
@property(nonatomic, assign) NSLineBreakMode lineBreakMode;
@property(nonatomic, strong) NSColor *backgroundColor;

@end

@implementation AsyncView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer = ({
            SFAsyncLayer *layer = SFAsyncLayer.layer;
            layer;
        });
        self.layer.delegate = self;
        self.wantsLayer = YES;

        _lineBreakMode = NSLineBreakByWordWrapping;
        _font = [NSFont systemFontOfSize:12];
        _textColor = NSColor.textColor;
        _backgroundColor = NSColor.textBackgroundColor;
    }

    return self;
}

- (void)asyncLayer:(SFAsyncLayer * _Nonnull)layer drawInContext:(CGContextRef _Nonnull)context bounds:(CGRect)bounds
        parameters:(id _Nullable)parameters renderSynchronously:(BOOL)renderSynchronously {
    [_backgroundColor setFill];
    NSRectFill(bounds);

    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:_text ? : @""
                                                                         attributes:@{
                                                                                      NSFontAttributeName: _font,
                                                                                      NSForegroundColorAttributeName: _textColor
                                                                                      }];

    SFTextKitContext *textKitContext = [SFTextKitContext contextWithSize:NSMakeSize(NSWidth(self.bounds), INFINITY) attributedText:attributedText];
    [textKitContext performWithBlock:^(NSLayoutManager *layoutManager, NSTextContainer *textContainer, NSTextStorage *textStorage) {
        textContainer.lineBreakMode = _lineBreakMode;
        textContainer.maximumNumberOfLines = _numberOfLines;
        NSRange glyphRange = [layoutManager glyphRangeForTextContainer:textContainer];
        [layoutManager drawBackgroundForGlyphRange:glyphRange atPoint:NSZeroPoint];
        [layoutManager drawGlyphsForGlyphRange:glyphRange atPoint:NSZeroPoint];
    }];
}

- (void)setBackgroundColor:(NSColor *)backgroundColor {
    _backgroundColor = backgroundColor;
    self.needsDisplay = YES;
}

- (void)setText:(NSString *)text {
    _text = text.copy;
    self.needsDisplay = YES;
}

@end

@interface TestOperation : SFAsyncOperation

@end

@implementation TestOperation

- (void)main {

}

@end

@interface AppDelegate () {
    SFURLSessionManager *_manager;
    NSOperationQueue *_operationQueue;
}

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSImage *image = [NSImage imageNamed:@"test_png"];
    CGSize imageSize = image.size;
    NSImage *cropImage = [image sf_cropRect:CGRectMake((imageSize.width - 50) * 0.5, (imageSize.height - 50) * 0.5, 50, 50)];

    NSString *path = [NSBundle.mainBundle pathForResource:@"demo" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:path];

    SFView *aniView = [[SFView alloc] init];
    aniView.contentMode = SFViewContentModeScaleAspectFit;
    self.window.contentView = aniView;
    self.window.contentView.sf_animatedImageData = [NSData dataWithContentsOfFile:[bundle pathForResource:@"demo" ofType:@"png"]];

    _operationQueue = [[NSOperationQueue alloc] init];

    TestOperation *op = TestOperation.operation;
    [_operationQueue addOperation:op];

    _manager = SFURLSessionManager.manager;
    [_manager httpGET:[NSURL URLWithString:@"https://github.com"] headers:nil completion:^(NSURLRequest *request, NSURLResponse *response, NSData *data, NSError *error) {

    }];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
