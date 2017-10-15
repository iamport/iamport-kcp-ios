//
//  ViewController.m
//  KcpSample
//
//  Created by jang on 2015. 9. 16..
//  Copyright (c) 2015년 jang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    NSString *urlString = @"http://www.iamport.kr/demo";
    NSString *urlString = @"http://192.168.0.102:9997";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:urlRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)landRedirectUrl:(NSString*)landing_url {
    
    NSURL *url = [NSURL URLWithString: landing_url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url];
    [request setHTTPMethod: @"GET"];
    [_webView loadRequest: request];
}

@end
