//
//  ModelViewController.m
//  KVOandKVC
//
//  Created by MAC on 2018/11/14.
//  Copyright © 2018年 MAC. All rights reserved.
//

#import "ModelViewController.h"
#import "LHModel.h"
@interface ModelViewController ()
{
    UILabel * ageLable;
}
@property (strong, nonatomic) LHModel * model;
@end

@implementation ModelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    ageLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 200)];
    ageLable.textAlignment = NSTextAlignmentCenter;
    ageLable.text = @"显示年龄";
    [self.view addSubview:ageLable];
    
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"修改年龄" forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 360, [UIScreen mainScreen].bounds.size.width, 60);
    [self.view addSubview:btn];
    
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.model = [[LHModel alloc] init];
    //注册观察者
    [self.model addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew context:nil];
}

//收到通知
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (self.model == object && [keyPath isEqualToString:@"age"]) {
        ageLable.text = [NSString stringWithFormat:@"%@", [change valueForKey:@"new"]];
    }
}


- (void)btnClick {
    self.model.age = [NSString stringWithFormat:@"%u",arc4random()%100];
}

- (void)dealloc {
    [self.model removeObserver:self forKeyPath:@"age"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
