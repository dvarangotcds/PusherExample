//
//  MatchEvent.h
//  PusherExample
//
//  Created by Diego Varangot on 10/29/15.
//  Copyright © 2015 Diego Varangot. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    MatchEventTypeGoal,
    MatchEventTypeRedCard,
    MatchEventTypeYellowCard,
    MatchEventTypeInjury
} MatchEventType;

@interface MatchEvent : NSObject

@property (nonatomic) NSInteger team;
@property (nonatomic) NSInteger minute;
@property (nonatomic, strong) NSString *eventDescription;
@property (nonatomic, strong) NSString *matchId;
@property (nonatomic) MatchEventType eventType;

- (MatchEvent *)initWithDictionary:(NSDictionary *)dictionary matchId:(NSString *)matchId eventType:(MatchEventType)eventType;

@end
