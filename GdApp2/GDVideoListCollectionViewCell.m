//
//  GDVideoListCollectionViewCell.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 5/16/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "GDVideoListCollectionViewCell.h"
#import "GDPostCategoryView.h"
#import "Utility.h"
#import "NSDate+PrettyDate.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface GDVideoListCollectionViewCell()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *titleLabel2;
@property (strong, nonatomic) GDPostCategoryView *categoryView1;
@property (strong, nonatomic) GDPostCategoryView *categoryView2;
@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation GDVideoListCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 84)];
        [self.contentView addSubview:self.imageView];

        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 84, 150, 21)];
        [self.titleLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
        [self.titleLabel setFont:[UIFont systemFontOfSize:12]];

        [self.contentView addSubview:self.titleLabel];
        
        self.titleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 67, 150, 17)];
        self.titleLabel2.textAlignment = NSTextAlignmentRight;
        self.titleLabel2.backgroundColor = [UIColor blackColor];
        self.titleLabel2.textColor = [UIColor whiteColor];
        self.titleLabel2.opaque = false;
        self.titleLabel2.alpha = 0.7;
        [self.titleLabel2 setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
        [self.titleLabel2 setFont:[UIFont systemFontOfSize:12]];

        [self.contentView addSubview:self.titleLabel2];

        self.categoryView1 = [[GDPostCategoryView alloc] initWithFrame:CGRectMake(0, 106, 30, 15) fontSize:10];
        
        [self.contentView addSubview:self.categoryView1];
        
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(36, 105, 110, 17)];
        [self.dateLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
        [self.dateLabel setFont:[UIFont systemFontOfSize:11]];
        self.dateLabel.textColor = [UIColor grayColor];
        
        [self.contentView addSubview:self.dateLabel];
    }
    return self;
}

- (void)configureForVideoListItem:(VideoListItem *)vli {
    self.titleLabel.text = vli.title;
    self.titleLabel2.text = vli.title2;
    [self.imageView setImageWithURL:[NSURL URLWithString:vli.imageURL]];
    self.dateLabel.text = [Utility dateStringByDay:vli.created];
    self.categoryView1.gdPostCategory = vli.gdPostCategory;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
