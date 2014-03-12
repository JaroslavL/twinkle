//
//  User.h
//  JoinUp
//
//  Created by Vasily Galuzin on 11/02/14.
//  Copyright (c) 2014 Bros Universe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject <NSCoding>

@property (atomic, copy) NSString *name;
@property (atomic, copy) NSString *lastName;
@property (atomic, copy) NSString *age;
@property (atomic, copy) NSString *jabberID;
@property (atomic, copy) NSString *distance;
@property (atomic, copy) NSString* status;
@property (atomic, copy) NSString* avatar;
@property (atomic, copy) NSString* icon;
@property (atomic, copy) UIImage *imgAvatar;

// User say: i am wrote message or not
@property BOOL iAmWroteMessage;

@property int countMessages;

- (id) initWithUserData: (User *)user;

@end
