//
//  TTRSSFeedsManager.m
//  TinyRSS
//
//  Created by Filipe Teixeira on 6/6/13.
//  Copyright (c) 2013 Filipe Teixeira. All rights reserved.
//

#import "TTRSSFeedsManager.h"
#import "TTRSSJSonParser.h"

NSString * const KUpdateFeedOnCategoryNotification=@"notification.updateFeed.Category";
NSString * const kShowFeedNotification =@"notification.getArticle.identifier";
@interface TTRSSFeedsManager()
{
    NSMutableArray * feeds;
}
@end

@implementation TTRSSFeedsManager

+(TTRSSFeedsManager *) shareFeedManager
{
    static TTRSSFeedsManager * feedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        feedManager = [TTRSSFeedsManager new];
    });
    return feedManager;
}

-(NSString * )sortMode:(SortMode) mode
{
    switch(mode) {
        case SortMode_date_reverse:
            return @"date_reverse";
            break;
        case SortMode_feed_dates:
            return @"feed_dates";
            break;
        case SortMode_default:
            return @"";
            break;
    };
}

-(NSString * )viewMode:(ViewMode) mode
{
    switch(mode) {
        case ViewMode_all_articles:
            return @"all_articles";
            break;
        case ViewMode_unread:
            return @"unread";
            break;
        case ViewMode_adaptive:
            return @"adaptive";
            break;
        case ViewMode_marked:
            return @"marked";
            break;
        case ViewMode_updated:
            return @"updated";
            break;
    }
}
-(void) getUnreadHeadlines:(int) start andLimit:(int) limit category:(int) category onSuccess:(void(^)(NSArray *)) block
{
    [self getHeadlines:start andLimit:limit category:category mode:ViewMode_unread withContent:false onSuccess:block];
}

-(void) getAllHeadlines:(int) start andLimit:(int) limit category:(int) category onSuccess:(void(^)(NSArray *)) block
{
    [self getHeadlines:start andLimit:limit category:category mode:ViewMode_all_articles withContent:false onSuccess:block];
}

-(void) getHeadlines:(int) start andLimit:(int) limit category:(int) category mode:(ViewMode) mode withContent:(bool) content onSuccess:(void(^)(NSArray *)) block
{
    NSDictionary * dic = @{
        @"op"                 :@"getHeadlines",
        @"feed_id"            :[NSString stringWithFormat:@"%d", category],
        @"limit"              :[NSString stringWithFormat:@"%d", limit],
        @"skip"               :[NSString stringWithFormat:@"%d", start],
        @"filter"             :@"",
        @"is_cat"             :@"true",
        @"show_excerpt"       :@"true",
        @"show_content"       :(content?@"true":@"false"),
        @"view_mode"          :[self viewMode:mode],
        @"include_attachments":@"false",
        //@"since_id"           :@"",
        @"include_nested"     :@"true",
        //@"order_by"           :@"",
        @"sanitize"           :@"true"
    };
    
    [TTRSSJSonParser newWithDictionary:dic onRequestSuccessfull:^(NSDictionary * dic) {
        if (dic[@"content"] && [dic[@"content"] isKindOfClass:[NSArray class]]) {
            NSMutableArray * array = [NSMutableArray new];
            for (NSDictionary *feedDic in dic[@"content"]) {
                [array addObject:[self populateFeed:feedDic]];
            }
            (block)(array);
        }
    }];

 }
-(void) getArticle:(int) identifier onSuccess:(void(^)(TTRSSFeed *)) block
{
    NSDictionary * dic = @{
                           @"op"                 :@"getArticle",
                           @"article_id"         :[NSString stringWithFormat:@"%d", identifier]
                           };
    
    [TTRSSJSonParser newWithDictionary:dic onRequestSuccessfull:^(NSDictionary * dic) {
        
        if (dic[@"content"] && [dic[@"content"] isKindOfClass:[NSArray class]]) {
            (block)([self populateFeed:dic[@"content"][0]]);
        }
    }];
    
}

-(TTRSSFeed *) populateFeed:(NSDictionary *) feed
{
    TTRSSFeed * tmpFeed = [TTRSSFeed  new];
    tmpFeed.always_display_attachments = [feed[@"_always_display_attachments"] integerValue];
    tmpFeed.author = feed[@"author"];
    tmpFeed.comments_count = [feed[@"comments_count"] integerValue];
    tmpFeed.comments_link = feed[@"comments_link"];
    tmpFeed.excerpt = feed[@"excerpt"];
    tmpFeed.feed_id = [feed[@"feed_id"] integerValue];
    tmpFeed.feed_title = feed[@"feed_title"];
    tmpFeed.identifier = [feed[@"id"] integerValue];
    tmpFeed.is_updated = [feed[@"is_updated"] integerValue];
    tmpFeed.labels = feed[@"labels"];
    tmpFeed.link = feed[@"link"];
    tmpFeed.marked = [feed[@"marked"] integerValue];
    tmpFeed.published = [feed[@"published"] integerValue];
    tmpFeed.score = [feed[@"score"] integerValue];
    tmpFeed.tags = feed[@"tags"];
    tmpFeed.title = feed[@"title"];
    tmpFeed.unread = [feed[@"unread"] integerValue];
    tmpFeed.updated = [feed[@"updated"] integerValue];
    tmpFeed.content =feed[@"content"];
    return tmpFeed;
}
@end
