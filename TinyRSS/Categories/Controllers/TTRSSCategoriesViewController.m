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

@interface TTRSSCategoriesViewController ()
{
    NSArray * _categories;
}
@end

@implementation TTRSSCategoriesViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.view.backgroundColor = [UIColor redColor];
         _categories = [[TTRSSCategoryManager shareCategoryManager] retrieveCategoriesWithBlock:^(NSArray * categories) {
             _categories = categories;
             [self.tableView reloadData];
        }];
        [self.tableView reloadData];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

   
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        TTRSSCategory * category = _categories[indexPath.row];
        cell.textLabel.text = category.title;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.slideNavigationViewController slideWithDirection:MWFSlideDirectionNone];
}

@end
