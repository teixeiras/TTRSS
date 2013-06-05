//
//  TTRSSCategory.h
//  TinyRSS
//
//  Created by Filipe Teixeira on 6/5/13.
//  Copyright (c) 2013 Filipe Teixeira. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTRSSCategory : NSObject

@property     int identifier;
@property     int order_id;
@property     NSString * title;
@property     int unread;

@end
