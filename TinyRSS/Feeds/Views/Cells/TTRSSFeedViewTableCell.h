//
//  TTRSSFeedViewTableCell.h
//  TinyRSS
//
//  Created by Filipe Teixeira on 6/7/13.
//  Copyright (c) 2013 Filipe Teixeira. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTRSSFeed.h"
@interface TTRSSFeedViewTableCell : UITableViewCell
@property    UILabel * title;
@property    UILabel * source;
-(void) updateWithFeed:(TTRSSFeed *) feed;
@end
