//
//  User.m
//  JoinUp
//
//  Created by Vasily Galuzin on 11/02/14.
//  Copyright (c) 2014 Bros Universe. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize name;
@synthesize lastName;
@synthesize age;
@synthesize distance;
@synthesize jabberID;
@synthesize status;
@synthesize avatar;
@synthesize icon;
@synthesize imgAvatar;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self)
    {
        NSNumber *countMessages;
        
        jabberID = [aDecoder decodeObjectForKey:@"jabberID"];
        countMessages = [aDecoder decodeObjectForKey:@"countMessage"];
        
        _countMessages = [countMessages intValue];
        
        
        //TODO: request for aech user data from server

    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    NSNumber *countMessages = [[NSNumber alloc] initWithInt:_countMessages];
    
    [aCoder encodeObject:jabberID forKey:@"jabberID"];
    [aCoder encodeObject:countMessages forKey:@"countMessage"];
    
}

- (id) initWithUserData: (User *)user {
    
    [self setName:[user name]];
    [self setLastName:[user lastName]];
    [self setAge:[user age]];
    [self setDistance:[user distance]];
    [self setJabberID:[user jabberID]];
    [self setStatus:[user status]];
    [self setIcon:[user icon]];
    [self setImgAvatar:[user imgAvatar]];
    
    [self setCountMessages:[user countMessages]];
    
    return self;
    
}

@end
