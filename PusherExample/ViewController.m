//
//  ViewController.m
//  PusherExample
//
//  Created by Diego Varangot on 10/29/15.
//  Copyright © 2015 Diego Varangot. All rights reserved.
//

#import "ViewController.h"
#import "MatchTableViewCell.h"
#import "Match.h"
#import <AFNetworking/AFHTTPRequestOperation.h>
#import "MatchViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *matchsTableView;
@property (weak, nonatomic) IBOutlet UILabel *latestEvent;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.matchsTableView registerNib:[UINib nibWithNibName:@"MatchTableViewCell" bundle:nil] forCellReuseIdentifier:@"matchCell"];
    
    __weak ViewController *wself = self;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"newEvent"
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification * _Nonnull note) {
                                                      Match *match = [Match matchWithId:(NSString *)note.object];
                                                      MatchEvent *event = match.events.lastObject;
                                                      wself.latestEvent.text = [NSString stringWithFormat:@"Match: %@ - %@, min %i", event.matchId, event.eventDescription, (int)event.minute];
                                                  }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction methods

- (IBAction)generate:(id)sender
{
    NSArray *matchs = @[@"M1",@"M2",@"M3",@"M4"];
    NSArray *events = @[@"goal",@"redcard",@"yellowcard",@"injury"];
    NSArray *descriptions = @[@"Torres",@"\"perro\" Zanetti",@"Cavani",@"Cacha",@"Julio Rios",@"Collazo",@"J Olivera",@"el otro",@"Luis Miguel",@"el 9"];
    NSDictionary *eventInfo = @{
                                @"matchId":[matchs objectAtIndex:arc4random() % [matchs count]],
                                @"eventName":[events objectAtIndex:arc4random() % [events count]],
                                @"eventDescription":[descriptions objectAtIndex:arc4random() % [descriptions count]],
                                @"eventTime":[NSString stringWithFormat:@"%i", arc4random() % 90]
                                };
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"192.168.10.86:3000/event"]
                                                                cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                            timeoutInterval:60];
    
    NSMutableDictionary *HTTPHeaders = [NSMutableDictionary dictionary];
    
    HTTPHeaders[@"Accept"] = @"application/json";
    
    request.allHTTPHeaderFields = HTTPHeaders;
    request.HTTPMethod = @"POST";
    
    if (eventInfo) {
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:eventInfo options:kNilOptions error:&error];
        
        NSAssert(error == nil, @"Failed to serialize JSON object");
        
        if (!error) {
            request.HTTPBody = data;
        }
    }
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        ;
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        ;
    }];
    
    [op start];
}

- (IBAction)resetMatches:(id)sender
{
    for (Match *match in [Match matchs]) {
        [match.events removeAllObjects];
    }
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [Match matchs].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MatchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"matchCell"];
    
    Match *currentMatch = (Match *)[[Match matchs] objectAtIndex:indexPath.row];
    
    cell.matchName.text = [NSString stringWithFormat:@"%@ - %@", currentMatch.team1, currentMatch.team2];
    [cell.enableNotifications setOn:currentMatch.notificationsEnabled animated:YES];
    cell.enableNotifications.tag = indexPath.row;
    [cell.enableNotifications addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"events" sender:[[Match matchs] objectAtIndex:indexPath.row]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(nullable id)sender
{
    if ([segue.destinationViewController isKindOfClass:[MatchViewController class]]) {
        ((MatchViewController *)segue.destinationViewController).matchId = ((Match *)sender).matchId;
    }
}

- (IBAction)switchChanged:(UISwitch *)sender
{
    if (!sender.isOn) {
        [[PusherController sharedInstance] unsubscribeToChannel:((Match *)[[Match matchs] objectAtIndex:sender.tag]).matchId
                                                 viewController:self];
    } else {
        [[PusherController sharedInstance] subscribeToChannel:((Match *)[[Match matchs] objectAtIndex:sender.tag]).matchId
                                               viewController:self];
    }
}

#pragma mark - PusherViewControllerDelegate

- (void)connectionLostWithError:(NSString *)errorMessage
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sorry!"
                                                                   message:errorMessage
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

@end
