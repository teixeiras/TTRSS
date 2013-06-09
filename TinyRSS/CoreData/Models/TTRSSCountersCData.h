//
//  TTRSSCountersCData.h
//  TinyRSS
//
//  Created by Filipe Teixeira on 6/9/13.
//  Copyright (c) 2013 Filipe Teixeira. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TTRSSCountersCData : NSManagedObject

@property (nonatomic, retain) NSNumber * auxcounter;
@property (nonatomic, retain) NSNumber * counter;
@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSNumber * has_img;
@property (nonatomic, retain) NSString * updated;
@property (nonatomic, retain) NSString * error;
@property (nonatomic, retain) NSString * kind;

@end
