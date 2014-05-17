//
//  GDPostListTableViewCell.h
//  GdApp2
//
//  Created by Guo, Xing Hua on 5/12/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostInfo.h"

@interface GDPostListTableViewCell : UITableViewCell

//@property (strong, nonatomic) NSString *title;
//@property int gdCategory;
//@property (readonly) CGFloat height;

- (void)configureForPostInfo:(PostInfo *)post;

+ (CGFloat)cellHeightForPostInfo:(PostInfo *)post;
@end
