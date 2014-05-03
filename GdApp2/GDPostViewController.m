//
//  GDPostViewController.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 4/30/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "GDPostViewController.h"
#import "GDAppDelegate.h"

@interface GDPostViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *videoPlayer;

@end

@implementation GDPostViewController

//- (void) setPostId:(int)postId {
//    self.test.text = [NSString stringWithFormat:@"%d", postId];
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerStarted:) name:@"UIMoviePlayerControllerDidEnterFullscreenNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerFinished:) name:@"UIMoviePlayerControllerDidExitFullscreenNotification" object:nil];

    // prevents unneeded offset above the webview
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self configureAndLoadVideoPlayer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
