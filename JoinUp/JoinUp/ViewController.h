//
//  ViewController.h
//  ChatTestApp
//
//  Created by solid on 06.02.14.
//  Copyright (c) 2014 solid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ChatViewController.h"
#import "RegistrationViewController.h"
#import "XMPPWrapper.h"
#import "NSString+hash.h"
#import "Profile.h"
#import "ManagerMessages.h"

@interface ViewController : UIViewController {
    
    XMPPStream *xmppStream;
    NSString *password;
    
    XMPPWrapper *xmppwrapper;
    
    Profile *profile;
    
    ManagerMessages *managerMessage;
    
}
@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtUserPassword;

@property (retain, nonatomic) NSURLConnection *connection;
@property (retain, nonatomic) NSMutableData *receiveData;

- (IBAction)btnConnect:(id)sender;
- (IBAction)btnRegistration:(id)sender;

@end
