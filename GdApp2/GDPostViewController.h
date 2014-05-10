//
//  GDPostViewController.h
//  GdApp2
//
//  Created by Guo, Xing Hua on 5/5/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDManager.h"
// #import "DTAttributedTextView.h"
// #import "DTLazyImageView.h"

@interface GDPostViewController : UIViewController <GDManagerDelegate /*, DTAttributedTextContentViewDelegate, DTLazyImageViewDelegate*/>

@property (nonatomic) int postId;

@end
