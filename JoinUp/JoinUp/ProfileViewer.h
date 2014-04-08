//
//  ProfileViewer.h
//  JoinUp
//
//  Created by solid on 17.03.14.
//  Copyright (c) 2014 Bros Universe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Profile.h"
#import "UIImage+ChangeResolution.h"

@interface ProfileViewer : UIView

@property id delegate;
@property (nonatomic, strong) User* currentUser;

@property (nonatomic, strong) IBOutlet UILabel *lblLogin;
@property (nonatomic, strong) IBOutlet UILabel *lblFullName;
@property (nonatomic, strong) IBOutlet UILabel *lblAge;
@property (nonatomic, strong) IBOutlet UILabel *lblStatus;
@property (nonatomic, strong) IBOutlet UIImageView *avatar;
@property (nonatomic, strong) IBOutlet UIButton *btnStartChatingWith;


- (void)drawRect:(CGRect)rect profile: (Profile *)profile;
- (void)drawRect:(CGRect)rect user: (User *)user;

- (void)showProfile: (Profile *)profile;
- (void)showUserProfile: (User *)user;

- (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage;

- (void)startChatingWith;
- (void)showPhoto;

- (void)changeAvatarNotification;

@end
