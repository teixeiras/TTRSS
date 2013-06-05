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
    configs = [NSMutableDictionary new];
    configs[@"server"]      = @"http://rss.fteixeira.org/api/";
    configs[@"user"]        = @"demo";
    configs[@"password"]    = @"demodemo";
}

+(NSString *) getConfigValue:(NSString *) config
{
    return configs[config];
}
@end
