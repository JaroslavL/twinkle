//
//  ViewController.m
//  ChatTestApp
//
//  Created by solid on 06.02.14.
//  Copyright (c) 2014 solid. All rights reserved.
//

#import "ViewController.h"
#import "XMPP.h"

@interface ViewController ()

@end

@implementation ViewController {
    //XMPPStream* xmppstream;
    //NSString *jid;
    //NSString *passwd;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnConnect:(id)sender {
    NSLog(@"connect");
    xmppwrapper = [[XMPPWrapper alloc] initWithUserData:_txtUserName.text andPasswd:_txtUserPassword.text andHostName:@"192.168.1.100"];
    [xmppwrapper connect];
}

- (IBAction)btnDisconnect:(id)sender {
    NSLog(@"Disconnect");
    [xmppwrapper disconnect];
}
@end
