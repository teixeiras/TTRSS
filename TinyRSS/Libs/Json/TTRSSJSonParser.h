//
//  TTRSSJSonParser.h
//  TinyRSS
//
//  Created by Filipe Teixeira on 6/4/13.
//  Copyright (c) 2013 Filipe Teixeira. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTRSSJSonParser : NSObject<NSURLConnectionDelegate>

+(id) newWithDictionary:(NSDictionary *) param onRequestSuccessfull: (void(^)(NSDictionary *))onRequestSuccessfull;


-(id) initWithDictionary:(NSDictionary *) param onRequestSuccessfull: (void(^)(NSDictionary *))onRequestSuccessfull;
@end
