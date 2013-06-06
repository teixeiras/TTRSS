//
//  TTRSSFeed.m
//  TinyRSS
//
//  Created by Filipe Teixeira on 6/6/13.
//  Copyright (c) 2013 Filipe Teixeira. All rights reserved.
//

#import "TTRSSFeed.h"

@implementation TTRSSFeed
{
    bool        _always_display_attachments;
    NSString    * _author;
    int         _comments_count;
    NSString    * _comments_link;
    NSString    * _excerpt;
    int         _feed_id;
    NSString    * _feed_title;
    int         _identifier;
    bool        _is_updated;
    NSArray     * _labels;
    NSString    * _link;
    bool        _marked;
    bool        _published;
    int         _score;
    NSArray     * _tags;
    NSString    * _title;
    bool        _unread;
    int         _updated;
}
@synthesize always_display_attachments = _always_display_attachments;
@synthesize author = _author;
@synthesize comments_count = _comments_count;
@synthesize comments_link = _comments_link;
@synthesize excerpt = _excerpt;
@synthesize feed_id = _feed_id;
@synthesize feed_title = _feed_title;
@synthesize identifier = _identifier;
@synthesize is_updated = _is_updated;
@synthesize labels = _labels;
@synthesize link = _link;
@synthesize marked = _marked;
@synthesize published = _published;
@synthesize score = _score;
@synthesize tags = _tags;
@synthesize title = _title;
@synthesize unread = _unread;
@synthesize updated = _updated;
@end
