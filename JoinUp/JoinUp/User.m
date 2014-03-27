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
@synthesize email;
@synthesize distance;
@synthesize jabberID;
@synthesize status;
@synthesize avatar;
@synthesize icon;
@synthesize imgAvatar;
@synthesize latitude;
@synthesize longitude;


NSString *const KEY_USERS = @"users";
NSString *const KEY_AVATAR = @"avatar";
NSString *const KEY_LAST_NAME = @"last_name";
NSString *const KEY_NAME = @"name";
NSString *const KEY_STATUS = @"status";
NSString *const KEY_LOGIN = @"login";
NSString *const KEY_AGE = @"age";
NSString *const KEY_EMAIL = @"email";

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
    [self setEmail:[user email]];
    [self setDistance:[user distance]];
    [self setJabberID:[user jabberID]];
    [self setStatus:[user status]];
    [self setIcon:[user icon]];
    [self setImgAvatar:[user imgAvatar]];
    [self setLatitude:[user latitude]];
    [self setLongitude:[user longitude]];
    
    [self setCountMessages:[user countMessages]];
    
    return self;
    
}

- (User *) initWithDictionary: (NSDictionary *)dictionary {
    
    User *u = [[User alloc] init];
    
    [u setName:[dictionary objectForKey:KEY_NAME]];
    [u setLastName:[dictionary objectForKey:KEY_LAST_NAME]];
    [u setAge:[dictionary objectForKey:KEY_AGE]];
    [u setEmail:[dictionary objectForKey:KEY_EMAIL]];
    [u setJabberID:[dictionary objectForKey:KEY_LOGIN]];
    [u setAvatar:[dictionary objectForKey:KEY_AVATAR]];
    [u setStatus:[dictionary objectForKey:KEY_STATUS]];
    
    [u setLongitude:[dictionary objectForKey:@"longitude"]];
    [u setLatitude:[dictionary objectForKey:@"latitude"]];
    
    id path = [dictionary objectForKey:KEY_AVATAR];
    NSURL *url = [NSURL URLWithString:path];
    NSData *avatarPhoto = [NSData dataWithContentsOfURL:url];
    
    [u setImgAvatar:[[UIImage alloc] initWithData:avatarPhoto]];
    
    return u;
}


@end
