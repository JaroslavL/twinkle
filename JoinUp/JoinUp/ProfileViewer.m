//
//  ProfileViewer.m
//  JoinUp
//
//  Created by solid on 17.03.14.
//  Copyright (c) 2014 Bros Universe. All rights reserved.
//

#import "ProfileViewer.h"

@implementation ProfileViewer

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self setBackgroundColor:[UIColor grayColor]];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    Profile *profile = [Profile sharedInstance];
    
    UILabel *lblLogin = [[UILabel alloc] initWithFrame:CGRectMake(60, 6, 100, 12)];
    [lblLogin setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [lblLogin setBackgroundColor:[UIColor redColor]];
    [lblLogin setText:[profile jabberID]];
    
    UILabel *lblFullName = [[UILabel alloc] initWithFrame:CGRectMake(60, 18, 200, 12)];
    [lblFullName setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [lblFullName setBackgroundColor:[UIColor greenColor]];
    [lblFullName setText:[NSString stringWithFormat:@"%@ %@", [profile name], [profile lastName]]];
    
    UILabel *lblAge = [[UILabel alloc] initWithFrame:CGRectMake(60, 30, 50, 12)];
    [lblAge setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [lblAge setBackgroundColor:[UIColor blueColor]];
    [lblAge setText:[profile age]];
    
    UILabel *lblStatus = [[UILabel alloc] initWithFrame:CGRectMake(60, 50, 200, 12)];
    [lblStatus setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [lblStatus setBackgroundColor:[UIColor greenColor]];
    [lblStatus setText:[profile status]];
    
    UIImage * imgAvatar = [profile imgAvatar];
    UIImageView *avatar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 55, 55)];
    [avatar setImage:imgAvatar];
    
    //UIImage *imgStatus = [profile icon];
    
    [self addSubview:lblLogin];
    [self addSubview:lblFullName];
    [self addSubview:lblAge];
    [self addSubview:lblStatus];
    [self addSubview:avatar];
    //[self addSubview:[imgStatus]];
}


@end
