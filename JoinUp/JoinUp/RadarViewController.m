//
//  RadarViewController.m
//  JoinUp
//
//  Created by solid on 18.02.14.
//  Copyright (c) 2014 Bros Universe. All rights reserved.
//

#import "RadarViewController.h"

@interface RadarViewController ()

@end

@implementation RadarViewController

@synthesize nearbyUsers;
@synthesize chatViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //TODO: get near users every time
    NetworkConnection *connection = [[NetworkConnection alloc] init];
    nearbyUsers = [connection getNearbyUsers];
    
    [_tableNearUsers setDelegate:self];
    [_tableNearUsers setDataSource:self];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [nearbyUsers count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UIUserCellTableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"NewCurrent" object:selectedCell.userLogin];
    //self.chatViewController.isCurrentInterlocutor = selectedCell.userLogin;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UIUserCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
	User *user = [self.nearbyUsers objectAtIndex:indexPath.row];
    cell.userLogin = user.jabberID;
	cell.userNameLabel.text = user.name;
	cell.distanceLabel.text = user.distance;
    //cell.userAvatarImageView.image = [user imgAvatar];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showChat"]) {
        NSIndexPath *indexPath = [self.tableNearUsers indexPathForSelectedRow];
        NSDate *object = nearbyUsers[indexPath.row];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NewActiveChat" object:object];
        [[segue destinationViewController] setIsCurrentInterlocutor:object];
    }
}

@end
