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

+(bool) isValidLogin:(NSString *) user password:(NSString *) password server:(NSString *)server;

-(id) initWithDictionary:(NSDictionary *) param onRequestSuccessfull: (void(^)(NSDictionary *))onRequestSuccessfull;
@end
