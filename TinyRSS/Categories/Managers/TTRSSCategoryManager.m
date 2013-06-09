//
//  TTRSSCategoryManager.m
//  TinyRSS
//
//  Created by Filipe Teixeira on 6/5/13.
//  Copyright (c) 2013 Filipe Teixeira. All rights reserved.
//

#import "TTRSSCategoryManager.h"
#import "TTRSSAppDelegate.h"

#import "TTRSSJSonParser.h"
@interface TTRSSCategoryManager()
{
    NSMutableArray * _categories;
}
@end
@implementation TTRSSCategoryManager
@synthesize categories = _categories;
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
        _categories = [NSMutableArray new];
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

-(void) loadCategories
{
    NSManagedObjectContext *context = [[TTRSSAppDelegate instance] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TTRSSCategoryCData"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError * error;
    @synchronized(_categories) {
        _categories = [NSMutableArray new];
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        for (TTRSSCategoryCData *info in fetchedObjects) {
            [_categories addObject:[[TTRSSCategory alloc] initWithCoreData:info]];
        }
    }
    
}

-(NSArray *) retrieveCategoriesWithBlock:(void(^)(NSArray *)) onRetrieve
{    
    [TTRSSJSonParser newWithDictionary:@{@"op":@"getCategories"} onRequestSuccessfull:^(NSDictionary * dic) {
        @synchronized(_categories) {
            [self deleteAllObjects:@"TTRSSCategoryCData"];
        _categories = [NSMutableArray new];
        if (dic[@"content"] && [dic[@"content"] isKindOfClass:[NSArray class]]) {
            for (NSDictionary * categoryDic in dic[@"content"]) {
                TTRSSCategory * category = [TTRSSCategory new];
                category.order_id   = [categoryDic[@"order_id"] integerValue];
                category.identifier = [categoryDic[@"id"] integerValue];
                category.title      =  categoryDic[@"title"];
                category.unread     = [categoryDic[@"unread"] integerValue];
                [_categories addObject:category];
                [category store];
            }
        }
        (onRetrieve)(_categories);
        }
    }];
    return _categories;
}

- (void) deleteAllObjects: (NSString *) entityDescription  {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:[[TTRSSAppDelegate instance] managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [[[TTRSSAppDelegate instance] managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    
    for (NSManagedObject *managedObject in items) {
    	[[[TTRSSAppDelegate instance] managedObjectContext]  deleteObject:managedObject];
    }
    if (![[[TTRSSAppDelegate instance] managedObjectContext]  save:&error]) {
    }
    
}

@end
