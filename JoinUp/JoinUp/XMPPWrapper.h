//
//  XMPPWrapper.h
//  ChatTestApp
//
//  Created by solid on 10.02.14.
//  Copyright (c) 2014 solid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPP.h"
#import "XMPPMessage.h"
#import "XMPPvCardTemp.h"
#import "XMPPvCardTempModule.h"
#import "XMPPvCardCoreDataStorage.h"
#import "XMPPMessageArchivingCoreDataStorage.h"
#import "NetworkConnection.h"
#import "XMPPRoster.h"
#import "XMPPRosterCoreDataStorage.h"
#import "XMPPRosterMemoryStorage.h"
#import "XMPPFramework.h"

@interface XMPPWrapper : NSObject <XMPPRosterDelegate, XMPPRosterStorage, XMPPRosterMemoryStorageDelegate> {
//    XMPPStream *xmppStream;
//    XMPPRoster *xmppRoster;
//    XMPPRosterCoreDataStorage *xmppRosterStorage;
        XMPPvCardCoreDataStorage *xmppvCardStorage;
    
    NSMutableArray *_usersWhoesSendFriendshipRequest;
    
    NSString *jid;
    NSString *passwd;
    
    NSString *hostName;
    
    BOOL REGISTER;
}
@property(readwrite) BOOL REGISTER;
@property (nonatomic, strong, readonly) XMPPStream *xmppStream;
@property (nonatomic, strong, readonly) XMPPRoster *xmppRoster;
@property (nonatomic, strong, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;
@property (nonatomic, strong, readonly) XMPPvCardTempModule *xmppvCardTempModule;
@property (nonatomic, strong, readonly) XMPPvCardAvatarModule *xmppvCardAvatarModule;
@property (nonatomic, strong, readonly) XMPPCapabilities *xmppCapabilities;
@property (nonatomic, strong, readonly) XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;


+ (XMPPWrapper *)sharedInstance;

- (id)initWithUserData: (NSString *)login andPasswd: (NSString *)password andHostName: (NSString *)hostname;
- (void)initMessageArchiving;
- (void)initRoster;
- (void)initvCard;
- (void)setupStream;
- (void)goOnline;
- (void)goOffline;
- (BOOL)connect;
- (void)disconnect;
- (void)sendMessage: (NSXMLElement *)message;

-(NSArray *)loadArchiveMessage: (NSString *)withJID i: (NSString *)i;
-(void)print:(NSMutableArray*)messages_arc;

@end
