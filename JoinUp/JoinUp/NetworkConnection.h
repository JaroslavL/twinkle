//
//  NetworkConnection.h
//  JoinUp
//
//  Created by Vasily Galuzin on 14/02/14.
//  Copyright (c) 2014 Bros Universe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface NetworkConnection : NSObject

/*@property (atomic) NSMutableURLRequest *request;
@property (atomic) NSData *responseData;*/

- (BOOL) registration;
- (BOOL) login;
- (BOOL) setProfile;
- (User *) getProfile: (NSString *)jid;
- (NSMutableArray *) getProfiles: (NSArray *)jids;
- (NSArray*) getNearbyUsers;

@end