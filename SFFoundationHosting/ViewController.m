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

    NSLog(@"url: %@", [SFURIFixup getURL:@"github.com/中文/s?word=关键字&num=30"]);
}


@end
