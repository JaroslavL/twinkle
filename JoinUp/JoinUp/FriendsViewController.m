//
//  FriendsViewController.m
//  JoinUp
//
//  Created by solid on 04.04.14.
//  Copyright (c) 2014 Bros Universe. All rights reserved.
//

#import "FriendsViewController.h"

@interface FriendsViewController ()

@end

@implementation FriendsViewController

@synthesize friendsTableView = _friendsTableView;
@synthesize friendshipRequestTable = _friendshipRequestTable;
@synthesize usersWhoesSendFriendshipRequest = _usersWhoesSendFriendshipRequest;

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
    
    _friendsTableView.delegate = self;
    _friendsTableView.dataSource = self;
    
    [_segmentControll addTarget:self action:@selector(segmentControllSwitching:) forControlEvents:UIControlEventValueChanged];
    [_segmentControll setSelectedSegmentIndex:0];
    
    [_friendshipRequestTable setHidden:YES];
    
    _usersWhoesSendFriendshipRequest = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(friendshipRequest:) name:@"FriendshipRequest" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return [[[self fetchedResultController] sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    
    if ([[fetchedResultController sections] count]) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[[self fetchedResultController] sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"Cell"];
	}
    
    XMPPUserCoreDataStorageObject *managedObject = [[self fetchedResultController] objectAtIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.textLabel.text = [managedObject.displayName componentsSeparatedByString:@"@"][0];
    cell.imageView.image = managedObject.photo;
    
    return cell;
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)sectionIndex
{
    if ([[fetchedResultController sections] count]) {
        
        id <NSFetchedResultsSectionInfo> sectionInfo = [[[self fetchedResultController] sections] objectAtIndex:sectionIndex];
        
        int section = [sectionInfo.name intValue];
        
        switch (section) {
            case 0:
                return @"Available";
                break;
            case 1:
                return @"Away";
                break;
                
            default:
                return @"Offline";
                break;
        }
    } else
        return nil;
}

/*- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    NSMutableArray *sectionTitels = [[NSMutableArray alloc] init];
    
    for (id item in [[self fetchedResultController] sectionIndexTitles]) {
        
        if ([item isEqualToString:@"0"]) {
            NSLog(@"section name: Online");
            [sectionTitels addObject:@"Online"];
            
        } else if ([item isEqualToString:@"1"]) {
                NSLog(@"section name: Away");
            [sectionTitels addObject:@"Away"];
        } else {
            NSLog(@"section name: Offline");
            [sectionTitels addObject:@"Offline"];
        }
        
    }
    
    return sectionTitels;
}*/

/*- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [[self fetchedResultController] sectionForSectionIndexTitle:title atIndex:index];
}*/

- (NSFetchedResultsController *)fetchedResultController {
    
    if (fetchedResultController == nil) {
        
        NSManagedObjectContext *moc = [[[XMPPWrapper sharedInstance] xmppRosterStorage] mainThreadManagedObjectContext];
        
        
		
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPUserCoreDataStorageObject"
		                                          inManagedObjectContext:moc];
		
		NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"sectionNum" ascending:YES];
		NSSortDescriptor *sd2 = [[NSSortDescriptor alloc] initWithKey:@"displayName" ascending:YES];
		
		NSArray *sortDescriptors = [NSArray arrayWithObjects:sd1, sd2, nil];
		
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		[fetchRequest setEntity:entity];
		[fetchRequest setSortDescriptors:sortDescriptors];
		[fetchRequest setFetchBatchSize:10];
		
		fetchedResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                      managedObjectContext:moc
                                                                        sectionNameKeyPath:@"sectionNum"
                                                                                 cacheName:nil];
		[fetchedResultController setDelegate:self];
        
        NSError *error = nil;
		if (![fetchedResultController performFetch:&error])
		{
            NSLog(@"Error: %@", error);
		}
    }
    
    return fetchedResultController;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.friendsTableView reloadData];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [[[XMPPWrapper sharedInstance] xmppRoster] removeUser:[[[self fetchedResultController] objectAtIndexPath:indexPath] jid]];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"showChat"]) {
        NSIndexPath *indexPath = [self.friendsTableView indexPathForSelectedRow];
        User *u = [[User alloc] init];
        [u setJabberID:[[[[self fetchedResultController] objectAtIndexPath:indexPath] jidStr] componentsSeparatedByString:@"@"][0]];
        //[u setImgAvatar:[UIImage imageWithData:[[[self fetchedResultController] objectAtIndexPath:indexPath] photo]]];
        [[segue destinationViewController] setIsCurrentInterlocutor:u];
        NSLog(@"showChat");
    }
}


- (IBAction)deleteFriend:(id)sender {
    
    if ([self.friendsTableView isEditing]) {
        
        // If the tableView is already in edit mode, turn it off. Also change the title of the button to reflect the intended verb (‘Edit’, in this case).
        [self.friendsTableView setEditing:NO animated:YES];
        [self.deleteFriend setTitle:@"Edit" forState:UIControlStateNormal];
    }
    else {
        
        // Turn on edit mode
        [self.friendsTableView setEditing:YES animated:YES];
        [self.deleteFriend setTitle:@"Done" forState:UIControlStateNormal];
        
    }
}

- (IBAction)segmentControllSwitching:(id)sender {
    
    switch (_segmentControll.selectedSegmentIndex) {
        case 0:
            NSLog(@"Show Friends");
            [_friendsTableView setHidden:NO];
            [_friendshipRequestTable setHidden:YES];
            break;
        case 1:
            NSLog(@"Show Friendship request");
            [_friendsTableView setHidden:YES];
            [_friendshipRequestTable setHidden:NO];
            break;
            
        default:
            break;
    }
}

- (void)friendshipRequest: (NSNotification *)notification {
    NSLog(@"Friendship request");
    
    for (XMPPJID *item in _usersWhoesSendFriendshipRequest) {
        if ([item isEqualToJID:[[notification object] from]]) {
            return;
        }
    }
    
    [_usersWhoesSendFriendshipRequest addObject:[[notification object] from]];
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
