//
//  JURadar.m
//  JURadar
//
//  Created by Andrew on 02/04/14.
//  Copyright (c) 2014 Bros Universe. All rights reserved.
//

#import "JURadar.h"

@interface JURadar()

@property (nonatomic, retain) NSArray *previousLoadedUsers; // of Users
@property (nonatomic, retain) NSTimer *timer;

@end


@implementation JURadar

- (instancetype)init
{
    self = [super init];
    
    if (self){
        
    }
    
    return self;
}

- (void) startRadar
{
 
    // NSMutableArray* nearbyUsers = [[NSMutableArray alloc] init];
    
    
    
//    User*u = [[User alloc]init];
//    [u setJabberID:@"1"];
//    [u setLatitude:@"0.000100"];
//    [u setLongitude:@"0.000100"];
//    [nearbyUsers addObject:u];
//    
//    User*u1 = [[User alloc]init];
//    [u1 setJabberID:@"2"];
//    [u1 setLatitude:@"-0.000110"];
//    [u1 setLongitude: @"0.001000"];
//    [nearbyUsers addObject:u1];
//    
//    User*u2 = [[User alloc]init];
//    [u2 setJabberID:@"3"];
//    [u2 setLatitude:@"-0.000500"];
//    [u2 setLongitude: @"-0.000450"];
//    [nearbyUsers addObject:u2];
//    
//    User*u3 = [[User alloc]init];
//    [u3 setJabberID:@"4"];
//    [u3 setLatitude:@"0.001000"];
//    [u3 setLongitude:@"-0.000200"];
//    [nearbyUsers addObject:u3];
//    
//
//    self.previousLoadedUsers = nearbyUsers;
    
    [self loadUserInBackground];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0f
                                                  target:self
                                                selector:@selector(loadUserInBackground)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void) stopRadar
{
    [self.timer invalidate];
}

- (NSArray *)getAllUsers
{
    return self.previousLoadedUsers;
}

- (void) loadUserInBackground
{
    [self performSelectorInBackground:@selector(loadUsers) withObject:nil];
}

- (void) loadUsers
{
    NSLog( @"START LOADING USERS around ME" );
    
    [self.delegate didStartLoading];
    NSArray* nearbyUsers = [NetworkConnection getNearbyUsers];
    
    [self findChangesWith:nearbyUsers];
    
    self.previousLoadedUsers = nearbyUsers;
    
    nearbyUsers = nil;

}

- (void) findChangesWith:(NSArray *) newLoadedUsers
{
    
    [self findOfflineUsersWithArray:newLoadedUsers];
    
    [self findOnlineUsersWithArray:newLoadedUsers];
    
    [self findMoveUserWithArray:newLoadedUsers];
        
}

- (void) findMoveUserWithArray:(NSArray *) newLoadedUsers
{
    for (User *loadedUser in newLoadedUsers)
    {
        [self findChangesWithUser: loadedUser];
    }
}


- (void) findChangesWithUser:(User *) user
{
    BOOL isMoved = YES;
    BOOL isNew = TRUE;
    if ([self.previousLoadedUsers count]){
        for (User *prloadedUser in self.previousLoadedUsers)
        {
            if ([prloadedUser.jabberID isEqual:user.jabberID])
            {
                isNew = FALSE;
                if ([prloadedUser.longitude isEqual:user.longitude] && [prloadedUser.latitude isEqual:user.latitude])
                {
                    isMoved = NO;
                    break;
                }
            }
            
        }
        
        if (isMoved && !isNew)[self.delegate didUserMove:user];
    }
    
}

- (void) findOfflineUsersWithArray:(NSArray *) array
{
    BOOL isOffline;
    for (User *previousLoadedUser in self.previousLoadedUsers)
    {
        isOffline = YES;
        for ( User *newUser in array)
        {
            if ( [previousLoadedUser.jabberID isEqual:newUser.jabberID])
            {
                isOffline = NO;
                break;
            }
        }
        
        if (isOffline) [self.delegate didUserOffline:previousLoadedUser];
    }

}

- (void) findOnlineUsersWithArray:(NSArray *) array
{
    if (![self.previousLoadedUsers count])
    {
        for (User *newUser in array)
        {
            [self.delegate didUserOnline:newUser];
        }
    } else {
    
        for (User *newUser in array)
        {
            BOOL isNewUser = YES;
            for ( User *previousLoadedUser in self.previousLoadedUsers)
            {
                if ( [previousLoadedUser.jabberID isEqual:newUser.jabberID])
                {
                    isNewUser = NO;
                }
                
                if (!isNewUser) break;
            }
            
            if (isNewUser)[self.delegate didUserOnline:newUser];
        }
    }
    
}



@end
