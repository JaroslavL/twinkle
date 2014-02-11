//
//  XMPPWrapper.h
//  ChatTestApp
//
//  Created by solid on 10.02.14.
//  Copyright (c) 2014 solid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPP.h"

@interface XMPPWrapper : NSObject {
    XMPPStream *xmppStream;
    
    NSString *jid;
    NSString *passwd;
    
    NSString *hostName;
    
    BOOL REGISTER;
}
@property(readwrite) BOOL REGISTER;

- (id)initWithUserData: (NSString *)login andPasswd: (NSString *)password andHostName: (NSString *)hostname;
- (void)setupStream;
- (void)goOnline;
- (void)goOffline;
- (BOOL)connect;
- (void)disconnect;

@end
