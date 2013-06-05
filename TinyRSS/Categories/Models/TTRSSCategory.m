//
//  TTRSSCategory.m
//  TinyRSS
//
//  Created by Filipe Teixeira on 6/5/13.
//  Copyright (c) 2013 Filipe Teixeira. All rights reserved.
//

#import "TTRSSCategory.h"

@implementation TTRSSCategory
{
    NSString        * _title;
    int             _identifier;
    int             _order_id;
    int             _unread;
    
}
@synthesize identifier  = _identifier;
@synthesize title       = _title;
@synthesize unread      = _unread;
@synthesize order_id    = _order_id;
@end
