//
//  ProfileViewer.h
//  JoinUp
//
//  Created by solid on 17.03.14.
//  Copyright (c) 2014 Bros Universe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Profile.h"

@interface ProfileViewer : UIView

- (void)drawRect:(CGRect)rect profile: (Profile *)profile;
- (void)drawRect:(CGRect)rect user: (User *)user;

- (void)showProfile: (Profile *)profile;
- (void)showUserProfile: (User *)user;

- (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage;

@end
