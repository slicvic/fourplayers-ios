//
//  GameUtility.h
//  FourPlayers
//
//  Created by victor lantigua on 5/22/14.
//  Copyright (c) 2014 victor lantigua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameUtility : NSObject
+(NSArray *)getTeams;
+(NSArray *)getShuffledTeams;
+(NSDictionary *) getAllPlayers;
+(NSMutableArray *) getPlayersForTeam:(NSString *)team;
+(NSArray *)shuffleArray:(NSArray *)array;
@end
