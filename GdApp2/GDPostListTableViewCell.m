//
//  GDPostListTableViewCell.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 5/12/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "GDPostListTableViewCell.h"
#import "GDPostCategoryView.h"
#import "Utility.h"
#import "NSDate+PrettyDate.h"

@interface GDPostListTableViewCell ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) GDPostCategoryView *categoryView1;
@property (strong, nonatomic) GDPostCategoryView *categoryView2;
@property (strong, nonatomic) UILabel *dateLabel;
@end

@implementation GDPostListTableViewCell

const CGFloat TITLE_LABEL_X = 14;
const CGFloat TITLE_LABEL_Y = 32;
const CGFloat TITLE_LABEL_WIDTH = 294;

const CGFloat CELL_PADDING = 12;
const CGFloat CATEGORY_VIEW_HEIGHT = 15;
const CGFloat TITLE_LABEL_MARGIN = 4;

#pragma mark - Static Property

UIFont *_fontForTitleLabel;
+ (UIFont *)fontForTitleLabel {
    if (!_fontForTitleLabel) {
        _fontForTitleLabel = [UIFont systemFontOfSize:14];
    }
    return _fontForTitleLabel;
}

- (void)configureForPostInfo:(PostInfo *)post {
    self.titleLabel.text = post.title;
    CGSize sizeThatFits = [self.class sizeThatFitsTitle:post.title];
    
    CGRect titleLabelFrame = self.titleLabel.frame;
    // CGRect frameThatFits = CGRectMake(titleLabelFrame.origin.x, titleLabelFrame.origin.y, TITLE_LABEL_WIDTH, heightOfTitleLabel);
    titleLabelFrame.size = sizeThatFits;
    self.titleLabel.frame = titleLabelFrame;

    // TODO: see if multiple category should be shown
    self.categoryView1.gdPostCategory = post.gdPostCategory;
    self.categoryView1.tag = post.postId;
    
    self.dateLabel.text = [post.created prettyDate];
    self.dateLabel.frame = CGRectMake(TITLE_LABEL_X,
                                      TITLE_LABEL_Y + TITLE_LABEL_MARGIN + self.titleLabel.frame.size.height, 120, 18);
}

#pragma mark - View Protocol
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(TITLE_LABEL_X, TITLE_LABEL_Y, TITLE_LABEL_WIDTH, 30)];
        self.titleLabel.font = [self.class fontForTitleLabel];
        self.titleLabel.textColor = [Utility UIColorFromRGB:0x333333];
        self.titleLabel.numberOfLines = 0;
        
        [self.contentView addSubview:self.titleLabel];
        
        self.categoryView1 = [[GDPostCategoryView alloc] initWithFrame:CGRectMake(16, 12, 30, CATEGORY_VIEW_HEIGHT) fontSize:10];
        [self.contentView addSubview:self.categoryView1];
        
        self.categoryView2 = [[GDPostCategoryView alloc] initWithFrame:CGRectMake(46, 12, 30, CATEGORY_VIEW_HEIGHT) fontSize:10];
        self.categoryView2.hidden = YES;
        [self.contentView addSubview:self.categoryView2];
        
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
        self.dateLabel.font = [UIFont systemFontOfSize:9];
        self.dateLabel.textColor = [Utility UIColorFromRGB:0x999999];
        self.dateLabel.numberOfLines = 1;
        [self.contentView addSubview:self.dateLabel];

    }
    return self;
}

+ (CGFloat)cellHeightForPostInfo:(PostInfo *)post {
    CGSize sizeThatFitsTitle = [GDPostListTableViewCell sizeThatFitsTitle:post.title];
    
//    NSLog(@"%@: %f: %f", post.title, sizeThatFitsTitle.width, sizeThatFitsTitle.height);
//    UILabel *mockLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, CGFLOAT_MIN)];
//    mockLabel.text = post.title;
//    mockLabel.font = [UIFont systemFontOfSize:14];
//    mockLabel.numberOfLines = 0;
//    CGSize sizeThatFits = [mockLabel sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)];
//    mockLabel.frame = CGRectMake(0, 0, sizeThatFits.width, sizeThatFits.height);
//    
    //adjust the label the the new height.
    return CELL_PADDING + CATEGORY_VIEW_HEIGHT + TITLE_LABEL_MARGIN + sizeThatFitsTitle.height + CELL_PADDING + 18;
}

+ (CGSize)sizeThatFitsTitle:(NSString *)title {
    CGSize maximumLabelSize = CGSizeMake(TITLE_LABEL_WIDTH, CGFLOAT_MAX);
    CGRect textRect = [title boundingRectWithSize:maximumLabelSize
                                               options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                            attributes:@{NSFontAttributeName:[self.class fontForTitleLabel]}
                                               context:nil];
    return textRect.size;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
