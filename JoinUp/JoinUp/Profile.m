//
//  Profile.m
//  JoinUp
//
//  Created by solid on 21.02.14.
//  Copyright (c) 2014 Bros Universe. All rights reserved.
//

#import "Profile.h"

@implementation Profile

static Profile* _sharedInstance;

+ (Profile *)sharedInstance {
    
    @synchronized(self) {
        
        if (!_sharedInstance) {
            _sharedInstance = [[Profile alloc] init];
        }
    }
    
    return _sharedInstance;
    
}

- (id)initWithUserData: (User *)user {
    
    if (self = [super init]) {
        
        [self setName:[user name]];
        [self setLastName:[user lastName]];
        [self setJabberID:[user jabberID]];
        [self setDistance:[user distance]];
        [self setStatus:[user status]];
        [self setAvatar:[user avatar]];
        [self setIcon:[user icon]];
        [self setImgAvatar:[user imgAvatar]];
        
        _sharedInstance = self;
    }
    
    return _sharedInstance;
}

@end
