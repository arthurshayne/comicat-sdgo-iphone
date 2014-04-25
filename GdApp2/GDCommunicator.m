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
    NSLog(@"fetchHomeInfo starts");
    NSString *urlAsString = [NSString stringWithFormat:@"http://www.sdgundam.cn/app/test.json?r=%d", rand()];
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSLog(@"fetchHomeInfo completed");
                               if (connectionError) {
                                   [self.delegate fetchHomeInfoFailedWithError:connectionError];
                               } else {
                                   [self.delegate receivedHomeInfoJSON:data];
                               }
                           }];
    NSLog(@"fetchHomeInfo ends");
}
@end
