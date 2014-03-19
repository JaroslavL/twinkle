//
//  RadarLocation.h
//  JoinUp
//
//  Created by User on 18/03/14.
//  Copyright (c) 2014 Bros Universe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "NetworkConnection.h"
#import "User.h"

@interface RadarLocation : NSObject <CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
}
+ (RadarLocation *)sharedInstance;

- (CLLocationCoordinate2D) findCurrentLocation;
- (CGPoint) getCoordinatesOnRadar:(User *) user;

@end
