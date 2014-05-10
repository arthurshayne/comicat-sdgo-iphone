//
//  GDPostViewController.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 5/5/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "GDPostViewController.h"
#import "GDManagerFactory.h"
#import "MBProgressHUD.h"
//#import "DTAttributedTextView.h"
//#import "DTCoreText.h"
//#import "DTTextAttachment.h"
#import "NSDate+PrettyDate.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface GDPostViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *rootScrollView;

//
//@property (strong, nonatomic) UILabel *metaLabel;
// @property (strong, nonatomic) DTAttributedTextView *contentTextView;
@property (strong, nonatomic) UIWebView *contentWebView;

@property (strong, nonatomic) PostInfo *postInfo;

@end

@implementation GDPostViewController

GDManager *manager;

//- (DTAttributedTextView *) contentTextView {
//    if (!_contentTextView) {
//        _contentTextView = [[DTAttributedTextView alloc] initWithFrame:CGRectMake(0, 64, 320, self.view.frame.size.height - 68)];
//    }
//    return _contentTextView;
//}

- (UIWebView *) contentWebView {
    if (!_contentWebView) {
        _contentWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, 320, self.view.frame.size.height - 68)];
    }
    return _contentWebView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    manager = [GDManagerFactory getGDManagerWithDelegate:self];
//    [manager fetchPostInfo:self.postId];
    
//    [self.view addSubview:self.contentTextView];
//    [self.view addSubview:self.contentWebView];
    
    [manager fetchPostInfo: 28215 /*28076*/];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark GDManagerDelegate

- (void)didReceivePostInfo:(PostInfo *)postInfo {
    NSLog(@"Received Post Info!");
    self.postInfo = postInfo;

    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    });
    
//    int margin = 10;
//    CGRect flowLayout =  CGRectMake(margin, margin, self.rootScrollView.frame.size.width - 2 * margin, margin);
    
//    flowLayout = [self layoutTitleLabelOnPoint:flowLayout];
//    flowLayout = [self layoutMetaLabelOnPoint:flowLayout];
//    flowLayout = [self layoutContentViewOnPoint:flowLayout];
    
//    self.rootScrollView.contentSize = CGSizeMake(self.rootScrollView.frame.size.width, flowLayout.size.height + 2 * margin );
    
//    [self prepareContentTextView];
}

- (void)fetchingPostInfoWithError:(NSError *)error {
    
}

//- (void) prepareContentTextView {
//    // append title and meta before the HTML
//    NSString *titleHtml = [NSString stringWithFormat:@"<div style='background:#123480;padding:32px 12px;color:#fff;font-size:12pt;font-weight:700;line-height:1em;'>%@<div style='font-size:7pt;color:#eee;'>%@</div></div>", self.postInfo.title, [self.postInfo.created prettyDate]];
//    
//    NSDictionary *builderOptions = @{ DTDefaultFontFamily: @"Helvetica Neue", DTDefaultFontSize: @14 };
//    
//    NSData *data = [[NSString stringWithFormat:@"%@<div style='padding:24px 8px;background-color:#efefef;line-height:1.5em'>%@</div>", titleHtml, self.postInfo.contentHTML] dataUsingEncoding:NSUTF8StringEncoding];
//    NSAttributedString *attrString = [[NSAttributedString alloc] initWithHTMLData:data
//                                                                          options:builderOptions
//                                                               documentAttributes:NULL];
//    
//    self.contentTextView.shouldDrawLinks = NO;
//    
//    self.contentTextView.attributedString = attrString;
//    
//    self.contentTextView.textDelegate = self;
//}


#pragma mark - Flow Layout


//- (CGRect)layoutContentViewOnPoint:(CGRect)frame{
//    const int topMargin = 12;
//    
//    NSDictionary *builderOptions = @{ DTDefaultFontFamily: @"Helvetica Neue", DTDefaultFontSize: @14, DTDefaultLineHeightMultiplier: @1.5 };
//    
//    NSData *data = [self.postInfo.contentHTML dataUsingEncoding:NSUTF8StringEncoding];
//    NSAttributedString *attrString = [[NSAttributedString alloc] initWithHTMLData:data
//                                                                          options:builderOptions
//                                                               documentAttributes:NULL];
//    
//    DTCoreTextLayouter *layouter = [[DTCoreTextLayouter alloc] initWithAttributedString:attrString];
//    
//    CGRect maxRect = CGRectMake(frame.origin.x, frame.origin.y + topMargin, frame.size.width, CGFLOAT_HEIGHT_UNKNOWN);
//    NSRange entireString = NSMakeRange(0, [attrString length]);
//    DTCoreTextLayoutFrame *layoutFrame = [layouter layoutFrameWithRect:maxRect range:entireString];
//    
//    DTAttributedTextView *contentTextView = [[DTAttributedTextView alloc] initWithFrame:layoutFrame.frame];
//    
//    contentTextView.attributedString = attrString;
////    [DTCoreTextFontDescriptor setFallbackFontFamily:@"Helvetica Neue"];
//    
//    contentTextView.scrollEnabled = NO;
//    
//    contentTextView.textDelegate = self;
//    
//    [self.rootScrollView addSubview:contentTextView];
//    
//    self.contentTextView = contentTextView;
//    
//    return CGRectMake(frame.origin.x, frame.origin.y + layoutFrame.frame.size.height + topMargin,
//                      frame.size.width, frame.size.height + layoutFrame.frame.size.height + topMargin);
//}

- (CGRect)layoutTitleLabelOnPoint:(CGRect)frame{
    UIFont *font = [UIFont boldSystemFontOfSize:18];
    
    CGSize maximumLabelSize = CGSizeMake(frame.size.width, CGFLOAT_MAX);
    CGRect textRect = [self.postInfo.title boundingRectWithSize:maximumLabelSize
                                                        options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                     attributes:@{NSFontAttributeName:font}
                                                        context:nil];
    //adjust the label the the new height.
    CGRect newFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, textRect.size.height);
    newFrame.size.height = textRect.size.height;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:newFrame];
    
    titleLabel.numberOfLines = 99;
    titleLabel.font = font;
    titleLabel.text = self.postInfo.title;
    
    [self.rootScrollView addSubview:titleLabel];
    
    return CGRectMake(frame.origin.x, frame.origin.y + newFrame.size.height,
                      newFrame.size.width, frame.size.height + newFrame.size.height);
}

- (CGRect)layoutMetaLabelOnPoint:(CGRect)frame{
    const int topMarign = 3;
    // draw a separate line first
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y + topMarign, frame.size.width, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.rootScrollView addSubview:lineView];
    
    frame.origin.y += topMarign + 1;
    frame.size.height += topMarign + 1;
    
    const int metaLabelHeight = 18;
    
    UILabel *metaLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y + topMarign, frame.size.width, metaLabelHeight)];
    metaLabel.text = [self.postInfo.created prettyDate];
    metaLabel.textColor = [UIColor grayColor];
    metaLabel.font = [UIFont systemFontOfSize:10];
    
    [self.rootScrollView addSubview:metaLabel];
    
    return CGRectMake(frame.origin.x, frame.origin.y + metaLabelHeight + topMarign, frame.size.width, frame.size.height + metaLabelHeight + topMarign);
}

#pragma mark - DTAttributedTextContentViewDelegate

//- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttachment:(DTTextAttachment *)attachment frame:(CGRect)frame {
//    if([attachment isKindOfClass:[DTImageTextAttachment class]]) {
//        NSLog(@"Going to load image");
////        if ([[attachment.contentURL absoluteString] rangeOfString:@"data-source"
////                          options:NSRegularExpressionSearch|NSCaseInsensitiveSearch].location != NSNotFound) {
////            return nil;
////        } else {
////            DTLazyImageView *imageView = [[DTLazyImageView alloc] initWithFrame:frame];
////            imageView.delegate = self;
////            
////            // url for deferred loading
////            imageView.url = attachment.contentURL;
////        
////            return imageView;
//        
////        frame.size.width = 304;
////        frame.size.height = CGFLOAT_HEIGHT_UNKNOWN;
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
//        [imageView setImageWithURL:[NSURL URLWithString:[attachment.contentURL absoluteString]]];
//
//
//        return imageView;
////        }
//    }
//    return nil;
//}

#pragma mark - DTLazyImageViewDelegate

//- (void)lazyImageView:(DTLazyImageView *)lazyImageView didChangeImageSize:(CGSize)size {
//            NSLog(@"Resize image");
//    NSURL *url = lazyImageView.url;
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"contentURL == %@", url];
//    
//    const float shrinkImageWidth = 304;
//    
//    float aspect = size.width / size.height;
//    CGSize aspectedSize = CGSizeMake(shrinkImageWidth, shrinkImageWidth / aspect);
//
//    // update all attachments that matching this URL
//    for (DTTextAttachment *oneAttachment in [self.contentTextView.attributedTextContentView.layoutFrame textAttachmentsWithPredicate:pred]) {
//        
//        if (size.width >= shrinkImageWidth) {
//            oneAttachment.originalSize = aspectedSize;
//        } else {
//            oneAttachment.originalSize = size;
//        }
////        
////        NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:oneAttachment.attributes];
////        attributes setObject:<#(id)#> forKey:<#(id<NSCopying>)#>
//    }
//    
////    // need to reset the layouter because otherwise we get the old framesetter or cached layout frames
//    self.contentTextView.attributedTextContentView.layouter = nil;
//    
//    // here we're layouting the entire string,
//    // might be more efficient to only relayout the paragraphs that contain these attachments
//    [self.contentTextView relayoutText];
//}



// mocks
- (void)didReceiveHomeInfo:(HomeInfo *)homeInfo { }
- (void)fetchingHomeInfoWithError:(NSError *)error { }

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/*
 UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, self.view.bounds.size.width, 1)];
 lineView.backgroundColor = [UIColor blackColor];
 [self.view addSubview:lineView];
 [lineView release];
 */

@end
