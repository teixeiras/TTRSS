//
//  TTRSSFeed.h
//  TinyRSS
//
//  Created by Filipe Teixeira on 6/6/13.
//  Copyright (c) 2013 Filipe Teixeira. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTRSSFeed : NSObject
@property bool        always_display_attachments;
@property NSString    * author;
@property int         comments_count;
@property NSString    * comments_link;
@property NSString    * excerpt;
@property int         feed_id;
@property NSString    * feed_title;
@property int         identifier;
@property bool        is_updated;
@property NSArray     * labels;
@property NSString    * link;
@property bool        marked;
@property bool        published;
@property int         score;
@property NSArray     * tags;
@property NSString    * title;
@property bool        unread;
@property int         updated;
@property NSString    * content;

@end
