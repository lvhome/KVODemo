//
//  WebViewController.m
//  KVOandKVC
//
//  Created by MAC on 2018/11/14.
//  Copyright © 2018年 MAC. All rights reserved.
//

#import "WebViewController.h"


#import <WebKit/WebKit.h>

@interface WebViewController () <WKNavigationDelegate>
@property (nonatomic, strong) UIProgressView * myProgress;
@property (nonatomic, strong) WKWebView * wkView;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    1.KVC 与 KVO 的不同？
    //    KVC(键值编码)，即 Key-Value Coding，一个非正式的 Protocol，使用字符串(键)访问一个对象实例变量的机制。而不是通过调用 Setter、Getter 方法等显式的存取方式去访问。
    //    KVO(键值监听)，即 Key-Value Observing，它提供一种机制,当指定的对象的属性被修改后,对象就会接受到通知，前提是执行了 setter 方法、或者使用了 KVC 赋值。
    
    
    //1、KVO的含义
    //KVO是OC对观察者设计模式的一种实现；
    //KVO提供了一种机制，指定一个被观察对象（例如WKWebView）,当对象A的某个属性发生变化的时候（例如WKWebView的estimatedProgress属性改变自定义进度条），对象会获得通知，然后做相应的处理；
    //2、简单的原理
    // KVO 的依赖于OC的Runtime来实现的，当观察者对象时，KVO机制动态创建一个对象A的子类（NSKVONotifying_A类），并为这个子类重写了被观察的属性的setter方法，setter方法会负责调用原来的setter方法前后，通知观察对象发生了变化；
    
    //3、实现注意事项
    //观察者观察的是对象的属性，只遵循KVO变更属性值的方法才会执行KVO的回调方法，如果赋值没有通过setter方法或者KVC，直接修改属性的值，是不会触发KVO机制的，也不会调用回调的方法；
    
    //例子 1:
    //  例如：代码中，创建WKWebView，在控制器中创建观察者来观察WKWebView的estimaterdProgress属性，一旦属性数据发生改变就收到观察者收到通知，通过 KVO 再在控制器使用回调方法处理实现自定义的Progress的值的变化；
    //例子 1: 可以通过观察model中属性age的变化，来改变View的变化
    //主要步骤和实现方法 1.注册观察者，实施监听； 2.在回调方法中处理属性发生的变化； 3.移除观察者
    
    
    
    //具体代码  创建新的工程  ---  在ViewController.m 中初始化WKWebView
    [self.view addSubview:self.wkView];
    [self.wkView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
    
    //注册观察者
    /**
     注册观察者
     @param NSObject self（观察者）
     @param keyPath：被观察的属性名称（这里是WKWebView的属性estimatedProgress）
     @param options：观察属性的新值、旧值等的一些配置NSKeyValueObservingOptionOld 以字典的形式提供 “初始对象数据”;NSKeyValueObservingOptionNew 以字典的形式提供 “更新后新的数据”
     @param context 可以为 KVO 的回调方法传值（例如设定为一个放置数据的字典）
     */
    [self.wkView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    
    
    /**
     1.KVC 与 KVO 的不同？
     KVC(键值编码)，即 Key-Value Coding，一个非正式的 Protocol，使用字符串(键)访问一个对象实例变量的机制。而不是通过调用 Setter、Getter 方法等显式的存取方式去访问。
     KVO(键值监听)，即 Key-Value Observing，它提供一种机制,当指定的对象的属性被修改后,对象就会接受到通知，前提是执行了 setter 方法、或者使用了 KVC 赋值。
     */
}

#pragma 懒加载
- (WKWebView *)wkView {
    if (!_wkView) {
        // 进行配置控制器
        
        _wkView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) ];
        _wkView.navigationDelegate = self;
        _wkView.opaque = NO;
        _wkView.backgroundColor = [UIColor whiteColor];
        if (@available(ios 11.0,*)){ _wkView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;}
    }
    return _wkView;
}

- (UIProgressView *)myProgress {
    if (!_myProgress) {
        _myProgress = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 100 , [UIScreen mainScreen].bounds.size.width, 2)];
        _myProgress.backgroundColor = [UIColor greenColor];
        _myProgress.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
        _myProgress.progressTintColor = [UIColor blueColor];
        [self.view addSubview:_myProgress];
        
    }
    return _myProgress;
}

/**
 属性(keyPath)的值发生变化时，收到通知，调用以下方法:
 @param keyPath 属性的名字
 @param object 被观察的对象
 @param change 变化前后的值都存储在 change 字典中
 @param context 注册观察者时，context 传过来的值
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object == self.wkView && [keyPath isEqualToString:@"estimatedProgress"]) {
        self.myProgress.progress = self.wkView.estimatedProgress;
        if (self.myProgress.progress == 1)
        {
            __weak typeof(self) weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^
             {
                 weakSelf.myProgress.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
             }
                             completion:^(BOOL finished)
             {
                 weakSelf.myProgress.hidden = YES;
             }];
        }
    }
}

- (void)dealloc {
    //在dealloc找那个删除Observer
    [self.wkView removeObserver:self forKeyPath:@"estimatedProgress"];
    NSLog(@"%@内存释放",self);
}

// 页面开始加载时调用
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"页面开始加载时调用");
    self.myProgress.hidden = NO;
    self.myProgress.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.view bringSubviewToFront:self.myProgress];
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    NSLog(@"当内容开始返回时调用");
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{//这里修改导航栏的标题，动态改变
    NSLog(@"页面加载完成之后调用");
    self.myProgress.hidden = YES;
    
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"页面加载失败时调用");
    self.myProgress.hidden = YES;
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    if(error.code==NSURLErrorCancelled)
    {
        [self webView:webView didFinishNavigation:navigation];
    }
    else
    {
        self.myProgress.hidden = YES;
    }
}

// 接收到服务器跳转请求之后再执行
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"接收到服务器跳转请求之后再执行");
}

// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    NSLog(@"在收到响应后，决定是否跳转");
    NSLog(@"%@",navigationResponse);
    WKNavigationResponsePolicy actionPolicy = WKNavigationResponsePolicyAllow;
    //这句是必须加上的，不然会异常
    decisionHandler(actionPolicy);
}

// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSLog(@"在发送请求之前，决定是否跳转");
    self.title = webView.title;
    WKNavigationActionPolicy actionPolicy = WKNavigationActionPolicyAllow;
    //这句是必须加上的，不然会异常
    decisionHandler(actionPolicy);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

