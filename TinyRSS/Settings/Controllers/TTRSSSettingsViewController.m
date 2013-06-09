//
//  TTRSSSettingsViewController.m
//  TinyRSS
//
//  Created by Filipe Teixeira on 6/5/13.
//  Copyright (c) 2013 Filipe Teixeira. All rights reserved.
//

#import "TTRSSSettingsViewController.h"
#import "TTRSSConfig.h"

@interface TTRSSSettingsTextFieldCell:UITableViewCell<UITextFieldDelegate>
{
    IBOutlet UIView      * _view;
    IBOutlet UILabel     * _label;
    IBOutlet UITextField * _input;
    
    void(^_onDismiss)(UITextField *);
}
@property UILabel * label;
@property UITextField * input;
@property void(^onDismiss)(UITextField *);
@end

@implementation TTRSSSettingsTextFieldCell
@synthesize label = _label;
@synthesize input = _input;
@dynamic onDismiss;
-(void)setOnDismiss:(void (^)(UITextField *))onDismiss
{
    _onDismiss = onDismiss;
}
-(void (^)(UITextField *))onDismiss
{
    return _onDismiss;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"TTRSSSettingsTextFieldCell" owner:self options:nil];
        [self.contentView addSubview:_view];
        _input.delegate = self;
    }

    return self;
}
-(void) textFieldDidEndEditing:(UITextField *)textField
{
    (_onDismiss)(textField);
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
        NSDictionary * address = @{@"type":@"text", @"label":@"Address",@"value":[TTRSSConfig getConfigValue:@"server"],@"onPress":^(UITextField * field) {
            [[NSUserDefaults standardUserDefaults] setValue:field.text forKey:@"server"];
            [TTRSSConfig initialize];
            
        }};
        NSDictionary * username = @{@"type":@"text", @"label":@"Username",@"value":[TTRSSConfig getConfigValue:@"user"], @"onPress":^(UITextField * field) {
            [[NSUserDefaults standardUserDefaults] setValue:field.text forKey:@"user"];
            [TTRSSConfig initialize];
        }};
        NSDictionary * password = @{@"type":@"password", @"label":@"Password",@"value":[TTRSSConfig getConfigValue:@"password"],@"onPress":^(UITextField * field) {
            [[NSUserDefaults standardUserDefaults] setValue:field.text forKey:@"password"];
            [TTRSSConfig initialize];
        }};
        [_credentials addObject:address];
        [_credentials addObject:username];
        [_credentials addObject:password];

    }
    return self;
}

-(void)viewDidLoad
{
   self.navigationItem.title=@"Configurations";
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
                cell.onDismiss = dic[@"onPress"];
                cell.label.text = dic[@"label"];
                if (dic[@"value"]) {
                    cell.input.text = dic[@"value"];
                }
                return cell;
            }
            if ([dic[@"type"] isEqualToString:@"password" ]) {
                TTRSSSettingsTextFieldCell * cell = [[TTRSSSettingsTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.onDismiss = dic[@"onPress"];
                cell.label.text = dic[@"label"];
                cell.input.secureTextEntry = true;
                if (dic[@"value"]) {
                    cell.input.text = dic[@"value"];
                }
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
