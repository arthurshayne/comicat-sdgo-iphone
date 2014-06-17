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

    NSString *url = [[request URL] absoluteString];
    static NSString *urlPrefix = @"myApp://";
    if([url hasPrefix:urlPrefix]) {
        
        NSString *paramsString = [url substringFromIndex:[urlPrefix length]];
        NSArray *paramsArray = [paramsString componentsSeparatedByString:@"&"];
        int paramsAmount = [paramsArray count];
        NSString *section;
        NSString *page;
        
        for (int i = 0; i < paramsAmount; i++) {
            NSArray *keyValuePair = [[paramsArray objectAtIndex:i] componentsSeparatedByString:@"="];
            NSString *key = [keyValuePair objectAtIndex:0];
            NSString *value = nil;
            if ([keyValuePair count] > 1) {
                value = [keyValuePair objectAtIndex:1];
            }
            
            //Assign these values.
            if([key isEqualToString:@"section"]){
                section = value;
            } else if([key isEqualToString:@"page"]){
                page = value;
            }
            
            if ((key && [key length] > 0) && (value && [value length] > 0)) {
                if ([key isEqualToString:@"page"]) {
                    // Use the page...
                }
            }
            NSString *destinationURL = [NSString stringWithFormat:@"page%@_%@.html", section, page];
            NSLog(@"%@", destinationURL);
            return NO;
        }
    } else {
        return YES;
    }
    return YES;
}

@end
