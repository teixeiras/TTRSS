//
//  TTRSSSettingsViewController.m
//  TinyRSS
//
//  Created by Filipe Teixeira on 6/5/13.
//  Copyright (c) 2013 Filipe Teixeira. All rights reserved.
//

#import "TTRSSSettingsViewController.h"

@interface TTRSSSettingsTextFieldCell:UITableViewCell
{
    IBOutlet UIView      * _view;
    IBOutlet UILabel     * _label;
    IBOutlet UITextField * _input;
}
@property UILabel * label;
@property UITextField * input;
@end

@implementation TTRSSSettingsTextFieldCell
@synthesize label = _label;
@synthesize input = _input;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"TTRSSSettingsTextFieldCell" owner:self options:nil];
        [self.contentView addSubview:_view];
    }
    return self;
}
@end


@interface TTRSSSettingsViewController ()
{
    NSMutableArray * _credentials;
}
@end

@implementation TTRSSSettingsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        _credentials= [NSMutableArray new];
        NSDictionary * address = @{@"type":@"text", @"label":@"Address",@"onPress":^(UITextField * field) {
            
        }};
        NSDictionary * username = @{@"type":@"text", @"label":@"Username",@"onPress":^(UITextField * field) {
            
        }};
        NSDictionary * password = @{@"type":@"text", @"label":@"Password",@"onPress":^(UITextField * field) {
            
        }};
        [_credentials addObject:address];
        [_credentials addObject:username];
        [_credentials addObject:password];

    }
    return self;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _credentials.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    switch (indexPath.section) {
        case 0:
        {
            NSDictionary * dic = _credentials[indexPath.row];
            if ([dic[@"type"] isEqualToString:@"text" ]) {
                TTRSSSettingsTextFieldCell * cell = [[TTRSSSettingsTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.label.text = dic[@"label"];
                return cell;
            }
            break;
        }
        default:
            break;
    }
    return nil;

}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
