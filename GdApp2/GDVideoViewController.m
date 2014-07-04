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

#import "GDManagerFactory.h"
#import "GDManager.h"

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>


@interface GDVideoViewController ()

@property (strong, nonatomic) GDManager *manager;

@property (weak, nonatomic) IBOutlet UIWebView *videoPlayer;
@property (strong, nonatomic) UIButton *backButton;

@end

@implementation GDVideoViewController

//- (void) setPostId:(int)postId {
//    self.test.text = [NSString stringWithFormat:@"%d", postId];
//}

- (GDManager *)manager {
    if (!_manager) {
        _manager = [GDManagerFactory gdManagerWithDelegate:self];
    }
    return _manager;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(14, 14, 25, 25)];
        [_backButton setBackgroundImage:[UIImage imageNamed:@"back-button"] forState:UIControlStateNormal];
        [_backButton setBackgroundImage:[UIImage imageNamed:@"back-button-hl"] forState:UIControlStateHighlighted];
        [_backButton addTarget:self action:@selector(performGoBack:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_backButton];
    }
    return _backButton;
}

- (void)performGoBack:(id)sender {
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setPostId:(int)postId {
    _postId = postId;
    
    [self configureAndLoadVideoPlayer];
    [self.manager fetchPostInfo:postId];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerStarted:) name:@"UIMoviePlayerControllerDidEnterFullscreenNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerFinished:) name:@"UIMoviePlayerControllerDidExitFullscreenNotification" object:nil];

    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [self setNeedsStatusBarAppearanceUpdate];
    
    [self configureAndLoadVideoPlayer];
    
    // add to view
    [_backButton setBackgroundImage:[UIImage imageNamed:@"back-button"] forState:UIControlStateNormal];
    [self.backButton setBackgroundImage:[UIImage imageNamed:@"back-button-hl"] forState:UIControlStateHighlighted];
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
    NSURL *url = [[NSURL alloc] initWithString:
                  [NSString stringWithFormat:@"http://www.sdgundam.cn/pages/app/post-view-video.aspx?id=%d", self.postId]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [self.videoPlayer loadRequest:request];
    
    self.videoPlayer.scrollView.scrollEnabled = NO;
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

#pragma mark - GDManagerDelegate

- (void)didReceivePostInfo:(PostInfo *)returnedPostInfo {
    postInfo = returnedPostInfo;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

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
