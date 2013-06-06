//
//  TTRSSFeedsManager.m
//  TinyRSS
//
//  Created by Filipe Teixeira on 6/6/13.
//  Copyright (c) 2013 Filipe Teixeira. All rights reserved.
//

#import "TTRSSFeedsManager.h"
#import "TTRSSJSonParser.h"


typedef NS_ENUM(NSInteger, ViewMode) {
    ViewMode_all_articles,
    ViewMode_unread,
    ViewMode_adaptive,
    ViewMode_marked,
    ViewMode_updated
};
typedef NS_ENUM(NSInteger, SortMode) {
    SortMode_date_reverse,
    SortMode_feed_dates,
    SortMode_default

};
typedef NS_ENUM(NSInteger, SpecialIds) {
    SpecialIds_starred = -1,
    SpecialIds_published = -2,
    SpecialIds_fresh = -3,
    SpecialIds_all_articles = -4,
    SpecialIds_archived = 0
};


@interface TTRSSFeedsManager()
{
    NSMutableArray * feeds;
}
@end

@implementation TTRSSFeedsManager

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
        NSMutableArray * _feeds = [NSMutableArray new];
        NSLog(@"%@",dic);
        /*
        for (NSDictionary * categoryDic in dic[@"content"]) {
            TTRSSCategory * category = [TTRSSCategory new];
            category.order_id   = [categoryDic[@"order_id"] integerValue];
            category.identifier = [categoryDic[@"id"] integerValue];
            category.title      = categoryDic[@"title"];
            category.unread     = [categoryDic[@"unread"] integerValue];
            [_categories addObject:category];
         }
         */
        (block)(_feeds);
    }];

 }
@end
