//
//  TTRSSCounters.m
//  TinyRSS
//
//  Created by Filipe Teixeira on 6/7/13.
//  Copyright (c) 2013 Filipe Teixeira. All rights reserved.
//

#import "TTRSSCounters.h"

@implementation TTRSSCounters
{
    int         _auxcounter;
    int         _counter;
    int         _identifier;
    int         _has_img;
    
    NSString    * _updated;
    NSString    * _error;
    NSString    * _kind;
}
@synthesize auxcounter  = _auxcounter;
@synthesize counter     = _counter;
@synthesize identifier  = _identifier;
@synthesize has_img     = _has_img;
@synthesize updated     = _updated;
@synthesize error       = _error;
@synthesize kind        = _kind;
@end
