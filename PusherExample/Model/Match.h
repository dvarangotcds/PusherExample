//
//  Match.h
//  PusherExample
//
//  Created by Diego Varangot on 10/29/15.
//  Copyright © 2015 Diego Varangot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MatchEvent.h"

@interface Match : NSObject

@property (nonatomic, strong) NSString *matchId;
@property (nonatomic) BOOL notificationsEnabled;
@property (nonatomic, strong) NSString *team1;
@property (nonatomic, strong) NSString *team2;
@property (nonatomic, strong) NSMutableArray *events;

- (Match *)initWithId:(NSString *)matchId team1:(NSString *)team1 team2:(NSString *)team2 enabled:(BOOL)enabled;
- (void)addEvent:(MatchEvent *)event;

+ (Match *)matchWithId:(NSString *)matchId;
+ (NSMutableArray *)matchs;

@end
