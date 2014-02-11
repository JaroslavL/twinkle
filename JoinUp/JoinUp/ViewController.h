//
//  ViewController.h
//  ChatTestApp
//
//  Created by solid on 06.02.14.
//  Copyright (c) 2014 solid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "XMPPWrapper.h"

@interface ViewController : UIViewController {
    XMPPStream *xmppStream;
    NSString *password;
    
    XMPPWrapper *xmppwrapper;
}
@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtUserPassword;

- (IBAction)btnConnect:(id)sender;
- (IBAction)btnDisconnect:(id)sender;

@end
