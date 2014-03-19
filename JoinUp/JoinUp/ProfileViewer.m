//
//  ProfileViewer.m
//  JoinUp
//
//  Created by solid on 17.03.14.
//  Copyright (c) 2014 Bros Universe. All rights reserved.
//

#import "ProfileViewer.h"


@implementation ProfileViewer


- (id)init {
    
    self = [super init];
    if (self) {
        // Initialization code
        [self setFrame:CGRectMake(0, 65, 320, 73)];
        [self setBackgroundColor:[UIColor grayColor]];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
/*- (void)drawRect:(CGRect)rect
{
    // Drawing code
}*/

- (void)drawRect:(CGRect)rect profile: (Profile *)profile
{
    // Drawing code
    
    //Profile *profile = [Profile sharedInstance];
    
    UILabel *lblLogin = [[UILabel alloc] initWithFrame:CGRectMake(91, 6, 100, 14)];
    [lblLogin setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    [lblLogin setBackgroundColor:[UIColor redColor]];
    [lblLogin setText:[profile jabberID]];
    
    UILabel *lblFullName = [[UILabel alloc] initWithFrame:CGRectMake(91, 20, 200, 12)];
    [lblFullName setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [lblFullName setBackgroundColor:[UIColor greenColor]];
    [lblFullName setText:[NSString stringWithFormat:@"%@ %@", [profile name], [profile lastName]]];
    
    UILabel *lblAge = [[UILabel alloc] initWithFrame:CGRectMake(91, 32, 50, 10)];
    [lblAge setFont:[UIFont fontWithName:@"Helvetica" size:10]];
    [lblAge setBackgroundColor:[UIColor blueColor]];
    
    if ([[profile age] isEqualToString:@"0"]) {
        [lblAge setText:@"Unknown"];
    } else {
        [lblAge setText:[profile age]];
    }
    
    UILabel *lblStatus = [[UILabel alloc] initWithFrame:CGRectMake(91, 50, 200, 10)];
    [lblStatus setFont:[UIFont fontWithName:@"Helvetica" size:10]];
    [lblStatus setBackgroundColor:[UIColor greenColor]];
    [lblStatus setText:[profile status]];
    
    UIImage * imgAvatar = [profile imgAvatar];
    UIImageView *avatar = [[UIImageView alloc] initWithFrame:CGRectMake(14, 7, 59, 59)];
    [avatar setImage:[self maskImage:imgAvatar withMask:[UIImage imageNamed:@"maska.png"]]];
    
    //UIImage *imgStatus = [profile icon];
    
    [self addSubview:lblLogin];
    [self addSubview:lblFullName];
    [self addSubview:lblAge];
    [self addSubview:lblStatus];
    [self addSubview:avatar];
    //[self addSubview:[imgStatus]];
}

- (void)drawRect:(CGRect)rect user: (User *)user
{
    // Drawing code
    
    //Profile *profile = [Profile sharedInstance];
    
    UILabel *lblLogin = [[UILabel alloc] initWithFrame:CGRectMake(91, 6, 100, 14)];
    [lblLogin setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    [lblLogin setBackgroundColor:[UIColor redColor]];
    [lblLogin setText:[user jabberID]];
    
    UILabel *lblFullName = [[UILabel alloc] initWithFrame:CGRectMake(91, 20, 200, 12)];
    [lblFullName setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [lblFullName setBackgroundColor:[UIColor greenColor]];
    [lblFullName setText:[NSString stringWithFormat:@"%@ %@", [user name], [user lastName]]];
    
    UILabel *lblAge = [[UILabel alloc] initWithFrame:CGRectMake(91, 32, 50, 10)];
    [lblAge setFont:[UIFont fontWithName:@"Helvetica" size:10]];
    [lblAge setBackgroundColor:[UIColor blueColor]];
    [lblAge setText:[user age]];
    
    UILabel *lblStatus = [[UILabel alloc] initWithFrame:CGRectMake(91, 50, 200, 10)];
    [lblStatus setFont:[UIFont fontWithName:@"Helvetica" size:10]];
    [lblStatus setBackgroundColor:[UIColor greenColor]];
    [lblStatus setText:[user status]];
    
    UIImage * imgAvatar = [user imgAvatar];
    UIImageView *avatar = [[UIImageView alloc] initWithFrame:CGRectMake(14, 7, 59, 59)];
    [avatar setImage:[self maskImage:imgAvatar withMask:[UIImage imageNamed:@"maska.png"]]];
        
    UIButton *btnStartChatingWith = [[UIButton alloc] initWithFrame:CGRectMake(270, 25, 30, 30)];
    [btnStartChatingWith setBackgroundImage:[UIImage imageNamed:@"startchat.png"] forState:UIControlStateNormal];
    [self addSubview:btnStartChatingWith];
    
    //UIImage *imgStatus = [profile icon];
    
    [self addSubview:lblLogin];
    [self addSubview:lblFullName];
    [self addSubview:lblAge];
    [self addSubview:lblStatus];
    [self addSubview:avatar];
    //[self addSubview:[imgStatus]];
}

- (void)showProfile: (Profile *)profile {
    [self drawRect:CGRectMake(0, 65, 320, 73) profile:profile];
}

- (void)showUserProfile:(User *)user {
    [self drawRect:CGRectMake(0, 65, 320, 73) user:user];
}

- (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage {
    
    CGImageRef maskRef = maskImage.CGImage;
    
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageRef masked = CGImageCreateWithMask([image CGImage], mask);
    return [UIImage imageWithCGImage:masked];
    
}

@end
