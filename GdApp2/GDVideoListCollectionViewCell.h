//
//  GDVideoListCollectionViewCell.h
//  GdApp2
//
//  Created by Guo, Xing Hua on 5/16/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoListItem.h"

@interface GDVideoListCollectionViewCell : UICollectionViewCell

//@property (strong, nonatomic) NSString *title;
//@property (strong, nonatomic) NSString *title2;
//@property int gdCategory;
//@property (strong, nonatomic) NSString *imageURL;

- (void)configureForVideoListItem:(VideoListItem *)vli;

@end
