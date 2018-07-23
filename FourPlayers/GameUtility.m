//
//  GameUtility.m
//  FourPlayers
//
//  Created by victor lantigua on 5/22/14.
//  Copyright (c) 2014 victor lantigua. All rights reserved.
//

#import "GameUtility.h"

@implementation GameUtility

static NSArray *sTeams;
static NSDictionary *sPlayers;

+(void)initialize {
    // Initialize your static variables here...
    // TODO: move sTeams and sPlayers initialization here
}

+(NSArray *)getShuffledTeams
{
    NSArray *teams = [NSArray arrayWithArray:[self getTeams]];
    teams = [self shuffleArray:teams];
    return teams;
}

+(NSArray *)getPlayersForTeam:(NSString *)team
{
    NSArray *players = [[self getAllPlayers] valueForKey:team];
    players = [self shuffleArray:players];
    return players;
}

+(NSArray *)shuffleArray: (NSArray *)array
{
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:array];
    NSUInteger count = [mutableArray count];

    for (NSUInteger i = 0; i < count; ++i) {
        NSUInteger nElements = count - i;
        NSUInteger n = (arc4random() % nElements) + i;
        [mutableArray exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    NSArray *randomArray = [NSArray arrayWithArray:mutableArray];
    return randomArray;
}

+(NSArray *)getTeams
{
    if (sTeams == nil)
    {
        sTeams = [NSArray arrayWithObjects:
                  @"usa",
                  //@"dom",//
                  @"alg",
                  @"arg",
                  @"aus",
                  @"bel",
                  @"bih",
                  @"bra",
                  //@"can",//
                  @"chi",
                  @"civ",
                  @"cmr",
                  @"col",
                  @"crc",
                  @"cro",
                  //@"cub",//
                  @"ecu",
                  @"eng",
                  @"esp",
                  @"fra",
                  @"ger",
                  @"gha",
                  @"gre",
                  @"hon",
                  @"irn",
                  @"ita",
                  @"jpn",
                  @"kor",
                  @"mex",
                  @"ned",
                  @"nga",
                  //@"per",//
                  @"por",
                  @"rus",
                  @"sui",
                  @"uru",
                  nil];
    }
    return sTeams;
}

+(NSDictionary *)getAllPlayers
{
    if (sPlayers == nil)
    {
        sPlayers = @{
                    @"usa": [NSArray arrayWithObjects: @"usa1", @"usa2", @"usa3", @"usa4", @"usa5", @"usa6", @"usa7", nil],
                    @"alg": [NSArray arrayWithObjects: @"alg1", @"alg2", @"alg3", @"alg4", @"alg5", @"alg6", nil],
                    @"civ": [NSArray arrayWithObjects: @"civ1", @"civ2", @"civ3", @"civ4", @"civ5", @"civ6", nil],
                    @"nga": [NSArray arrayWithObjects: @"nga1", @"nga2", @"nga3", @"nga4", @"nga5", @"nga6", nil],
                    @"cmr": [NSArray arrayWithObjects: @"cmr1", @"cmr2", @"cmr3", @"cmr4", @"cmr5", @"cmr6", nil],
                    @"gha": [NSArray arrayWithObjects: @"gha1", @"gha2", @"gha3", @"gha4", @"gha5", @"gha6", nil],
                    @"aus": [NSArray arrayWithObjects: @"aus1", @"aus2", @"aus3", @"aus4", @"aus5", @"aus6", nil],
                    @"jpn": [NSArray arrayWithObjects: @"jpn1", @"jpn2", @"jpn3", @"jpn4", @"jpn5", @"jpn6", nil],
                    @"irn": [NSArray arrayWithObjects: @"irn1", @"irn2", @"irn3", @"irn4", @"irn5", @"irn6", nil],
                    @"kor": [NSArray arrayWithObjects: @"kor1", @"kor2", @"kor3", @"kor4", @"kor5", @"kor6", nil],
                    @"bel": [NSArray arrayWithObjects: @"bel1", @"bel2", @"bel3", @"bel4", @"bel5", @"bel6", nil],
                    @"cro": [NSArray arrayWithObjects: @"cro1", @"cro2", @"cro3", @"cro4", @"cro5", @"cro6", nil],
                    @"fra": [NSArray arrayWithObjects: @"fra1", @"fra2", @"fra3", @"fra4", @"fra5", @"fra6", nil],
                    @"gre": [NSArray arrayWithObjects: @"gre1", @"gre2", @"gre3", @"gre4", @"gre5", @"gre6", nil],
                    @"ned": [NSArray arrayWithObjects: @"ned1", @"ned2", @"ned3", @"ned4", @"ned5", @"ned6", nil],
                    @"rus": [NSArray arrayWithObjects: @"rus1", @"rus2", @"rus3", @"rus4", @"rus5", @"rus6", nil],
                    @"sui": [NSArray arrayWithObjects: @"sui1", @"sui2", @"sui3", @"sui4", @"sui5", @"sui6", nil],
                    @"bih": [NSArray arrayWithObjects: @"bih1", @"bih2", @"bih3", @"bih4", @"bih5", @"bih6", nil],
                    @"eng": [NSArray arrayWithObjects: @"eng1", @"eng2", @"eng3", @"eng4", @"eng5", @"eng6", nil],
                    @"ger": [NSArray arrayWithObjects: @"ger1", @"ger2", @"ger3", @"ger4", @"ger5", @"ger6", nil],
                    @"ita": [NSArray arrayWithObjects: @"ita1", @"ita2", @"ita3", @"ita4", @"ita5", @"ita6", nil],
                    @"por": [NSArray arrayWithObjects: @"por1", @"por2", @"por3", @"por4", @"por5", @"por6", nil],
                    @"esp": [NSArray arrayWithObjects: @"esp1", @"esp2", @"esp3", @"esp4", @"esp5", @"esp6", nil],
                    @"crc": [NSArray arrayWithObjects: @"crc1", @"crc2", @"crc3", @"crc4", @"crc5", nil],
                    @"mex": [NSArray arrayWithObjects: @"mex1", @"mex2", @"mex3", @"mex4", @"mex5", @"mex6", nil],
                    @"hon": [NSArray arrayWithObjects: @"hon1", @"hon2", @"hon3", @"hon4", @"hon5", @"hon6", nil],
                    @"arg": [NSArray arrayWithObjects: @"arg1", @"arg2", @"arg3", @"arg4", @"arg5", @"arg6", nil],
                    @"chi": [NSArray arrayWithObjects: @"chi1", @"chi2", @"chi3", @"chi4", @"chi5", @"chi6", nil],
                    @"ecu": [NSArray arrayWithObjects: @"ecu1", @"ecu2", @"ecu3", @"ecu4", @"ecu5", @"ecu6", nil],
                    @"bra": [NSArray arrayWithObjects: @"bra1", @"bra2", @"bra3", @"bra4", @"bra5", @"bra6", nil],
                    @"col": [NSArray arrayWithObjects: @"col1", @"col2", @"col3", @"col4", @"col5", nil],
                    @"uru": [NSArray arrayWithObjects: @"uru1", @"uru2", @"uru3", @"uru4", @"uru5", nil],
        };
        
    }
    return sPlayers;
}

+(id)alloc {
    [NSException raise:@"Cannot be instantiated!" format:@"Static class 'GameUtility' cannot be instantiated!"];
    return nil;
}

@end
