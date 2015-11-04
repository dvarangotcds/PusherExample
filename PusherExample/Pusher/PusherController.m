//
//  PusherController.m
//  PusherExample
//
//  Created by Diego Varangot on 10/29/15.
//  Copyright © 2015 Diego Varangot. All rights reserved.
//

#import "PusherController.h"
#import "Match.h"

#define PUSHER_KEY_IDENTIFIER @"82791d16619f14fd3be0"

@interface PusherController ()

@property (nonatomic, strong) PTPusher *client;
@property (nonatomic, assign) BOOL shouldReconnectToPusher;

@end

@implementation PusherController

static NSMutableDictionary * openChannelsPool;
static NSMutableDictionary * subscribedVCPool;

+ (void)initialize
{
    if (!openChannelsPool) {
        openChannelsPool = [NSMutableDictionary dictionary];
    }
    
    if (!subscribedVCPool) {
        subscribedVCPool = [NSMutableDictionary dictionary];
    }
}

+ (void)resetPool
{
    if (openChannelsPool) {
        [openChannelsPool removeAllObjects];
    }
    
    if (subscribedVCPool) {
        [subscribedVCPool removeAllObjects];
    }
}

+ (PusherController *)sharedInstance
{
    static PusherController * instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [PusherController new];
        instance.shouldReconnectToPusher = YES;
    });
    
    if (!instance.client) {
        instance.client = [PTPusher pusherWithKey:PUSHER_KEY_IDENTIFIER
                                         delegate:instance];
        
        instance.client.authorizationURL = [NSURL URLWithString:@""];
    }
    
    if (![[instance.client connection] isConnected]) {
        instance.shouldReconnectToPusher = YES;
        [instance.client connect];
    }
    
    return instance;
}

- (void)subscribeToChannel:(NSString *)channelIdentifier viewController:(UIViewController *)subscriptor
{
    NSLog(PUSHER_KEY_IDENTIFIER);
    
    if (openChannelsPool[channelIdentifier]) {
        //already have a channel for this weev
        PTPusherChannel *channel = openChannelsPool[channel.name];
//        PTPusherPrivateChannel *channel = openChannelsPool[channelIdentifier];
        NSMutableArray *subscribedVCsToChannel = subscribedVCPool[channel.name];
        
        for (UIViewController *vc in subscribedVCsToChannel) {
            if ([vc isEqual:subscriptor]) {
                //already subcribed
                return;
            }
        }
        
        [subscribedVCsToChannel addObject:subscriptor];
        subscribedVCPool[channel.name] = subscribedVCsToChannel;
    } else {
        //don't have a subscription for this channel
        PTPusherChannel *newChannel = [self.client subscribeToChannelNamed:channelIdentifier];
//        PTPusherPrivateChannel *newChannel = [self.client subscribeToPrivateChannelNamed:channelIdentifier];
        openChannelsPool[channelIdentifier] = newChannel;
        subscribedVCPool[newChannel.name] = [[NSMutableArray alloc] initWithObjects:subscriptor, nil];
    }
}

- (void)unsubscribeToChannel:(NSString *)channelIdentifier viewController:(UIViewController *)subscriptor
{
//    PTPusherPrivateChannel *channel = openChannelsPool[channelIdentifier];
    PTPusherChannel *channel = openChannelsPool[channelIdentifier];
    
    if (channel) {
        NSMutableArray *subscriptors = (NSMutableArray *)subscribedVCPool[channel.name];
        
        if (subscriptors.count > 1) {
            [subscriptors removeObject:subscriptor];
            subscribedVCPool[channelIdentifier] = subscriptors;
        } else {
            [channel unsubscribe];
        }
    }
}

#pragma mark - PTPusherConnectionDelegate methods

- (void)pusher:(PTPusher *)pusher connectionDidConnect:(PTPusherConnection *)connection
{
    NSLog(@"Connection Suceeded");
}

- (void)pusher:(PTPusher *)pusher connection:(PTPusherConnection *)connection didDisconnectWithError:(NSError *)error willAttemptReconnect:(BOOL)willAttemptReconnect
{
    if (!self.shouldReconnectToPusher) {
        for (NSString *weevIdentifier in [subscribedVCPool allKeys]) {
            
            for (UIViewController<PusherViewControllerDelegate> *vc in subscribedVCPool[weevIdentifier]) {
                [vc connectionLostWithError:error.localizedDescription];
            }
        }
        
        [openChannelsPool removeAllObjects];
        [subscribedVCPool removeAllObjects];
    }
    
    NSLog(@"Connection was disconnected due to %@", error.userInfo);
}

- (void)pusher:(PTPusher *)pusher connection:(PTPusherConnection *)connection failedWithError:(NSError *)error
{
    NSLog(@"Failed to connect with error: %@", error.userInfo);
}

- (BOOL)pusher:(PTPusher *)pusher connectionWillAutomaticallyReconnect:(PTPusherConnection *)connection afterDelay:(NSTimeInterval)delay
{
    return self.shouldReconnectToPusher;
}

- (void)pusher:(PTPusher *)pusher willAuthorizeChannel:(PTPusherChannel *)channel withRequest:(NSMutableURLRequest *)request
{
    [request setValue:@"cds-development" forHTTPHeaderField:@"auth-token"];
}

- (void)pusher:(PTPusher *)pusher didSubscribeToChannel:(PTPusherChannel *)channel
{
    NSLog(@"Subscribed to channel: %@", channel.name);
    
    [channel bindToEventNamed:@"redcard"
              handleWithBlock:^(PTPusherEvent *channelEvent) {
                  
                  MatchEvent *event = [[MatchEvent alloc] initWithDictionary:channelEvent.data matchId:channel.name eventType:MatchEventTypeRedCard];
                  
                  [Match addEvent:event];
                  [[NSNotificationCenter defaultCenter] postNotificationName:@"newEvent" object:channelEvent.channel];
              }];
    [channel bindToEventNamed:@"yellowcard"
              handleWithBlock:^(PTPusherEvent *channelEvent) {
                  
                  MatchEvent *event = [[MatchEvent alloc] initWithDictionary:channelEvent.data matchId:channel.name eventType:MatchEventTypeYellowCard];
                  
                  [Match addEvent:event];
                  [[NSNotificationCenter defaultCenter] postNotificationName:@"newEvent" object:channelEvent.channel];
              }];
    [channel bindToEventNamed:@"goal"
              handleWithBlock:^(PTPusherEvent *channelEvent) {
                  
                  MatchEvent *event = [[MatchEvent alloc] initWithDictionary:channelEvent.data matchId:channel.name eventType:MatchEventTypeGoal];
                  
                  [Match addEvent:event];
                  [[NSNotificationCenter defaultCenter] postNotificationName:@"newEvent" object:channelEvent.channel];
              }];
    [channel bindToEventNamed:@"injury"
              handleWithBlock:^(PTPusherEvent *channelEvent) {
                  
                  MatchEvent *event = [[MatchEvent alloc] initWithDictionary:channelEvent.data matchId:channel.name eventType:MatchEventTypeInjury];
                  
                  [Match addEvent:event];
                  [[NSNotificationCenter defaultCenter] postNotificationName:@"newEvent" object:channelEvent.channel];
              }];
}

- (void)pusher:(PTPusher *)pusher didUnsubscribeFromChannel:(PTPusherChannel *)channel
{
    for (NSString *weevIdentifier in [openChannelsPool allKeys]) {
        
//        PTPusherPrivateChannel *auxChannel = openChannelsPool[weevIdentifier];
        PTPusherChannel *auxChannel = openChannelsPool[weevIdentifier];

        if ([channel.name isEqualToString:auxChannel.name]) {
            [openChannelsPool removeObjectForKey:weevIdentifier];
        }
    }
    
    if ([openChannelsPool allKeys].count == 0) {
        self.shouldReconnectToPusher = NO;
        [self.client disconnect];
        [subscribedVCPool removeAllObjects];
    }
}

- (void)pusher:(PTPusher *)pusher didFailToSubscribeToChannel:(PTPusherChannel *)channel withError:(NSError *)error
{
    for (NSString *weevIdentifier in [openChannelsPool allKeys]) {
//        PTPusherPrivateChannel *auxChannel = openChannelsPool[weevIdentifier];
        PTPusherChannel *auxChannel = openChannelsPool[weevIdentifier];
        
        if ([channel.name isEqualToString:auxChannel.name]) {
            [openChannelsPool removeObjectForKey:weevIdentifier];
        }
    }
    
    NSLog(@"Failed to subscribe to channel: %@", channel.name);
    NSLog(@"error: %@", error.userInfo);
}

- (void)pusher:(PTPusher *)pusher didReceiveErrorEvent:(PTPusherErrorEvent *)errorEvent
{
    NSLog(@"Event error: %@", errorEvent.message);
}
@end
