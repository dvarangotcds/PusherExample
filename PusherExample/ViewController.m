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
@property (nonatomic, strong) NSMutableArray *matchs;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.matchsTableView registerNib:[UINib nibWithNibName:@"MatchTableViewCell" bundle:nil] forCellReuseIdentifier:@"matchCell"];
    [self loadMatches];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadMatches
{
    self.matchs = [Match matchs];
}

#pragma mark - IBAction methods

- (IBAction)generate:(id)sender
{
    NSArray *matchs = @[@"1",@"2",@"3",@"4"];
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

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.matchs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MatchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"matchCell"];
    
    Match *currentMatch = (Match *)[self.matchs objectAtIndex:indexPath.row];
    
    cell.matchName.text = [NSString stringWithFormat:@"%@ - %@", currentMatch.team1, currentMatch.team2];
    [cell.enableNotifications setOn:currentMatch.notificationsEnabled animated:YES];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"events" sender:[self.matchs objectAtIndex:indexPath.row]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(nullable id)sender
{
    if ([segue.destinationViewController isKindOfClass:[MatchViewController class]]) {
        ((MatchViewController *)segue.destinationViewController).match = (Match *)sender;
    }
}

@end
