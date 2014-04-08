//
//  RadarProfileView.m
//  JURadar
//
//  Created by Kristina on 04.04.14.
//  Copyright (c) 2014 Bros Universe. All rights reserved.
//

#import "JURadarProfileView.h"
#import "User.h"



@implementation JURadarProfileView

- (NSMutableArray *)users
{
    if (!_users) _users = [[NSMutableArray alloc]init];
    return _users;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (instancetype)initWithUsers:(NSMutableArray *) users
{
    self = [super init];
    if (self) {
        // Initialization code
        self.users = users;
        self.frame = CGRectMake(0, 20, 320, 90);
        [self setContentSize:CGSizeMake(320*[users count], 90)];
        [self setPagingEnabled:YES];
        
        
        [self customInit:users];
    }
    return self;
}

- (void) customInit:(NSMutableArray *) us
{
    for (int i = 0; i < [us count]; i++)
    {
       UILabel* lblLogin = [[UILabel alloc] initWithFrame:CGRectMake(91+320*i, 6, 100, 14)];
        [lblLogin setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        
        lblLogin.text = ((User *)[us objectAtIndex:i]).jabberID;
        
       UILabel* lblFullName = [[UILabel alloc] initWithFrame:CGRectMake(91+320*i, 20, 200, 12)];
        [lblFullName setFont:[UIFont fontWithName:@"Helvetica" size:12]];
        lblFullName.text = @"Full name";
        
       UILabel* lblAge = [[UILabel alloc] initWithFrame:CGRectMake(91+320*i, 32, 50, 10)];
        [lblAge setFont:[UIFont fontWithName:@"Helvetica" size:10]];
        lblAge.text = @"33";
        
       UILabel* lblStatus = [[UILabel alloc] initWithFrame:CGRectMake(91+320*i, 50, 200, 10)];
        [lblStatus setFont:[UIFont fontWithName:@"Helvetica" size:10]];
        lblStatus.text = @"I like chatting";
        
        UIImageView* avatar = [[UIImageView alloc] initWithFrame:CGRectMake(14+320*i, 7, 59, 59)];
        [avatar setImage:((User *)[us objectAtIndex:i]).imgAvatar];
        //[avatar setImage:[UIImage imageNamed:@"noimage.png" ]];
        [avatar setUserInteractionEnabled:YES];
        UITapGestureRecognizer *singlTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPhoto)];
        [singlTap setNumberOfTapsRequired:1];
        [avatar addGestureRecognizer:singlTap];
        
        UIButton* btnStartChatingWith = [[UIButton alloc] initWithFrame:CGRectMake(270+320*i, 25, 30, 30)];
        [btnStartChatingWith setBackgroundImage:[UIImage imageNamed:@"startchat.png"]
                                       forState:UIControlStateNormal];
        [btnStartChatingWith addTarget:self action:@selector(startChatingWith)
                      forControlEvents:UIControlEventTouchDown];
        
        [self addSubview:lblLogin];
        [self addSubview:lblFullName];
        [self addSubview:lblAge];
        [self addSubview:lblStatus];
        [self addSubview:avatar];
        [self addSubview:btnStartChatingWith];
    }
}

- (User *) getCurrentUser
{
    CGPoint offset = self.contentOffset;
    int i = offset.x/320;
    User* user = [self.users objectAtIndex:i];
    
    return user;
}

- (void)startChatingWith {
    [self.delegate performSegueWithIdentifier:@"showChat" sender:[self getCurrentUser]];
}

- (void)showPhoto {
    [self.delegate performSegueWithIdentifier:@"showPhoto" sender:[[self getCurrentUser] imgAvatar]];
}

@end
