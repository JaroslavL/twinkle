//
//  ActiveChatsTableViewController.h
//  JoinUp
//
//  Created by solid on 24.02.14.
//  Copyright (c) 2014 Bros Universe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "UIUserCellTableViewCell.h"
#import "ChatViewController.h"

@interface ActiveChatsTableViewController : UITableViewController <UISplitViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *activeChats;
@property (nonatomic, retain) ChatViewController *chatViewController;
@property (readwrite, nonatomic) ManagerMessages *managerMessages;

- (void)addActiveChat:(NSNotification *)notification;

@end
