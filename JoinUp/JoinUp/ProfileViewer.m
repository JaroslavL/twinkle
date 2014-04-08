//
//  ProfileViewer.m
//  JoinUp
//
//  Created by solid on 17.03.14.
//  Copyright (c) 2014 Bros Universe. All rights reserved.
//

#import "ProfileViewer.h"
#import "XMPPWrapper.h"


@implementation ProfileViewer

@synthesize currentUser;

@synthesize lblLogin;
@synthesize lblFullName;
@synthesize lblAge;
@synthesize lblStatus;
@synthesize avatar;

@synthesize btnStartChatingWith;

- (id)init {
    
    self = [super init];
    if (self) {
        // Initialization code
        
        [self setFrame:CGRectMake(0, 65, 320, 73)];
        [self setBackgroundColor:[UIColor whiteColor]];
        
        lblLogin = [[UILabel alloc] initWithFrame:CGRectMake(91, 6, 100, 14)];
        [lblLogin setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        
        lblFullName = [[UILabel alloc] initWithFrame:CGRectMake(91, 20, 200, 12)];
        [lblFullName setFont:[UIFont fontWithName:@"Helvetica" size:12]];
        
        lblAge = [[UILabel alloc] initWithFrame:CGRectMake(91, 32, 50, 10)];
        [lblAge setFont:[UIFont fontWithName:@"Helvetica" size:10]];
        
        lblStatus = [[UILabel alloc] initWithFrame:CGRectMake(91, 50, 200, 10)];
        [lblStatus setFont:[UIFont fontWithName:@"Helvetica" size:10]];
        
        avatar = [[UIImageView alloc] initWithFrame:CGRectMake(14, 7, 59, 59)];
        [avatar setUserInteractionEnabled:YES];
        UITapGestureRecognizer *singlTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPhoto)];
        [singlTap setNumberOfTapsRequired:1];
        [avatar addGestureRecognizer:singlTap];
        
        btnStartChatingWith = [[UIButton alloc] initWithFrame:CGRectMake(270, 25, 30, 30)];
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
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeAvatarNotification) name:@"changeAvatar" object:nil];
        
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

- (void)showProfile: (Profile *)profile {
    
    currentUser = [Profile sharedInstance];
    
    [lblLogin setText:[profile jabberID]];
    
    [lblFullName setText:[NSString stringWithFormat:@"%@ %@", [profile name], [profile lastName]]];
    
    if ([[profile age] isEqualToString:@"0"]) {
        [lblAge setText:@"Unknown"];
    } else {
        [lblAge setText:[profile age]];
    }
    
    [lblStatus setText:[profile status]];
    
    UIImage * imgAvatar = [profile imgAvatar];
    [avatar setImage:[self maskImage:imgAvatar withMask:[UIImage imageNamed:@"maska.png"]]];
    
    /*XMPPvCardTemp *xmppvCardTemp = [[[XMPPWrapper sharedInstance] xmppvCardTempModule] myvCardTemp];
    [avatar setImage:[[UIImage alloc] initWithData:[xmppvCardTemp photo]]];*/
    
    [btnStartChatingWith setHidden:YES];
    
    //UIImage *imgStatus = [profile icon];
}

- (void)showUserProfile:(User *)user {
    
    currentUser = user;
    
    [lblLogin setText:[user jabberID]];
    
    [lblFullName setText:[NSString stringWithFormat:@"%@ %@", [user name], [user lastName]]];
    
    [lblAge setText:[user age]];
    
    [lblStatus setText:[user status]];
    
    UIImage * imgAvatar = [user imgAvatar];
    [avatar setImage:[self maskImage:imgAvatar withMask:[UIImage imageNamed:@"maska.png"]]];
    
    //UIImage *imgStatus = [profile icon];
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

- (void)changeAvatarNotification {
    [avatar setImage:[self maskImage:[[Profile sharedInstance] imgAvatar] withMask:[UIImage imageNamed:@"maska.png"]]];
}

- (void)startChatingWith{
    [_delegate performSegueWithIdentifier:@"showChat" sender:currentUser];
}

- (void)showPhoto {
    [_delegate performSegueWithIdentifier:@"showPhoto" sender:[currentUser imgAvatar]];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
