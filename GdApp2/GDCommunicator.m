//
//  GDCommunicator.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 4/24/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "GDCommunicator.h"
#import "GDCommunicatorDelegate.h"

@implementation GDCommunicator

- (void)fetchHomeInfo {
    NSString *urlAsString = @"http://www.sdgundam.cn/services/app.ashx";
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSString *postString = @"a=home&p=1&s=2";
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if (connectionError) {
                                   [self.delegate fetchHomeInfoFailedWithError:connectionError];
                               } else {
                                   [self.delegate receivedHomeInfoJSON:data];
                               }
                           }];
}

- (void) fetchPostVideoInfo {
    
}
@end
