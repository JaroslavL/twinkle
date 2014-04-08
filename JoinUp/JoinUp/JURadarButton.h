//
//  RadarUserLocationButton.h
//  JoinUp
//
//  Created by User on 18/03/14.
//  Copyright (c) 2014 Bros Universe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "RadarLocation.h"

#define RADARUSERBUTTON_WIDTH 22
#define RADARUSERBUTTON_HEIGHT 22

@interface JURadarButton : UIButton
{
    User* _user;
}

- (id) initWithUser:(User*) user;
- (User *) getUser;

@property UILabel *juRadarPopUpLabel;
@property CGPoint coordinate;

@end
