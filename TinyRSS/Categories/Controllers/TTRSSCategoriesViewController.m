//
//  TTRSSCategoriesViewController.m
//  TinyRSS
//
//  Created by Filipe Teixeira on 6/5/13.
//  Copyright (c) 2013 Filipe Teixeira. All rights reserved.
//
#import "MWFSlideNavigationViewController.h"
#import "TTRSSCategoriesViewController.h"
#import "TTRSSCategoryManager.h"
#import "TTRSSFeedsManager.h"
@interface TTRSSCategoriesViewController ()
{
    NSArray      * _special;
    NSArray      * _categories;
    NSArray      * _labels;
    NSDictionary * _counters;   
}
@end

@implementation TTRSSCategoriesViewController
- (id)init
{
    self = [super init];
    if (self) {
        
        _special = @[@{@"identifier":[NSNumber numberWithInt:-4],@"text":@"All articles"},
                     @{@"identifier":[NSNumber numberWithInt:-2],@"text":@"Fresh articles"},
                     @{@"identifier":[NSNumber numberWithInt:-1],@"text":@"Starred articles"},
                     @{@"identifier":[NSNumber numberWithInt:-2],@"text":@"Published articles"}];
    }
    return self;
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.view.backgroundColor = [UIColor blackColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
         
        [self.tableView reloadData];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[TTRSSCategoryManager shareCategoryManager ]counters:^(NSDictionary * elements){
        _counters = elements;
        _categories = [[TTRSSCategoryManager shareCategoryManager] retrieveCategoriesWithBlock:^(NSArray * categories) {
            _categories = categories;
            [self.tableView reloadData];
        }];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return _special.count;
        case 1:
            return _categories.count;
        case 2:
            return _labels.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell;
    switch (indexPath.section) {
        case 0:
            return [self specialCell:indexPath.row tableView:tableView];
        case 1:
            return [self categoriesCell:indexPath.row tableView:tableView];
        case 2:
            return [self labelsCell:indexPath.row tableView:tableView];
    }
    return cell;
}

-(UITableViewCell *) specialCell:(int) index tableView:(UITableView *)tableView
{
    static NSString *CellIdentifier = @"specialsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        NSDictionary * special = _special[index];
        cell.textLabel.text = special[@"text"];
        cell.textLabel.textColor = [UIColor whiteColor];
        TTRSSCounters * counter = _counters[special[@"identifier"]];
        if (counter && counter.counter) {
            UILabel * label = [UILabel new];
            label.text = [NSString stringWithFormat:@"%d", counter.counter];
            [label sizeToFit];
            cell.accessoryView = label;
        } else {
            cell.accessoryView = nil;
        }
    }
    return cell;
}

-(UITableViewCell *) categoriesCell:(int) index tableView:(UITableView *)tableView
{
    static NSString *CellIdentifier = @"categoriesCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        TTRSSCategory * category = _categories[index];
        cell.textLabel.text = category.title;
        cell.textLabel.textColor = [UIColor whiteColor];
        if (category.unread) {
            UILabel * label = [UILabel new];
            label.text = [NSString stringWithFormat:@"%d", category.unread];
            [label sizeToFit];
            cell.accessoryView = label;
        } else {
            cell.accessoryView = nil;
        }
    }
    return cell;
}

-(UITableViewCell *) labelsCell:(int) index tableView:(UITableView *)tableView
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:{
            NSDictionary * special = _special[indexPath.row];
            NSDictionary *userInfo = @{@"category":special[@"identifier"],
                                       @"title": special[@"text"]};
            
            [[NSNotificationCenter defaultCenter] postNotificationName:KUpdateFeedOnCategoryNotification object:nil userInfo:userInfo];
            break;
        }
        case 1: {
            TTRSSCategory * category = _categories[indexPath.row];
            NSDictionary *userInfo = @{@"category":[NSNumber numberWithInt:category.identifier],
                                       @"title": category.title};
                        
            [[NSNotificationCenter defaultCenter] postNotificationName:KUpdateFeedOnCategoryNotification object:nil userInfo:userInfo];
            
        }
        case 2:
        {
            
        }
        default:
            break;
    }
    
    
    
    [self.slideNavigationViewController slideWithDirection:MWFSlideDirectionNone];
}

@end
