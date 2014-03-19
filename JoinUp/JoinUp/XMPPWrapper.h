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

@interface XMPPWrapper : NSObject {
    XMPPStream *xmppStream;
    
    NSString *jid;
    NSString *passwd;
    
    NSString *hostName;
    
    BOOL REGISTER;
}
@property(readwrite) BOOL REGISTER;
@property XMPPStream *xmppStream;

+ (XMPPWrapper *)sharedInstance;

- (id)initWithUserData: (NSString *)login andPasswd: (NSString *)password andHostName: (NSString *)hostname;
- (void)initMessageArchiving;
- (void)setupStream;
- (void)goOnline;
- (void)goOffline;
- (BOOL)connect;
- (void)disconnect;
- (void)sendMessage: (NSXMLElement *)message;

-(NSArray *)loadArchiveMessage: (NSString *)withJID i: (NSString *)i;
-(void)print:(NSMutableArray*)messages_arc;

@end
