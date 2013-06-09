//
//  TTRSSLaunchScreenViewController.m
//  TinyRSS
//
//  Created by Filipe Teixeira on 6/8/13.
//  Copyright (c) 2013 Filipe Teixeira. All rights reserved.
//

#import "TTRSSLaunchScreenViewController.h"
#import "TTRSSJSonParser.h"
#import "TTRSSConfig.h"


@interface TTRSSLaunchScreenViewController ()
{
    IBOutlet UITextField    * _server;
    IBOutlet UITextField    * _username;
    IBOutlet UITextField    * _password;
    IBOutlet UILabel        * _serverStatus;
    IBOutlet UILabel        * _connectionStatus;
    IBOutlet UIButton       * _storeConfig;
    IBOutlet UIScrollView   * _scrollview;
    
    UITextField             * _activeField;
    void (^onSuccess)(void);
}
@end

@implementation TTRSSLaunchScreenViewController

- (id)initWithBlockOnSuccess:(void(^)()) block
{
    self = [super init];
    if (self) {
        onSuccess = block;
    }
    return self;
}

-(void) viewDidLoad
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [tap setCancelsTouchesInView:NO];

    [self.view addGestureRecognizer:tap];
    [self registerForKeyboardNotifications];
    CGRect rect = _server.superview.frame;
    rect.size = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    _server.superview.frame = rect;
    _scrollview.contentSize = _server.superview.frame.size;
    _password.secureTextEntry = true;
}

- (void)viewDidUnload {
    
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
}

-(void)dismissKeyboard
{
    if (_activeField) {
        [_activeField resignFirstResponder];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _server) {
        _serverStatus.hidden = true;

    }
    _activeField = textField;
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _server) {
        NSString* link = [NSString stringWithFormat:@"%@/api/",_server.text]; ;
        NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:link] cachePolicy:0 timeoutInterval:5];
        NSURLResponse* response=nil;
        NSError* error=nil;
        [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if (error) {
            _serverStatus.text=@"Server offline";
            _serverStatus.hidden = false;
            _serverStatus.textColor = [UIColor redColor];
        } else
        {
            _serverStatus.text=@"Server ok";
            _serverStatus.hidden = false;
            _serverStatus.textColor = [UIColor greenColor];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}

-(IBAction)onLogin:(id)sender
{
    _connectionStatus.hidden = true;
    if([TTRSSJSonParser isValidLogin:_username.text password:_password.text server:_server.text])
    {
        [[NSUserDefaults standardUserDefaults] setValue:_server.text forKey:@"server"];
        [[NSUserDefaults standardUserDefaults] setValue:_username.text forKey:@"user"];
        [[NSUserDefaults standardUserDefaults] setValue:_password.text forKey:@"password"];
        [TTRSSConfig initialize];
        (onSuccess)();
    }
    else
    {
        _connectionStatus.text = @"Username and password invalid";
        _connectionStatus.hidden = false;
        _connectionStatus.textColor = [UIColor redColor];
    }

}
// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    _scrollview.contentInset = contentInsets;
    _scrollview.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    CGPoint origin = _activeField.frame.origin;
    origin.y -= _scrollview.contentOffset.y;
    if (!CGRectContainsPoint(aRect, origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, _activeField.frame.origin.y-(aRect.size.height));
        [_scrollview setContentOffset:scrollPoint animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _scrollview.contentInset = contentInsets;
    _scrollview.scrollIndicatorInsets = contentInsets;
    _activeField = nil;
}
@end
