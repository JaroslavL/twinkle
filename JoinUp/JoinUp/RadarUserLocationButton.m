//
//  RadarUserLocationButton.m
//  JoinUp
//
//  Created by User on 18/03/14.
//  Copyright (c) 2014 Bros Universe. All rights reserved.
//

#import "RadarUserLocationButton.h"

@implementation RadarUserLocationButton
@synthesize coordinate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor blueColor];
    }
    return self;
}

- (id) initWithUser:(User*) user
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor blueColor];
        _user = user;
        coordinate = [[RadarLocation sharedInstance] getCoordinatesOnRadar:user];
        self.layer.cornerRadius = 2.0f;

    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (User *) getUser
{
    return _user;
}

@end
