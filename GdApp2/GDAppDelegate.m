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
    // configure UMeng
    [MobClick startWithAppkey:@"539fcbe156240bfc02007abc"
                 reportPolicy:SEND_INTERVAL
                    channelId:@"Web"];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    [MobClick checkUpdate:@"侦测到前方高能反应" cancelButtonTitle:@"-_-无视" otherButtonTitles:@"去看看"];
    
    [MobClick setLogEnabled:YES];
    
    // configure UserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:APP_FIRST_USAGE_KEY]) {
        [defaults setObject:[NSDate date] forKey:APP_FIRST_USAGE_KEY];
        [defaults synchronize];
    }
    
    // check for unit origin update
    [self.manager checkForOriginUpdate:NO];
    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        
//    });

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

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    static NSString *gdAppScheme = @"gdapp2";
    if ([url.scheme isEqualToString:gdAppScheme]) {
        NSString *action = url.host;
        NSString *objectId = [url.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
        if (objectId) {
            if ([action isEqualToString:@"unit"]) {
                // [self presentUnitView:objectId];
                return YES;
            } else if ([action isEqualToString:@"post"]) {
                // [self presentVideoViewController:[objectId intValue]];
                return YES;
            }
        }
        return NO;
    }
    return NO;
}


@end
