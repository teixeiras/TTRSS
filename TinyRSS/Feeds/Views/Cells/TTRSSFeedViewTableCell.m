//
//  TTRSSFeedViewTableCell.m
//  TinyRSS
//
//  Created by Filipe Teixeira on 6/7/13.
//  Copyright (c) 2013 Filipe Teixeira. All rights reserved.
//

#import "TTRSSFeedViewTableCell.h"
#import "TTRSSFeedsManager.h"
#import "TTRSSFeed.h"
@implementation TTRSSFeedViewTableCell
{
    TTRSSFeed * _feed;
    IBOutlet    UIView * cellContent;
    IBOutlet    UILabel * _title;
    IBOutlet    UILabel * _resume;
}
- (id)init
{
    self = [super init];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"TTRSSFeedViewTableCell" owner:self options:nil];
    }
    return self;
}

-(void) updateWithFeed:(TTRSSFeed *) feed
{
    if (_feed) {
        [[TTRSSFeedsManager shareFeedManager] markReadArticle:_feed.identifier];
    }
    _feed = feed;
    _title.text = feed.title;
    _resume.text = feed.excerpt;
}

@end
