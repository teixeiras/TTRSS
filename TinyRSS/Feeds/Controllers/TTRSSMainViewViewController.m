//
//  TTRSSMainViewViewController.m
//  TinyRSS
//
//  Created by Filipe Teixeira on 6/4/13.
//  Copyright (c) 2013 Filipe Teixeira. All rights reserved.
//
#import "UIScrollView+SVInfiniteScrolling.h"
#import "TTRSSCategoriesViewController.h"
#import "TTRSSFeedViewerViewController.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "TTRSSMainViewViewController.h"
#import "TTRSSSettingsViewController.h"
#import "TTRSSFeedViewTableCell.h"
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
-(void) viewDidLoad
{
    [super viewDidLoad];

    __weak TTRSSMainViewViewController * weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        int category = [[NSUserDefaults standardUserDefaults] integerForKey:@"lastCategory"];
        [weakSelf updateCategory:category restart:true onFinish:^{
            dispatch_async(dispatch_get_main_queue(),^(){
                [weakSelf.tableView reloadData];
                [weakSelf.tableView.pullToRefreshView stopAnimating];
            });
        }];
    }];

    [self.tableView addInfiniteScrollingWithActionHandler:^{
        int category = [[NSUserDefaults standardUserDefaults] integerForKey:@"lastCategory"];
        [weakSelf updateCategory:category restart:false onFinish:^{
            dispatch_async(dispatch_get_main_queue(),^(){
                [weakSelf.tableView reloadData];
                [weakSelf.tableView.infiniteScrollingView stopAnimating];
            });
        }];
        
        
    }];
    
    self.slideNavigationViewController.delegate = self;
    self.slideNavigationViewController.dataSource = self;
    
    UIBarButtonItem * itemCategory = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(showCategories)];
    self.navigationItem.rightBarButtonItem = itemCategory;
    UIBarButtonItem * itemSettings = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(showSettings)];
    self.navigationItem.rightBarButtonItem = itemSettings;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"lastCategory"]) {
        int category = [[NSUserDefaults standardUserDefaults] integerForKey:@"lastCategory"];
        [self updateCategory:category restart: true onFinish:^{
            dispatch_async(dispatch_get_main_queue(),^(){
                [weakSelf.tableView reloadData];
            });
        }];
    }
}

-(void) updateCategory:(int) category restart:(bool) restart onFinish:(void(^)(void)) block;
{
    void(^updateTable)(NSArray *) = ^(NSArray * feeds) {
        

        for(NSDictionary * feed in feeds) {
            [_feeds addObject:feed];
        }
        
        if (!block) {
            [self.tableView reloadData];
        } else {
            (block)();
        }
    
    };
    if (restart) {
        _feeds = [NSMutableArray new];
    }
    int start = _feeds.count;
    if (category < 0) {
        switch (category) {
            case -1:
                [[TTRSSFeedsManager shareFeedManager] getPublishedHeadlines:start andLimit:50 onSuccess:updateTable];
                break;
            case -2:
                [[TTRSSFeedsManager shareFeedManager] getStarredHeadlines:start andLimit:50 onSuccess:updateTable];
                
                break;
            case -3:
                [[TTRSSFeedsManager shareFeedManager] getFreshHeadlines:start andLimit:50 onSuccess:updateTable];
                break;
            case -4:
                [[TTRSSFeedsManager shareFeedManager] getAllArticlesHeadlines:start andLimit:50 onSuccess:updateTable];
                break;
            default:
                //label
                break;
        }
    } else {
        [[TTRSSFeedsManager shareFeedManager] getUnreadHeadlines:start andLimit:50 category:category onSuccess:updateTable];
        
    }
    
}
-(void) updateFeedFromCategory:(NSNotification *)notification
{
    self.navigationItem.title = [[notification userInfo] valueForKey:@"title"];
    int category = [[[notification userInfo] valueForKey:@"category"] intValue];
     [[NSUserDefaults standardUserDefaults] setInteger:category forKey:@"lastCategory"];
    [self updateCategory:category restart:true onFinish:nil];
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

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
    TTRSSFeedViewTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TTRSSFeedViewTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    TTRSSFeed * feed = _feeds[indexPath.row];
    [cell updateWithFeed:feed];

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
