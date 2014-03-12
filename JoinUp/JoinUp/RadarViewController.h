//
//  RadarViewController.h
//  JoinUp
//
//  Created by solid on 18.02.14.
//  Copyright (c) 2014 Bros Universe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkConnection.h"
#import "UINearUsersTableView.h"
#import "ChatViewController.h"

@interface RadarViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISplitViewControllerDelegate>

@property (nonatomic,strong) NSArray *nearbyUsers;
@property (strong, nonatomic) IBOutlet UINearUsersTableView *tableNearUsers;
@property (nonatomic, retain) ChatViewController *chatViewController;

@end
