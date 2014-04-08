//
//  FriendsTableViewController.m
//  JoinUp
//
//  Created by solid on 28.03.14.
//  Copyright (c) 2014 Bros Universe. All rights reserved.
//

#import "FriendsTableViewController.h"

@interface FriendsTableViewController ()

@end

@implementation FriendsTableViewController

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
    
    //_myFriends = [[NSMutableArray alloc] initWithObjects:@"1", @"2", @"3", @"4", nil];
    
    counter = 0;
    
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

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [[self fetchedResultController] sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [[self fetchedResultController] sectionForSectionIndexTitle:title atIndex:index];
}

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
    [self.tableView reloadData];
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
        [[[XMPPWrapper sharedInstance] xmppRoster] removeUser:[XMPPJID jidWithString:[tableView cellForRowAtIndexPath:indexPath].textLabel.text]];
        
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
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        User *u = [[User alloc] init];
        [u setJabberID:[[[[self fetchedResultController] objectAtIndexPath:indexPath] jidStr] componentsSeparatedByString:@"@"][0]];
        //[u setImgAvatar:[UIImage imageWithData:[[[self fetchedResultController] objectAtIndexPath:indexPath] photo]]];
        [[segue destinationViewController] setIsCurrentInterlocutor:u];
        NSLog(@"showChat");
    }
}


- (IBAction)deleteFriend:(id)sender {
    
    if ([self.tableView isEditing]) {
        
        // If the tableView is already in edit mode, turn it off. Also change the title of the button to reflect the intended verb (‘Edit’, in this case).
        [self.tableView setEditing:NO animated:YES];
        [self.deleteFriend setTitle:@"Edit" forState:UIControlStateNormal];
    }
    else {
        
        // Turn on edit mode
        [self.tableView setEditing:YES animated:YES];
        [self.deleteFriend setTitle:@"Done" forState:UIControlStateNormal];
        
    }
}
@end
