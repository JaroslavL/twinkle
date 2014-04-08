//
//  FriendsViewController.h
//  JoinUp
//
//  Created by solid on 04.04.14.
//  Copyright (c) 2014 Bros Universe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "XMPPWrapper.h"
#import "ChatViewController.h"

@interface FriendsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>
{
    NSFetchedResultsController *fetchedResultController;
}

@property (weak, nonatomic) IBOutlet UITableView *friendsTableView;
@property (weak, nonatomic) IBOutlet UITableView *friendshipRequestTable;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControll;
@property (nonatomic, strong) NSMutableArray *usersWhoesSendFriendshipRequest;

@property (weak, nonatomic) IBOutlet UIButton *deleteFriend;

- (IBAction)deleteFriend:(id)sender;

- (IBAction)segmentControllSwitching:(id)sender;

@end
