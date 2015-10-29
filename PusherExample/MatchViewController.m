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
    self.matchName.text = [NSString stringWithFormat:@"%@ - %@", self.match.team1, self.match.team2];
    
}

- (IBAction)generate:(id)sender
{
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.match.events.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"matchCell"];
    
    MatchEvent *currentEvent = (MatchEvent *)[self.match.events objectAtIndex:indexPath.row];
    
    cell.minuto.text = [NSString stringWithFormat:@"min %i", (int)currentEvent.minute];
    cell.eventDescription.text = currentEvent.eventDescription;
    
    return cell;
}

@end
