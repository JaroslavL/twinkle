//
//  Profile.h
//  JoinUp
//
//  Created by solid on 21.02.14.
//  Copyright (c) 2014 Bros Universe. All rights reserved.
//

#import "User.h"

@interface Profile : User

+ (Profile *)sharedInstance;

- (id)initWithUserData: (User *)user;

@end
