//
//  ActiveChatsTableViewController.m
//  JoinUp
//
//  Created by solid on 24.02.14.
//  Copyright (c) 2014 Bros Universe. All rights reserved.
//

#import "ActiveChatsTableViewController.h"

@interface ActiveChatsTableViewController ()

@end

@implementation ActiveChatsTableViewController

@synthesize chatViewController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _activeChats = [[NSMutableArray alloc] init];
    _managerMessages = [ManagerMessages sharedInstance];
    
    if ([[_managerMessages UsersWhosemMessagesaArenNotRead] count]) {
        [_activeChats addObjectsFromArray:[NetworkConnection getProfiles:[_managerMessages UsersWhosemMessagesaArenNotRead]]];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addActiveChat:)
                                                 name:@"NewActiveChat"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addActiveChat:)
                                                 name:@"AnotherInterlocator"
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_activeChats count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UserCell";
    UIUserCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [[cell userNameLabel] setText:[_activeChats[indexPath.row] name]];
    [[cell userAvatarImageView] setImage:[_activeChats[indexPath.row] imgAvatar]];
    
    if ([_activeChats[indexPath.row] countMessages]) {
        
        [cell setBadgeTextColor:[UIColor whiteColor]];
        [cell setBadgeColor:[UIColor redColor]];
        [cell setBadgeString:[NSString stringWithFormat:@"%d", [_activeChats[indexPath.row] countMessages]]];
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIUserCellTableViewCell *cell = (UIUserCellTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    [cell setBadgeTextColor:nil];
    [cell setBadgeString:nil];
    [[self tableView] reloadData];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"showChat"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        [[segue destinationViewController] setIsCurrentInterlocutor:[[User alloc] initWithUserData:_activeChats[indexPath.row]]];
        [_activeChats[indexPath.row] setCountMessages:0];
    }
    
}

- (void)addActiveChat:(NSNotification *)notification {
    
    BOOL add = YES;
    
    for (User *u in _activeChats) {
        if ([[u jabberID] isEqualToString:[[notification object] jabberID]]) {
            add = NO;
            if ([[notification name] isEqualToString:@"AnotherInterlocator"]) {
                u.countMessages++;
            }
            [[self tableView] reloadData];
            break;
        }
    }
    
    if (add) {
        
        [_activeChats addObject:[notification object]];
        if ([[notification name] isEqualToString:@"AnotherInterlocator"]) {
            [[_activeChats lastObject] setCountMessages:1];
        }
        
        [[self tableView] reloadData];
    }
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
