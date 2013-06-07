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
#import "TTRSSFeedViewerViewController.h"
#import "TTRSSFeedsManager.h"
#import "TTRSSFeed.h"

@interface TTRSSMainViewViewController ()
{
    NSMutableArray * _feeds;
    TTRSSFeedViewerViewController * _feedViewer;
}
@end

@implementation TTRSSMainViewViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        _feedViewer = [TTRSSFeedViewerViewController new];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFeedFromCategory:) name:KUpdateFeedOnCategoryNotification object:nil];
         }
    return self;
}

-(void) updateFeedFromCategory:(NSNotification *)notification
{
    int category = [[[notification userInfo] valueForKey:@"category"] intValue];
    void(^updateTable)(NSArray *) = ^(NSArray * feeds) {
          _feeds = [NSMutableArray new];
        for(NSDictionary * feed in feeds) {
            [_feeds addObject:feed];
        }
        [self.tableView reloadData];
    };
    self.navigationItem.title = [[notification userInfo] valueForKey:@"title"];
    if (category < 0) {
        switch (category) {
            case -1:
                [[TTRSSFeedsManager shareFeedManager] getPublishedHeadlines:0 andLimit:50 onSuccess:updateTable];
                break;
            case -2:
                [[TTRSSFeedsManager shareFeedManager] getStarredHeadlines:0 andLimit:50 onSuccess:updateTable];

                break;
            case -3:
                [[TTRSSFeedsManager shareFeedManager] getFreshHeadlines:0 andLimit:50 onSuccess:updateTable];
                break;
            case -4:
                [[TTRSSFeedsManager shareFeedManager] getAllArticlesHeadlines:0 andLimit:50 onSuccess:updateTable];
                break;
            default:
                //label
                break;
        }
    } else {
        [[TTRSSFeedsManager shareFeedManager] getUnreadHeadlines:0 andLimit:50 category:category onSuccess:updateTable];
        
    }
    

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
    [self.navigationController pushViewController:_feedViewer animated:true];
    TTRSSFeed * feed = _feeds[indexPath.row];

    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:feed.identifier] forKey:@"feedId"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kShowFeedNotification object:nil userInfo:userInfo];
}

@end
