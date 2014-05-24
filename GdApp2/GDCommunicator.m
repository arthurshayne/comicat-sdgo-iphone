//
//  GDCommunicator.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 4/24/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "GDCommunicator.h"
#import "GDCommunicatorDelegate.h"
#import "NSDictionary+QueryStringBuilder.h"
@implementation GDCommunicator

static NSString *API_URL = @"http://www.sdgundam.cn/services/app.ashx";
// static NSString *API_URL = @"http://192.168.1.5:10021/services/app.ashx";

+ (void)requestAPIWithAction:(NSString *)action
                       using:(NSDictionary *)parameters
                     success:(void(^)(NSData* data)) successHandler
                       error:(void(^)(NSError * error)) errorHandler {
    
    NSString *urlAsString = API_URL;
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    // request.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    request.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    request.timeoutInterval = 6;
    [request setHTTPMethod:@"POST"];
    NSString *postString = [NSString stringWithFormat:@"a=%@&%@", action, [parameters queryString]];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if (connectionError) {
                                   [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                   errorHandler(connectionError);
                               } else {
                                   [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                   successHandler(data);
                               }
                           }];
}

- (void)fetchHomeInfo {
    [self.class requestAPIWithAction:@"home"
                               using:[NSDictionary dictionaryWithObjectsAndKeys:@"1", @"p", @"2", @"s", nil]
                             success:^(NSData *data) {
                                 [self.delegate receivedHomeInfoJSON:data];
                             }
                               error:^(NSError *error) {
                                 [self.delegate fetchHomeInfoFailedWithError:error];
                               }];
}

- (void)fetchPostInfo: (int)postId {
    [self.class requestAPIWithAction:@"post"
                               using:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d", postId], @"id", @"1", @"p", nil]
                             success:^(NSData *data) {
                                 [self.delegate receivedPostInfoJSON:data];
                             }
                               error:^(NSError *error) {
                                   [self.delegate fetchPostInfoFailedWithError:error];
                               }];
}

- (void)searchUnitsWithKeyword:(NSString *)keyword {
    [self.class requestAPIWithAction:@"search-units"
                               using:[NSDictionary dictionaryWithObjectsAndKeys:keyword, @"k", @"1", @"p", nil]
                             success:^(NSData *data) {
                                 [self.delegate receivedUnitSearchResultsJSON:data];
                             }
                               error:^(NSError *error) {
                                   [self.delegate searchUnitsWithError:error];
                               }];
}

- (void)fetchPostList:(uint)gdCategory pageSize:(uint)pageSize pageIndex:(uint)pageIndex {
    [self.class requestAPIWithAction:@"post-list"
                               using:[NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSString stringWithFormat:@"%d", gdCategory], @"cat",
                                      [NSString stringWithFormat:@"%d", pageSize], @"size",
                                      [NSString stringWithFormat:@"%d", pageIndex], @"page",
                                      nil]
                             success:^(NSData *data) {
                                 [self.delegate receivedPostListJSON:data];
                             }
                               error:^(NSError *error) {
                                   [self.delegate fetchPostListWithError:error];
                               }];
}

- (void)fetchVideoList:(uint)gdCategory pageSize:(uint)pageSize pageIndex:(uint)pageIndex {
    [self.class requestAPIWithAction:@"video-list"
                               using:[NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSString stringWithFormat:@"%d", gdCategory], @"cat",
                                      [NSString stringWithFormat:@"%d", pageSize], @"size",
                                      [NSString stringWithFormat:@"%d", pageIndex], @"page",
                                      nil]
                             success:^(NSData *data) {
                                 [self.delegate receivedVideoListJSON:data];
                             }
                               error:^(NSError *error) {
                                   [self.delegate fetchVideoListWithError:error];
                               }];
}

@end
