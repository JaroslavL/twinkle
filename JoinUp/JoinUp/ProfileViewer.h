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

- (void)drawRect:(CGRect)rect profile: (Profile *)profile showBtnStartChatingWith: (BOOL)showBtnStartChatingWith;
- (void)drawRect:(CGRect)rect user: (User *)user showBtnStartChatingWith: (BOOL)showBtnStartChatingWith;

- (void)showProfile: (Profile *)profile showBtnStartChatingWith: (BOOL)showBtnStartChatingWith;
- (void)showUserProfile: (User *)user showBtnStartChatingWith: (BOOL)showBtnStartChatingWith;

@end
