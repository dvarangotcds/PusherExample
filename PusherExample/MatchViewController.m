//
//  MatchViewController.m
//  PusherExample
//
//  Created by Diego Varangot on 10/29/15.
//  Copyright © 2015 Diego Varangot. All rights reserved.
//

#import "MatchViewController.h"
#import "EventTableViewCell.h"
#import "MatchEvent.h"

@interface MatchViewController ()

@property (weak, nonatomic) IBOutlet UILabel *matchName;
@property (weak, nonatomic) IBOutlet UITableView *eventsTableView;

@end

@implementation MatchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.matchName.text = [NSString stringWithFormat:@"%@ - %@", [Match matchWithId:self.matchId].team1, [Match matchWithId:self.matchId].team2];
    
    __weak MatchViewController *wself = self;
    
    [self.eventsTableView registerNib:[UINib nibWithNibName:@"EventTableViewCell"
                                                      bundle:nil]
               forCellReuseIdentifier:@"eventCell"];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"newEvent"
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification * _Nonnull note) {
                                                      if ([(NSString *)note.object isEqualToString:wself.matchId]) {
                                                          [wself.eventsTableView reloadData];
                                                      }
                                                  }];
}


- (IBAction)generate:(id)sender
{
    
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [Match matchWithId:self.matchId].events.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eventCell"];
    
    MatchEvent *currentEvent = (MatchEvent *)[[Match matchWithId:self.matchId].events objectAtIndex:indexPath.row];
    
    cell.minute.text = [NSString stringWithFormat:@"min %i", (int)currentEvent.minute];
    cell.eventDescription.text = currentEvent.eventDescription;
    
    if (currentEvent.eventType == MatchEventTypeGoal) {
        [cell.eventImage setImage:[UIImage imageNamed:@"goal"]];        
    } else if (currentEvent.eventType == MatchEventTypeRedCard) {
        [cell.eventImage setImage:[UIImage imageNamed:@"redcard"]];
    } else if (currentEvent.eventType == MatchEventTypeYellowCard) {
        [cell.eventImage setImage:[UIImage imageNamed:@"ywllowcard"]];
    } else if (currentEvent.eventType == MatchEventTypeInjury) {
        [cell.eventImage setImage:[UIImage imageNamed:@"Injury"]];
    }
    
    return cell;
}

@end
