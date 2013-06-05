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

-(NSArray *) retrieveCategoriesWithBlock:(void(^)(NSArray *)) onRetrieve
{    
    [TTRSSJSonParser newWithDictionary:@{@"op":@"getCategories"} onRequestSuccessfull:^(NSDictionary * dic) {
        _categories = [NSMutableArray new];
        for (NSDictionary * categoryDic in dic[@"content"]) {
            TTRSSCategory * category = [TTRSSCategory new];
            category.order_id   = [categoryDic[@"order_id"] integerValue];
            category.identifier = [categoryDic[@"id"] integerValue];
            category.title      = categoryDic[@"title"];
            category.unread     = [categoryDic[@"unread"] integerValue];
            [_categories addObject:category];
        }
        (onRetrieve)(_categories);
        
    }];
    return _categories;
}
@end
