//
//  FriendsTableViewController.h
//  JoinUp
//
//  Created by solid on 28.03.14.
//  Copyright (c) 2014 Bros Universe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPWrapper.h"
#import "ChatViewController.h"

@interface FriendsTableViewController : UITableViewController <NSFetchedResultsControllerDelegate, UISplitViewControllerDelegate>
{
    NSFetchedResultsController *fetchedResultController;
    NSUInteger counter;
}

@property (nonatomic, strong) NSMutableArray *myFriends;
@property (weak, nonatomic) IBOutlet UIButton *deleteFriend;

- (IBAction)deleteFriend:(id)sender;

@end
