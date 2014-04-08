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
@synthesize xmppStream;
@synthesize xmppRoster;
@synthesize xmppRosterStorage;
@synthesize xmppvCardAvatarModule;
@synthesize xmppvCardTempModule;
@synthesize xmppCapabilities;
@synthesize xmppCapabilitiesStorage;

static XMPPWrapper* _sharedInstance;

+ (XMPPWrapper *)sharedInstance {
    @synchronized(self) {
        if (!_sharedInstance) {
            _sharedInstance = [[XMPPWrapper alloc] init];
        }
    }
    return _sharedInstance;
}

- (id)initWithUserData: (NSString *)login andPasswd: (NSString *)password andHostName: (NSString *)hostname {
    if (self = [super init]) {
        jid = login;
        passwd = password;
        hostName = hostname;
        REGISTER = NO;
        
        _sharedInstance = self;
    }
    return _sharedInstance;
}

- (void)initMessageArchiving {
    
    XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingStorage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
    XMPPMessageArchiving *xmppMessageArchivingModule = [[XMPPMessageArchiving alloc]
                                                        initWithMessageArchivingStorage:xmppMessageArchivingStorage];
    
    [xmppMessageArchivingModule activate:xmppStream];
    [xmppMessageArchivingModule  addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (void)initRoster {
    
     xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
     xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:xmppRosterStorage];
    xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
     xmppRoster.autoFetchRoster = true;
     [xmppRoster activate:xmppStream];
     [xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
}

- (void)initvCard {
    xmppvCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
    xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:xmppvCardStorage];
    xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:xmppvCardTempModule];
    [xmppvCardTempModule activate:xmppStream];
    [xmppvCardAvatarModule activate:xmppStream];
}

- (void)setupStream {
    xmppStream = [[XMPPStream alloc] init];
    [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    xmppStream.enableBackgroundingOnSocket = YES;
}
- (void)goOnline {
    XMPPPresence *presence= [XMPPPresence presence];
    [xmppStream sendElement:presence];
     /*online/unavailable/away/busy/invisible*/
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
    
    // init storage message on server
    
    [self initMessageArchiving];
    [self initRoster];
    [self initvCard];
    
    NSError *error = nil;
    if (![xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
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
    [NetworkConnection sendOfflineStatus];
}

- (void) sendMessage: (NSXMLElement *)message {
    [xmppStream sendElement:message];
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewMessage" object:message];
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq {
    
    return YES;
}

- (void)xmppStream: (XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence {
    //NSLog(@"%@%@", @"didReceivePresence: ", [presence fromStr]);
}
- (void) xmppStreamDidConnect:(XMPPStream *)sender
{
    if ([xmppStream authenticateWithPassword:passwd error:NULL]) {
    }
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    [self goOnline];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:
(NSXMLElement *)error;
{
    if ([self REGISTER]) {
        if(![xmppStream registerWithPassword:passwd error:nil])
        {
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"Error"
                                      message:[NSString stringWithFormat:@"You are not register %@", nil]
                                      delegate:nil
                                      cancelButtonTitle:@"Ok"
                                      otherButtonTitles:nil];
            [alertView show];
            [self disconnect];
        }
    } else {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:[NSString stringWithFormat:@"You are not register %@", nil]
                                  delegate:nil
                                  cancelButtonTitle:@"Ok"
                                  otherButtonTitles:nil];
        [alertView show];
        [self disconnect];
    }
    
}
- (void)xmppStreamDidRegister:(XMPPStream *)sender{
    
    NSLog(@"I'm in register method");
}

- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement
                                                        *)error{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:[NSString stringWithFormat:@"Sorry the registration is failed %@", nil]
                              delegate:nil
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil];
    [alertView show];
}

- (NSArray *)loadArchiveMessage: (NSString *)withJID i:(NSString *)i
{
    
    XMPPMessageArchivingCoreDataStorage *storage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
    NSManagedObjectContext *moc = [storage mainThreadManagedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject"
                                                         inManagedObjectContext:moc];
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    
    NSString *predicateFrmt = @"bareJidStr like %@ AND streamBareJidStr like %@";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFrmt, withJID, i];
    request.predicate = predicate;
    [request setEntity:entityDescription];
    
    NSError *error;
    NSArray *messages = [moc executeFetchRequest:request error:&error];
    
    return messages;
}

-(void)print:(NSMutableArray*)messages_arc {
    @autoreleasepool {
        for (XMPPMessageArchiving_Message_CoreDataObject *message in messages_arc) {
            
            NSXMLElement *element = [[NSXMLElement alloc] initWithXMLString:message.messageStr error:nil];
            NSLog(@"to param is %@",[element attributeStringValueForName:@"to"]);
            
            NSMutableDictionary *m = [[NSMutableDictionary alloc] init];
            [m setObject:message.body forKey:@"msg"];
            
            if ([[element attributeStringValueForName:@"to"] isEqualToString:jid]) {
                
                [m setObject:@"you" forKey:@"sender"];
            }
            else
            {
                [m setObject:jid forKey:@"sender"];
            }
            
            
            //[messages addObject:m];
            
            NSLog(@"bareJid param is %@",message.bareJid);
            NSLog(@"bareJidStr param is %@",message.bareJidStr);
            NSLog(@"body param is %@",message.body);
            NSLog(@"timestamp param is %@",message.timestamp);
            NSLog(@"outgoing param is %d",[message.outgoing intValue]);
            NSLog(@"outgoing param is %@",[message streamBareJidStr]);
            NSLog(@"***************************************************");
        }
    }
}

/*- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence {
    //[sender acceptPresenceSubscriptionRequestFrom:[XMPPJID jidWithString:[presence fromStr]] andAddToRoster:YES];
    
    /*if (!_usersWhoesSendFriendshipRequest) {
        _usersWhoesSendFriendshipRequest = [[NSMutableArray alloc] init];
        [_usersWhoesSendFriendshipRequest addObject:[presence from]];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FriendshipRequest" object:presence];
    NSLog(@"presence status: %@", presence);
}*/

@end
