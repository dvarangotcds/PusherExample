//
//  EventTableViewCell.h
//  PusherExample
//
//  Created by Diego Varangot on 10/29/15.
//  Copyright © 2015 Diego Varangot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *minuto;
@property (weak, nonatomic) IBOutlet UILabel *eventDescription;
@property (weak, nonatomic) IBOutlet UIImageView *eventImage;

@end
