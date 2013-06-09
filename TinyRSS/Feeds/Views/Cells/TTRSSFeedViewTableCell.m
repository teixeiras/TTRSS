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
    IBOutlet    UIView  * _cellContent;
    IBOutlet    UILabel * _title;
    IBOutlet    UILabel * _source;
}

@synthesize title = _title;
@synthesize source = _source;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"TTRSSFeedViewTableCell" owner:self options:nil];
        [self.contentView addSubview:_cellContent];
        _cellContent.frame = self.frame;
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
    _source.text = feed.feed_title;
}

@end
