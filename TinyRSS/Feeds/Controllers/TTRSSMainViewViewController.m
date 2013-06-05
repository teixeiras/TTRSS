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

@interface TTRSSMainViewViewController ()

@end

@implementation TTRSSMainViewViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
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
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
}

@end
