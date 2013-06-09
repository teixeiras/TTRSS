//
//  TTRSSJSonParser.m
//  TinyRSS
//
//  Created by Filipe Teixeira on 6/4/13.
//  Copyright (c) 2013 Filipe Teixeira. All rights reserved.
//
#import "NSDictionary+UrlEncoding.h"

#import "TTRSSJSonParser.h"
#import "TTRSSConfig.h"

static NSString        * _session_id;
@implementation TTRSSJSonParser
{
    NSMutableData           * _responseData;
    NSMutableDictionary     * _param;
    NSURLConnection         * _connection;
    NSMutableURLRequest     * _request;
    
    int                     tries;
    void(^_onRequestSuccessfull)(NSDictionary *);
    
}
+(id) newWithDictionary:(NSDictionary *) param onRequestSuccessfull: (void(^)(NSDictionary *))onRequestSuccessfull
{
    return [[TTRSSJSonParser alloc] initWithDictionary:param onRequestSuccessfull:onRequestSuccessfull];
}

-(id) initWithDictionary:(NSDictionary *) param onRequestSuccessfull: (void(^)(NSDictionary *))onRequestSuccessfull
{
    if (self = [super init]) {
        tries = 0;
        _onRequestSuccessfull = onRequestSuccessfull;
        _param = [NSMutableDictionary dictionaryWithDictionary:param];
        if (_session_id) {
            _param[@"sid"]=_session_id;
        }
        
        _responseData = [NSMutableData new];
        NSString * urlString = [NSString stringWithFormat:@"%@/api/",[TTRSSConfig getConfigValue:@"server"]];

        NSURL *url = [NSURL URLWithString:urlString];

        _request = [NSMutableURLRequest requestWithURL:url];//asynchronous call
        
        [_request setHTTPMethod:@"POST"];
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_param
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:nil];

        [_request setHTTPBody:jsonData];
        
        [_request setValue:@"*/*" forHTTPHeaderField:@"Accept"];
        
        [_request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        _connection = [[NSURLConnection alloc] initWithRequest:_request delegate:self];

    }
    return self;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [_responseData setLength:0];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_responseData appendData:data];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [NSException exceptionWithName:@"CONNECTION FAILED" reason:@"Request failed" userInfo:@{@"param":_param}];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSDictionary * result = [TTRSSJSonParser parse:_responseData];
    if (result[@"content"] &&
        ![result[@"content"] isKindOfClass:[NSArray class]] &&
        result[@"content"][@"error"] &&
        [result[@"content"][@"error"] isEqualToString:@"NOT_LOGGED_IN"]) {
        
        if (tries == 3) {
            [NSException exceptionWithName:@"COULD NOT LOGON" reason:@"Could not login after NOT_LOGGED_IN" userInfo:@{@"param":_param}];
        }
        
        
        [TTRSSJSonParser newWithDictionary:@{@"op":@"login",@"user":[TTRSSConfig getConfigValue:@"user"],@"password":[TTRSSConfig getConfigValue:@"password"]} onRequestSuccessfull:^(NSDictionary * dic) {
            
             if (dic[@"content"] && dic[@"content"][@"session_id"]) {
                 _session_id = dic[@"content"][@"session_id"];
                 _param[@"sid"] = _session_id;

                 NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_param
                                                                    options:NSJSONWritingPrettyPrinted
                                                                      error:nil];
                 
                 [_request setHTTPBody:jsonData];
                 
                 _connection = [[NSURLConnection alloc] initWithRequest:_request delegate:self];
                 tries ++;
            }

            
        }];

    } else {
        (_onRequestSuccessfull)([TTRSSJSonParser parse:_responseData]);
    }
    
}

+(bool) isValidLogin:(NSString *) user password:(NSString *) password server:(NSString *)server
{
    NSMutableURLRequest     * _request;
    
    NSString * urlString = [NSString stringWithFormat:@"%@/api/",server];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    _request = [NSMutableURLRequest requestWithURL:url];//asynchronous call
    
    [_request setHTTPMethod:@"POST"];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:
                            @{
                                @"op":@"login",
                                @"user":user,
                                @"password":password
                            }
                            options:NSJSONWritingPrettyPrinted
                            error:nil];
    
    [_request setHTTPBody:jsonData];
    
    [_request setValue:@"*/*" forHTTPHeaderField:@"Accept"];
    
    [_request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    NSData *response = [NSURLConnection sendSynchronousRequest:_request returningResponse:&urlResponse error:&requestError];
    if (response == nil) {
        if (requestError != nil) {
            return false;
        }
    }
    if (!response) {
        return false;
    }
    NSDictionary * result = [TTRSSJSonParser parse:response];
    
    if (result[@"content"] &&
       ![result[@"content"] isKindOfClass:[NSArray class]] &&
       result[@"content"][@"error"]) {
        return false;
    }
    return true;


}
+(NSDictionary *) parse:(NSData *) requestResponse
{
    NSError *error = nil;
    id object = [NSJSONSerialization
                 JSONObjectWithData:requestResponse
                 options:0
                 error:&error];
    
    if(error) {
        [NSException raise:@"Invalid request format" format:@"Invalid request format"];
    }
    
    if([object isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *results = object;
        return results;
    }
    else
    {
      [NSException raise:@"Invalid request format" format:@"Invalid request format"];
    }
    return nil;

}
@end
