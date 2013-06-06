//
//  TTRSSFeedsManager.m
//  TinyRSS
//
//  Created by Filipe Teixeira on 6/6/13.
//  Copyright (c) 2013 Filipe Teixeira. All rights reserved.
//

#import "TTRSSFeedsManager.h"
#import "TTRSSJSonParser.h"


NSString * const KUpdateFeedOnCategory=@"notification.updateFeed.Category";

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
            (block)(dic[@"content"]);
        }
    }];

 }
@end
