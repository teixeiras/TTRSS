//
//  TTRSSCategoryManager.m
//  TinyRSS
//
//  Created by Filipe Teixeira on 6/5/13.
//  Copyright (c) 2013 Filipe Teixeira. All rights reserved.
//

#import "TTRSSCategoryManager.h"
#import "TTRSSJSonParser.h"
@interface TTRSSCategoryManager()
{
    NSMutableArray * _categories;
}
@end
@implementation TTRSSCategoryManager

+(TTRSSCategoryManager *) shareCategoryManager
{
    static TTRSSCategoryManager * categoryManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        categoryManager = [TTRSSCategoryManager new];
    });
    return categoryManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)counters:(void(^)(NSDictionary *)) onRetrieve
{
    [TTRSSJSonParser newWithDictionary:@{@"op":@"getCounters",@"output_mode":@"flct"} onRequestSuccessfull:^(NSDictionary * dic) {
            NSMutableDictionary * dicCount = [NSMutableDictionary new];
            if (dic[@"content"] && [dic[@"content"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary * counterDic in dic[@"content"]) {
                    TTRSSCounters * counter = [TTRSSCounters new];
                    counter.auxcounter  = [counterDic[@"counter"] integerValue];
                    counter.counter     = [counterDic[@"id"] integerValue];
                    counter.identifier  = [counterDic[@"id"] integerValue];
                    counter.has_img     = [counterDic[@"has_img"] integerValue];
                    counter.updated     = counterDic[@"updated"];
                    counter.error       = counterDic[@"order_id"];
                    counter.kind        = counterDic[@"kind"];
                    dicCount[[NSNumber numberWithInt:counter.identifier]] = counter;
                }
            }
            (onRetrieve)(dicCount);
        
    }];
}


-(NSArray *) retrieveCategoriesWithBlock:(void(^)(NSArray *)) onRetrieve
{    
    [TTRSSJSonParser newWithDictionary:@{@"op":@"getCategories"} onRequestSuccessfull:^(NSDictionary * dic) {
        _categories = [NSMutableArray new];
        if (dic[@"content"] && [dic[@"content"] isKindOfClass:[NSArray class]]) {
            for (NSDictionary * categoryDic in dic[@"content"]) {
                TTRSSCategory * category = [TTRSSCategory new];
                category.order_id   = [categoryDic[@"order_id"] integerValue];
                category.identifier = [categoryDic[@"id"] integerValue];
                category.title      =  categoryDic[@"title"];
                category.unread     = [categoryDic[@"unread"] integerValue];
                [_categories addObject:category];
            }
        }
        (onRetrieve)(_categories);
        
    }];
    return _categories;
}
@end
