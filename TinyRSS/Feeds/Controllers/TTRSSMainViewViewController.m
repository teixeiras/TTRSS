//
//  TTRSSMainViewViewController.m
//  TinyRSS
//
//  Created by Filipe Teixeira on 6/4/13.
//  Copyright (c) 2013 Filipe Teixeira. All rights reserved.
//
#import "TTRSSCategoriesViewController.h"
#import "TTRSSMainViewViewController.h"
#import "TTRSSSettingsViewController.h"
#import "TTRSSFeedsManager.h"
#import "TTRSSFeed.h"

@interface TTRSSMainViewViewController ()
{
    NSMutableArray * _feeds;
}
@end

@implementation TTRSSMainViewViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFeedFromCategory:) name:KUpdateFeedOnCategory object:nil];
         }
    return self;
}

-(void) updateFeedFromCategory:(NSNotification *)notification
{
    int category = [[[notification userInfo] valueForKey:@"category"] intValue];
    [[TTRSSFeedsManager shareFeedManager] getUnreadHeadlines:0 andLimit:50 category:category onSuccess:^(NSArray * feeds) {
        _feeds = [NSMutableArray new];
        for(NSDictionary * feed in feeds) {
            TTRSSFeed * tmpFeed = [TTRSSFeed  new];
            tmpFeed.always_display_attachments = [feed[@"_always_display_attachments"] integerValue];
            tmpFeed.author = feed[@"author"];
            tmpFeed.comments_count = [feed[@"comments_count"] integerValue];;
            tmpFeed.comments_link = feed[@"comments_link"];
            tmpFeed.excerpt = feed[@"excerpt"];
            tmpFeed.feed_id = [feed[@"feed_id"] integerValue];;
            tmpFeed.feed_title = feed[@"feed_title"];
            tmpFeed.identifier = [feed[@"id"] integerValue];;
            tmpFeed.is_updated = [feed[@"is_updated"] integerValue];;
            tmpFeed.labels = feed[@"labels"];
            tmpFeed.link = feed[@"link"];
            tmpFeed.marked = [feed[@"marked"] integerValue];;
            tmpFeed.published = [feed[@"published"] integerValue];;
            tmpFeed.score = [feed[@"score"] integerValue];;
            tmpFeed.tags = feed[@"tags"];
            tmpFeed.title = feed[@"title"];
            tmpFeed.unread = [feed[@"unread"] integerValue];;
            tmpFeed.updated = [feed[@"updated"] integerValue];;
            [_feeds addObject:tmpFeed];
        }
        [self.tableView reloadData];
        
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.slideNavigationViewController.delegate = self;
    self.slideNavigationViewController.dataSource = self;

    UIBarButtonItem * itemCategory = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(showCategories)];
     self.navigationItem.rightBarButtonItem = itemCategory;
    UIBarButtonItem * itemSettings = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(showSettings)];
    self.navigationItem.rightBarButtonItem = itemSettings;

}

-(void) showCategories
{
    [self.slideNavigationViewController slideWithDirection:MWFSlideDirectionLeft];

}

-(void) showSettings
{
    [self.navigationController pushViewController:[TTRSSSettingsViewController new] animated:true];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) slideNavigationViewController:(MWFSlideNavigationViewController *)controller
                   distanceForSlideDirecton:(MWFSlideDirection)direction
                        portraitOrientation:(BOOL)portraitOrientation
{
    if (portraitOrientation)
    {
        return 180;
    }
    else
    {
        return 100;
    }
}


- (UIViewController *) slideNavigationViewController:(MWFSlideNavigationViewController *)controller viewControllerForSlideDirecton:(MWFSlideDirection)direction
{
    TTRSSCategoriesViewController * menuCtl = [TTRSSCategoriesViewController new];
    return menuCtl;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_feeds count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        TTRSSFeed * feed = _feeds[indexPath.row];
        cell.textLabel.text = feed.title;
        cell.detailTextLabel.text = feed.excerpt;
    }
    
    // Configure the cell...
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
}

@end
