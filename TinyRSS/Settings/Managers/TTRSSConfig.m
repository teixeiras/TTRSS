//
//  TTRSSConfig.m
//  TinyRSS
//
//  Created by Filipe Teixeira on 6/4/13.
//  Copyright (c) 2013 Filipe Teixeira. All rights reserved.
//

#import "TTRSSConfig.h"
NSMutableDictionary * configs;

@implementation TTRSSConfig

+(void) initialize
{
    ;
    configs = [NSMutableDictionary new];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"server"]) {
        configs[@"server"]      = [[NSUserDefaults standardUserDefaults] stringForKey:@"server"];
    } else {
        configs[@"server"]      = @"";
    }
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"user"]) {
        configs[@"user"]      = [[NSUserDefaults standardUserDefaults] stringForKey:@"user"];
    } else {
        configs[@"user"]      = @"";
    }
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"password"]) {
        configs[@"password"]      = [[NSUserDefaults standardUserDefaults] stringForKey:@"password"];
    } else {
        configs[@"password"]      = @"";
    }
}

+(bool) validConfig
{
    if ([configs[@"server"] isEqualToString:@""] ||[configs[@"user"] isEqualToString:@""] ||[configs[@"password"] isEqualToString:@""] )
    {
        return false;
    }
    return true;
}
+(NSString *) getConfigValue:(NSString *) config
{
    return configs[config];
}
@end
