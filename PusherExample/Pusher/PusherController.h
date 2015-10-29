//
//  PusherController.h
//  PusherExample
//
//  Created by Diego Varangot on 10/29/15.
//  Copyright © 2015 Diego Varangot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Pusher/Pusher.h>
#import <UIKit/UIKit.h>

@interface PusherController : NSObject <PTPusherDelegate>

+ (PusherController *)sharedInstance;

- (void)subscribeToChannel:(NSString *)channelIdentifier viewController:(UIViewController *)subscriptor;
- (void)unsubscribeToChannel:(NSString *)channelIdentifier viewController:(UIViewController *)subscriptor;

@end
