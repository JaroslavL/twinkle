//
//  NetworkConnection.h
//  JoinUp
//
//  Created by Vasily Galuzin on 14/02/14.
//  Copyright (c) 2014 Bros Universe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "RadarLocation.h"
#import "User.h"
#import "Profile.h"

@interface NetworkConnection : NSObject

/*@property (atomic) NSMutableURLRequest *request;
@property (atomic) NSData *responseData;*/

- (BOOL) setProfile: (Profile *)profile;
+ (User *)           getProfile: (NSString *)jid;
+ (NSMutableArray *) getProfiles: (NSArray *)jids;
+ (NSArray*)         getNearbyUsers;

+ (BOOL) sendCoordinate:(CLLocationCoordinate2D) coordinate;

@end