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
        configs[@"user"]      = [[NSUserDefaults standardUserDefaults] stringForKey:@"use"];
    } else {
        configs[@"user"]      = @"";
    }
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"password"]) {
        configs[@"password"]      = [[NSUserDefaults standardUserDefaults] stringForKey:@"password"];
    } else {
        configs[@"password"]      = @"";
    }
}

+(NSString *) getConfigValue:(NSString *) config
{
    return configs[config];
}
@end
