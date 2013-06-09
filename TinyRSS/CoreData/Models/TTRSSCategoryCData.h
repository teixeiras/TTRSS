//
//  TTRSSCategoryCData.h
//  TinyRSS
//
//  Created by Filipe Teixeira on 6/9/13.
//  Copyright (c) 2013 Filipe Teixeira. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TTRSSCategoryCData : NSManagedObject

@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSNumber * order_id;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * unread;

@end
