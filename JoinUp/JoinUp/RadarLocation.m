//
//  RadarLocation.m
//  JoinUp
//
//  Created by User on 18/03/14.
//  Copyright (c) 2014 Bros Universe. All rights reserved.
//

#import "RadarLocation.h"
#define SCALE 1

@implementation RadarLocation

static RadarLocation* _sharedInstance;

+ (RadarLocation *)sharedInstance {
    
    @synchronized(self) {
        
        if (!_sharedInstance) {
            _sharedInstance = [[RadarLocation alloc] init];
            [_sharedInstance initLocationManager];
        }
    }
    
    return _sharedInstance;
    
}

- (void) initLocationManager
{
    locationManager = [[CLLocationManager alloc]init];
    
    if ([CLLocationManager locationServicesEnabled]) {
        
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        [locationManager startUpdatingLocation];
        
    }
    
}


- (CLLocationCoordinate2D) findCurrentLocation {
    
    CLLocationCoordinate2D coordinate = [[locationManager location] coordinate];
    
    return coordinate;
    
}

- (void) locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    //NSLog(@"Location updated to = %@",newLocation);
    
    [NetworkConnection sendCoordinate:[newLocation coordinate]]; 
    
}

- (CGPoint) getCoordinatesOnRadar:(User *) user
{
    CLLocationCoordinate2D myCoords = [[RadarLocation sharedInstance] findCurrentLocation];
    
    //CLLocationCoordinate2D myCoords = CLLocationCoordinate2DMake(30.37689700, 59.935906500);
    CLLocation *myLocation = [[CLLocation alloc]initWithLatitude:myCoords.latitude longitude:myCoords.longitude];

        CLLocation *sameLongituteLocation = [[CLLocation alloc] initWithLatitude:[user.latitude doubleValue] longitude:myCoords.longitude];
        CLLocation *sameLatituteLocation = [[CLLocation alloc] initWithLatitude:myCoords.latitude longitude:[user.longitude doubleValue]];
        
        CLLocationDistance longituteDistance = [sameLongituteLocation distanceFromLocation: myLocation] * SCALE;
        CLLocationDistance latitudeDistance  = [sameLatituteLocation distanceFromLocation: myLocation] * SCALE;
        
        if (myCoords.latitude > [user.latitude doubleValue]) latitudeDistance = - latitudeDistance;
        if (myCoords.longitude < [user.longitude doubleValue]) longituteDistance = -longituteDistance;
        
        CGPoint point = CGPointMake(latitudeDistance, longituteDistance);
        NSLog(@"%f,%f",latitudeDistance ,longituteDistance);
    
    
    return point;

}


@end
