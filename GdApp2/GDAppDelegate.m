//
//  GDAppDelegate.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 4/21/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "GDAppDelegate.h"

#import "GDManager.h"
#import "GDManagerFactory.h"

#import "UMSocial.h"
#import "UMSocialWechatHandler.h"

#import "UnitViewController.h"
#import "GDVideoViewController.h"

#import "iRate.h"

#define ROOTVIEW [[[UIApplication sharedApplication] keyWindow] rootViewController]

@interface GDAppDelegate ()

@property (strong, nonatomic) GDManager *manager;

@end

@implementation GDAppDelegate

- (GDManager *)manager {
    if (!_manager) {
        _manager = [GDManagerFactory gdManagerWithDelegate:nil];
    }
    return _manager;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    static NSString *umengAppKey = @"539fcbe156240bfc02007abc";
    // configure UMeng
    [MobClick startWithAppkey:umengAppKey
                 reportPolicy:SEND_INTERVAL
                    channelId:@"Web"];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    [MobClick checkUpdate:@"侦测到前方高能反应" cancelButtonTitle:@"-_-无视" otherButtonTitles:@"去看看"];
    
    [MobClick setLogEnabled:YES];
    
    // UMeng Social
    [UMSocialData setAppKey:umengAppKey];
    [UMSocialWechatHandler setWXAppId:@"wx533616eb0869c8b7" url:nil];
    
    // irate
    [iRate sharedInstance].daysUntilPrompt = 5;
    [iRate sharedInstance].usesUntilPrompt = 15;
    
    [iRate sharedInstance].messageTitle = @"评分换模型啦!";
    [iRate sharedInstance].message = @"现在去苹果应用商店给[漫猫SD敢达App]评５星, 就可凭截图抽取高达模型! 详情请到漫猫SD敢达网站查询.";
    [iRate sharedInstance].cancelButtonLabel = @"再说吧~";
    [iRate sharedInstance].remindButtonLabel = @"模型神马的也不太给力啊-_-|||";
    [iRate sharedInstance].rateButtonLabel = @"太棒了~这就去评个分!";
    
    // [iRate sharedInstance].previewMode = YES;
    
    // configure UserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:APP_FIRST_USAGE_KEY]) {
        [defaults setObject:[NSDate date] forKey:APP_FIRST_USAGE_KEY];
        [defaults synchronize];
    }
    
    // check for unit origin update
    [self.manager checkForOriginUpdate:NO];

    // display launch image longer
    [NSThread sleepForTimeInterval:1.8];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    NSLog(@"applicationWillEnterForeground");
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
//    NSUInteger orientations = UIInterfaceOrientationMaskPortrait;
    if (self.fullScreenVideoIsPlaying == YES) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
//    static NSString *gdAppScheme = @"gdapp2";
//    if ([url.scheme isEqualToString:gdAppScheme]) {
//        NSString *action = url.host;
//        NSString *objectId = [url.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
//        if (objectId) {
//            if ([action isEqualToString:@"unit"]) {
//                // [self presentUnitView:objectId];
//                return YES;
//            } else if ([action isEqualToString:@"post"]) {
//                // [self presentVideoViewController:[objectId intValue]];
//                return YES;
//            }
//        }
//        return NO;
//    } else {
//        return [UMSocialSnsService handleOpenURL:url];
//    }
//}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    static NSString *gdAppScheme = @"gdapp2";
    if ([url.scheme isEqualToString:gdAppScheme]) {
        NSString *action = url.host;
        NSString *objectId = [url.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
        if (objectId) {
            if ([action isEqualToString:@"unit"]) {
                UITabBarController *rootVC = (UITabBarController *)[[[UIApplication sharedApplication] keyWindow] rootViewController];
                UINavigationController *homeVC = (UINavigationController *)[rootVC.viewControllers objectAtIndex:0];
                
                UnitViewController *uvc = [homeVC.storyboard instantiateViewControllerWithIdentifier:@"UnitViewController"];
                uvc.unitId = objectId;

                [homeVC pushViewController:uvc animated:YES];
                return YES;
            } else if ([action isEqualToString:@"video"]) {
                // [self presentVideoViewController:[objectId intValue]];
                UITabBarController *rootVC = (UITabBarController *)[[[UIApplication sharedApplication] keyWindow] rootViewController];
                UINavigationController *homeVC = (UINavigationController *)[rootVC.viewControllers objectAtIndex:0];
                
                GDVideoViewController *gdvvc = [homeVC.storyboard instantiateViewControllerWithIdentifier:@"VideoViewController"];
                gdvvc.postId = [objectId intValue];
                
                [homeVC pushViewController:gdvvc animated:YES];
                return YES;
            }
        }
        return NO;
    } else {
        return [UMSocialSnsService handleOpenURL:url];
    }
}


@end
