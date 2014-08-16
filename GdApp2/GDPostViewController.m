//
//  GDPostViewController.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 5/5/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "GDPostViewController.h"
#import "GDManagerFactory.h"

#import "MBProgressHUD.h"
#import "NSDate+PrettyDate.h"
#import <SDWebImage/UIImageView+WebCache.h>

#import "UnitViewController.h"
#import "GDVideoViewController.h"

@interface GDPostViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *contentWebView;

@end

@implementation GDPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.contentWebView loadRequest:
     [NSURLRequest requestWithURL:
      [NSURL URLWithString:
       [NSString stringWithFormat:@"http://www.sdgundam.cn/pages/app/post-view.aspx?id=%d&page=0", self.postId]]]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"新闻详细"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"新闻详细"];
}

- (void)showLoading {
    // [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)hideLoading {
    // [MBProgressHUD hideHUDForView:self.view animated:NO];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self showLoading];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self hideLoading];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self hideLoading];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"网络连接"
                                                    message: [error localizedDescription]
                                                   delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (BOOL)webView:(UIWebView *)webView
        shouldStartLoadWithRequest:(NSURLRequest *)request
        navigationType:(UIWebViewNavigationType)navigationType {

    NSLog(@"%@ %@ %@ %@ %@", request.URL.scheme, request.URL.host, request.URL.path, request.URL.query, request.URL.fragment);
    static NSString *gdAppScheme = @"gdapp2";
    if ([request.URL.scheme isEqualToString:gdAppScheme]) {
        NSString *action = request.URL.host;
        NSString *objectId = [request.URL.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
        if (objectId) {
            if ([action isEqualToString:@"unit"]) {
                [self presentUnitView:objectId];
                return NO;
            } else if ([action isEqualToString:@"video"]) {
                [self presentVideoViewController:[objectId intValue]];
                return NO;
            }
        }
        return YES;
    }
    else if ([request.URL.absoluteString isEqualToString:@"about:blank"]) {
        return YES;
    }
    else if ([request.URL.scheme isEqualToString:@"file"]) {
        return YES;
    }
    
    return YES;
}

- (void)presentUnitView:(NSString *)unitId {
    UnitViewController *uvc = [self.storyboard instantiateViewControllerWithIdentifier:@"UnitViewController"];
    uvc.unitId = unitId;
    
    [self.navigationController pushViewController:uvc animated:YES];
}

- (void)presentVideoViewController:(int)postId {
    GDVideoViewController *gdvvc = [self.storyboard instantiateViewControllerWithIdentifier:@"VideoViewController"];
    gdvvc.postId = postId;
    
    [self.navigationController pushViewController:gdvvc animated:YES];
}

@end
