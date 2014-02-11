//
//  XMPPWrapper.m
//  ChatTestApp
//
//  Created by solid on 10.02.14.
//  Copyright (c) 2014 solid. All rights reserved.
//

#import "XMPPWrapper.h"

@implementation XMPPWrapper

@synthesize REGISTER;

- (id)initWithUserData: (NSString *)login andPasswd: (NSString *)password andHostName: (NSString *)hostname {
    if (self = [super init]) {
        jid = login;
        passwd = password;
        hostName = hostname;
        REGISTER = NO;
    }
    return self;
}

- (void)setupStream {
    xmppStream = [[XMPPStream alloc] init];
    [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
}
- (void)goOnline {
    XMPPPresence *presence= [XMPPPresence presence];
    [xmppStream sendElement:presence];
}
- (void)goOffline {
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"]; 
    [xmppStream sendElement:presence];
}

- (BOOL)connect {
    [self setupStream];
    
    if (![xmppStream isDisconnected]) {
        return YES;
    }
    
    if (jid == nil || passwd == nil) {
        return NO;
    }
    
    [xmppStream setMyJID:[XMPPJID jidWithString:jid]];
    [xmppStream setHostName:hostName];
    
    NSError *error = nil;
    if (![xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[NSString stringWithFormat:@"Can't connect to server %@", [error localizedDescription]]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        
        return NO;
    }
    
    return YES;
}

- (void) disconnect {
    [self goOffline];
    [xmppStream disconnect];
}

- (void) xmppStreamDidConnect:(XMPPStream *)sender
{
    if ([xmppStream authenticateWithPassword:passwd error:NULL]) {
        [self goOnline];
    }
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:
(NSXMLElement *)error;
{
    if ([self REGISTER]) {
        if(![xmppStream registerWithPassword:passwd error:nil])
        {
            NSLog(@"Error registering");
            [self disconnect];
        }
    } else {
        NSLog(@"You are not registr");
        [self disconnect];
    }
    
}
- (void)xmppStreamDidRegister:(XMPPStream *)sender{
    
    NSLog(@"I'm in register method");
}

- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement
                                                        *)error{
    NSLog(@"Sorry the registration is failed");
    
}

@end
