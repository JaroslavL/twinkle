//
//  ManagerMessages.h
//  JoinUp
//
//  Created by solid on 07.03.14.
//  Copyright (c) 2014 Bros Universe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "XMPPMessage.h"

@interface ManagerMessages : NSObject <NSCoding>

@property (nonatomic, strong) NSMutableArray *UsersWhosemMessagesaArenNotRead;

+ (ManagerMessages *)sharedInstance;

- (void)add: (NSNotification *)notification;

@end
