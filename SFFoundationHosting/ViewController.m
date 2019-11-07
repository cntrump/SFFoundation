//
//  ViewController.m
//  SFFoundationHosting
//
//  Created by v on 2019/10/24.
//  Copyright © 2019 lvv. All rights reserved.
//

#import "ViewController.h"
@import SFFoundation;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    NSURL *url = [SFURIFixup getURL:@"github.com/中文/s?word=2019-12-31T12:31:58.234&key=_q33"];
    NSLog(@"url: %@", url);
}


@end
