//
//  GDPostViewController.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 4/30/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "GDVideoViewController.h"

#import "GDAppDelegate.h"

#import "MBProgressHUD.h"
#import "UMSocial.h"

#import "GDManagerFactory.h"
#import "GDManager.h"
#import "PostService.h"

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#import "UIViewController+NavigationMax3.h"

#import "UnitViewController.h"


@interface GDVideoViewController ()

@property (strong, nonatomic) GDManager *manager;

@property (weak, nonatomic) IBOutlet UIWebView *videoPlayer;

@property (strong, nonatomic) GDTMobBannerView *bannerView;

@end

@implementation GDVideoViewController

- (GDManager *)manager {
    if (!_manager) {
        _manager = [GDManagerFactory gdManagerWithDelegate:self];
    }
    return _manager;
}

- (void)setPostId:(int)postId {
    _postId = postId;
    
//    [self.manager fetchPostInfo:postId];
}

- (GDTMobBannerView *)bannerView {
    if (!_bannerView) {
        _bannerView = [[GDTMobBannerView alloc] initWithFrame:CGRectMake(0, 64,
                                                                         GDTMOB_AD_SIZE_320x50.width,
                                                                         GDTMOB_AD_SIZE_320x50.height)
                                                       appkey:@"1101753730"
                                                  placementId:@"9007479621682215203"];
        
        _bannerView.delegate = self; // 设置Delegate
        _bannerView.currentViewController = self; //设置当前的ViewController
        _bannerView.interval = 30; //【可选】设置刷新频率;默认30秒
        
        [self.view addSubview:_bannerView];
    }
    return _bannerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerStarted:) name:@"UIMoviePlayerControllerDidEnterFullscreenNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerFinished:) name:@"UIMoviePlayerControllerDidExitFullscreenNotification" object:nil];

    [self configureAndLoadVideoPlayer];
    [self configureNavigationMax3];
    
    [self.bannerView loadAdAndShow];
    self.videoPlayer.scrollView.contentInset = UIEdgeInsetsMake(100, 0, 0, 0);
    
    NSLog(@"Video Last Viewed @: %@", [PostService videoLastViewedAt:self.postId]);
    [PostService markVideoLastViewed:self.postId];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"视频观看"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"视频观看"];
}

- (void) configureAndLoadVideoPlayer {
    NSString *loadingHtmlContent = @"<html><head><title></title></head><body><center>加载中...</center></body></html>";
    [self.videoPlayer loadHTMLString:loadingHtmlContent baseURL:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSURL *url = [[NSURL alloc] initWithString:
                      [NSString stringWithFormat:@"http://www.sdgundam.cn/pages/app/post-view-video.aspx?id=%d", self.postId]];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        [self.videoPlayer loadRequest:request];
    });

    // self.videoPlayer.scrollView.scrollEnabled = NO;
}


-(void)playerStarted:(NSNotification *)notification{
    // Entered fullscreen code goes here.
    GDAppDelegate *appDelegate = (GDAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.fullScreenVideoIsPlaying = YES;
}

-(void)playerFinished:(NSNotification *)notification{
    // Left fullscreen code goes here.
    GDAppDelegate *appDelegate = (GDAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.fullScreenVideoIsPlaying = NO;
    
    //CODE BELOW FORCES APP BACK TO PORTRAIT ORIENTATION ONCE YOU LEAVE VIDEO.
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
    //present/dismiss viewcontroller in order to activate rotating.
    UIViewController *mocked = [[UIViewController alloc] init];
    mocked.modalPresentationStyle = UIModalPresentationFullScreen;
    mocked.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:mocked animated:YES completion:^{
        [mocked dismissViewControllerAnimated:YES completion:nil];
    }];

}

- (void)showLoading {
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)hideLoading {
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    // [self showLoading];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // [self hideLoading];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self hideLoading];
    
    if (error.code == -999) {
        // do nothing
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"网络连接"
                                                        message: [error localizedDescription]
                                                       delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
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
                if ([objectId isEqualToString:self.fromUnitId]) {
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    [self presentUnitView:objectId];
                }
                return NO;
            } else if ([action isEqualToString:@"post"]) {
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
    // [self presentViewController:gdvvc animated:YES completion:nil];
    
}

#pragma mark - GDManagerDelegate

- (void)didReceivePostInfo:(PostInfo *)returnedPostInfo {
    postInfo = returnedPostInfo;
}

- (IBAction)shareButtonPressed:(id)sender {
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
    [UMSocialData defaultData].extConfig.title = @"漫猫SD敢达iPhone";
    [UMSocialData defaultData].extConfig.wechatSessionData.url =
        [NSString stringWithFormat:@"http://www.sdgundam.cn/pages/app/iphone-landing-page.aspx?appurl=gdapp2://video/%d", self.postId];
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:nil
                                      shareText:@"我正在用[漫猫SD敢达App]观看视频"
                                     shareImage:[UIImage imageNamed:@"AppIcon"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina, UMShareToSms, UMShareToWechatTimeline, UMShareToWechatSession, nil]
                                       delegate:nil];
}


//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//}
//
//- (BOOL)prefersStatusBarHidden {
//    return YES;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
