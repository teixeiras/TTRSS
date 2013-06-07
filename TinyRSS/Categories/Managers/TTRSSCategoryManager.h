//
//  TTRSSCategoryManager.h
//  TinyRSS
//
//  Created by Filipe Teixeira on 6/5/13.
//  Copyright (c) 2013 Filipe Teixeira. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTRSSCategory.h"
#import "TTRSSCounters.h"
@interface TTRSSCategoryManager : NSObject
+(TTRSSCategoryManager *) shareCategoryManager;
-(NSArray *) retrieveCategoriesWithBlock:(void(^)(NSArray *)) onRetrieve;
-(void)counters:(void(^)(NSDictionary *)) onRetrieve;
@end
