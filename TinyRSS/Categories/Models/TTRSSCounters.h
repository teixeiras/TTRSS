//
//  TTRSSCounters.h
//  TinyRSS
//
//  Created by Filipe Teixeira on 6/7/13.
//  Copyright (c) 2013 Filipe Teixeira. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTRSSCounters : NSObject
@property int       auxcounter;
@property int       counter;
@property int       identifier;
@property int       has_img;
@property NSString  * updated;
@property NSString  * error;
@property NSString  * kind;
@end

