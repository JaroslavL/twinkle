//
//  TabBarController.h
//  JoinUp
//
//  Created by solid on 17.02.14.
//  Copyright (c) 2014 Bros Universe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatViewController.h"
#import "ProfileViewController.h"
#import "SettingsViewController.h"
#import "RadarViewController.h"
#import "ActiveChatsTableViewController.h"
#import "ManagerMessages.h"

@interface TabBarController : UITabBarController

@property BOOL chatIsActive;
@property int countMessage;

- (void) didGetNewMessageNotification: (NSNotification *)notification;
- (void) didGetMessageReadingNotification: (NSNotification *)notification;
- (void) didChatDeallocNotification;
- (void) didChatAllocNotification;
- (void) didAnotherInterlocatorNotification;

@end
