//
//  ViewController.m
//  KVOandKVC
//
//  Created by MAC on 2018/11/14.
//  Copyright © 2018年 MAC. All rights reserved.
//

#import "ViewController.h"
#import "WebViewController.h"
#import "ModelViewController.h"
@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton * webBtn = (UIButton *)[self.view viewWithTag:1];
    [webBtn addTarget:self action:@selector(webBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * modelBtn = (UIButton *)[self.view viewWithTag:2];
    [modelBtn addTarget:self action:@selector(modelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * kvcBtn = (UIButton *)[self.view viewWithTag:3];
    [kvcBtn addTarget:self action:@selector(kvcBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)webBtnClick {
    WebViewController * web = [[WebViewController alloc] init];
    [self.navigationController pushViewController:web animated:YES];
}

- (void)modelBtnClick {
    ModelViewController * model = [[ModelViewController alloc] init];
    [self.navigationController pushViewController:model animated:YES];
}

- (void)kvcBtnClick {
    
}

@end
