//
//  MatchTableViewCell.h
//  PusherExample
//
//  Created by Diego Varangot on 10/29/15.
//  Copyright © 2015 Diego Varangot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MatchTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *matchName;
@property (weak, nonatomic) IBOutlet UISwitch *enableNotifications;

@end
