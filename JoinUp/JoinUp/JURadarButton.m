//
//  RadarUserLocationButton.m
//  JoinUp
//
//  Created by User on 18/03/14.
//  Copyright (c) 2014 Bros Universe. All rights reserved.
//

#import "JURadarButton.h"

@implementation JURadarButton
@synthesize coordinate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //self.backgroundColor = [UIColor blueColor];
    }
    return self;
}

- (id) initWithUser:(User*) user
{
    self = [super init];
    if (self) {
        
        [self setImage:[UIImage imageNamed:@"pointMale.png"] forState:UIControlStateNormal];
        _user = user;
        coordinate = [[RadarLocation sharedInstance] getCoordinatesOnRadar:user];
        
        coordinate.x -= RADARUSERBUTTON_WIDTH/2;
        coordinate.y -= RADARUSERBUTTON_HEIGHT/2;

    }
    return self;
}

- (User *) getUser
{
    return _user;
}

@end
