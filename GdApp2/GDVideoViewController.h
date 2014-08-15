//
//  GDPostViewController.h
//  GdApp2
//
//  Created by Guo, Xing Hua on 4/30/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDManager.h"
#import "PostInfo.h"
#import "GDTMobBannerView.h" 

@interface GDVideoViewController : UIViewController <GDManagerDelegate, UIWebViewDelegate, GDTMobBannerViewDelegate> {
    PostInfo *postInfo;
}
@property (nonatomic) int postId;

@property (strong, nonatomic) NSString *fromUnitId;
@end
