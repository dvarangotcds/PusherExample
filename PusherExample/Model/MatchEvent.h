//
//  MatchEvent.h
//  PusherExample
//
//  Created by Diego Varangot on 10/29/15.
//  Copyright © 2015 Diego Varangot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MatchEvent : NSObject

@property (nonatomic) NSInteger team;
@property (nonatomic) NSInteger minute;
@property (nonatomic, strong) NSString *eventDescription;

- (MatchEvent *)initWithDictionary:(NSDictionary *)dictionary;

@end
