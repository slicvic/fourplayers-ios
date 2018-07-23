//
//  API.h
//  FourPlayers
//
//  Created by victor lantigua on 5/23/14.
//  Copyright (c) 2014 victor lantigua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface API : NSObject
+(void)getScoresWithCallback:(void(^)(NSData *data, NSURLResponse *response, NSError *error))callback;
+(void)submitScore:(int)score playerName:(NSString *)name country:(NSString *)country callback:(void(^)(NSData *data, NSURLResponse *response, NSError *error))callback;
@end
