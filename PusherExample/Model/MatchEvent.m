//
//  MatchEvent.m
//  PusherExample
//
//  Created by Diego Varangot on 10/29/15.
//  Copyright © 2015 Diego Varangot. All rights reserved.
//

#import "MatchEvent.h"

@implementation MatchEvent

- (MatchEvent *)initWithDictionary:(NSDictionary *)dictionary matchId:(NSString *)matchId eventType:(MatchEventType)eventType{
    self = [super init];
    
    if (self) {
        self.matchId = matchId;
        self.eventType = eventType;
        self.minute = [dictionary[@"eventTime"] integerValue];
        self.eventDescription = dictionary[@"eventDescription"];
        self.team = [dictionary[@"eventTeam"] integerValue];
    }
    
    return self;
}

+ (NSString *)stringFromEventType:(MatchEventType)eventType
{
    switch (eventType) {
        case MatchEventTypeGoal:
            return @"goal";
        case MatchEventTypeInjury:
            return @"injury";
        case MatchEventTypeRedCard:
            return @"red card";
        case MatchEventTypeYellowCard:
            return @"yellow card";
        default:
            return @"";
    }
}

@end
