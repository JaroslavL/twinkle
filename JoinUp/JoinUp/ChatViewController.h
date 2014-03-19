//
//  ChatViewController.h
//  JoinUp
//
//  Created by solid on 11.02.14.
//  Copyright (c) 2014 Bros Universe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPWrapper.h"
#import "UIBubbleTableView.h"
#import "UIBubbleTableViewDataSource.h"
#import "NSBubbleData.h"
#import "User.h"
#import "NetworkConnection.h"
#import "Profile.h"
#import "ManagerMessages.h"

@interface ChatViewController : UIViewController <UIBubbleTableViewDataSource, /*XMPPWrapperDelegate,*/ UITextFieldDelegate, UISplitViewControllerDelegate> {
    XMPPWrapper *xmppwrapper;
    Profile *profile;
    ManagerMessages *managerMessages;
}

@property (readwrite, nonatomic) XMPPWrapper* xmppwrapper;
@property (weak, nonatomic) IBOutlet UITextField *txtMessage;
@property (strong, nonatomic) User *isCurrentInterlocutor;
@property (readwrite, nonatomic) Profile *profile;
@property (readwrite, nonatomic) ManagerMessages *managerMessages;

- (IBAction)btnDisconnect:(id)sender;
- (IBAction)btnSendMessage:(id)sender;

- (void)sendMessage:(NSString *)msgContent;
- (void)receiveMessage:(NSNotification *)notification;
- (void)setIsCurrentInterlocutor:(id)newInterlocutor;

- (void)showHistoryMessage: (NSArray *)messages;

@end
