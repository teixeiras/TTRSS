//
//  TTRSSCategory.m
//  TinyRSS
//
//  Created by Filipe Teixeira on 6/5/13.
//  Copyright (c) 2013 Filipe Teixeira. All rights reserved.
//
#import "TTRSSAppDelegate.h"
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


-(void) store
{
    NSManagedObjectContext *context = [[TTRSSAppDelegate instance] managedObjectContext];
    TTRSSCategoryCData *category = [NSEntityDescription
                                      insertNewObjectForEntityForName:@"TTRSSCategoryCData"
                                      inManagedObjectContext:context];
    category.identifier = [NSNumber numberWithInt:_identifier];
    category.order_id = [NSNumber numberWithInt:_order_id];
    category.unread = [NSNumber numberWithInt:_unread];
    category.title = _title;
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

-(id) initWithCoreData:(TTRSSCategoryCData *) data
{
    if(self = [super init]) {
        _title = data.title;
        _unread = data.unread.integerValue;
        _identifier = data.identifier.integerValue;
        _order_id = data.order_id.integerValue;
       
    }
    return  self;
}
@end
