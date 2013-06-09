//
//  TTRSSLaunchScreenViewController.h
//  TinyRSS
//
//  Created by Filipe Teixeira on 6/8/13.
//  Copyright (c) 2013 Filipe Teixeira. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTRSSLaunchScreenViewController : UIViewController<UITextFieldDelegate>
- (id)initWithBlockOnSuccess:(void(^)()) block;

@end
