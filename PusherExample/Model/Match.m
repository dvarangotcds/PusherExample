//
//  Match.m
//  PusherExample
//
//  Created by Diego Varangot on 10/29/15.
//  Copyright © 2015 Diego Varangot. All rights reserved.
//

#import "Match.h"

@implementation Match

- (Match *)initWithId:(NSString *)matchId team1:(NSString *)team1 team2:(NSString *)team2 enabled:(BOOL)enabled
{
    self = [super init];
    
    self.matchId = matchId;
    self.notificationsEnabled = enabled;
    self.team1 = team1;
    self.team2 = team2;
    self.events = [[NSMutableArray alloc] init];
    
    return self;
}

- (void)addEvent:(MatchEvent *)event
{
    [self.events addObject:event];
}

+ (Match *)matchWithId:(NSString *)matchId
{
    for (Match *match in [Match matchs]) {
        if ([match.matchId isEqualToString:matchId]) {
            return match;
        }
    }
    
    return nil;
}

+ (NSMutableArray *)matchs
{
    return [[NSMutableArray alloc] initWithObjects:[[Match alloc] initWithId:@"1"  team1:@"Uruguay" team2:@"Argentina" enabled:NO],
     [[Match alloc] initWithId:@"2"  team1:@"Bayern Munchen" team2:@"Villa Teresa" enabled:NO],
     [[Match alloc] initWithId:@"3"  team1:@"Barcelona" team2:@"Sala de arriba" enabled:NO],
     [[Match alloc] initWithId:@"4"  team1:@"Uruguay" team2:@"Argentina" enabled:NO], nil];
}

@end
