//
//  API.m
//  FourPlayers
//
//  Created by victor lantigua on 5/23/14.
//  Copyright (c) 2014 victor lantigua. All rights reserved.
//

#import "API.h"

@implementation API

static NSString *baseUrl = @"http://www.whosgotga.me/api_fourplayers.php?secret=123456";

+(void)getScoresWithCallback:(void(^)(NSData *data, NSURLResponse *response, NSError *error))callback
{
    NSURL *url = [NSURL URLWithString:baseUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:callback];
    [task resume];
}

+(void)submitScore:(int)score playerName:(NSString *)name country:(NSString *)country callback:(void(^)(NSData *data, NSURLResponse *response, NSError *error))callback
{
    NSURL *url = [NSURL URLWithString:baseUrl];
    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSString *params = [NSString stringWithFormat:@"name=%@&country=%@&score=%d", name, country, score];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:callback];
    [task resume];
}

@end
