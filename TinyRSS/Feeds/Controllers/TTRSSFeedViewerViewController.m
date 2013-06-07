//
//  TTRSSFeedViewerViewController.m
//  TinyRSS
//
//  Created by Filipe Teixeira on 6/7/13.
//  Copyright (c) 2013 Filipe Teixeira. All rights reserved.
//

#import "TTRSSFeedViewerViewController.h"
#import "TTRSSFeedsManager.h"
@interface TTRSSFeedViewerViewController ()
{
    IBOutlet    UITextField         * _addressBar;
    IBOutlet    UIButton            * _button;
    IBOutlet    UIWebView           * _viewer;

}
@end

@implementation TTRSSFeedViewerViewController
- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showFeedFromIndentifier:) name:kShowFeedNotification object:nil];

    }
    return self;
}

-(void) showFeedFromIndentifier:(NSNotification *) notification
{
    int feedId = [[[notification userInfo] valueForKey:@"feedId"] intValue];
    [[TTRSSFeedsManager shareFeedManager] getArticle:feedId onSuccess:^(TTRSSFeed * feed) {
        [_viewer loadHTMLString:feed.content baseURL:[NSURL URLWithString:feed.link]];
    }];
}

-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    /*
     if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    */
    return YES;
}

@end
