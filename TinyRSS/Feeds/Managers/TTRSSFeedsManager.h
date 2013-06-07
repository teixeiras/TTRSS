//
//  TTRSSFeedsManager.h
//  TinyRSS
//
//  Created by Filipe Teixeira on 6/6/13.
//  Copyright (c) 2013 Filipe Teixeira. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTRSSFeed.h"

extern NSString * const KUpdateFeedOnCategoryNotification;
extern NSString * const kShowFeedNotification;
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


@interface TTRSSFeedsManager : NSObject
+(TTRSSFeedsManager *) shareFeedManager;

-(void) getUnreadHeadlines:(int) start andLimit:(int) limit category:(int) category onSuccess:(void(^)(NSArray *)) block;

-(void) getAllHeadlines:(int) start andLimit:(int) limit category:(int) category onSuccess:(void(^)(NSArray *)) block;
-(void) getArticle:(int) identifier onSuccess:(void(^)(TTRSSFeed *)) block;
@end
