//
//  RadarViewController.m
//  JoinUp
//
//  Created by solid on 18.02.14.
//  Copyright (c) 2014 Bros Universe. All rights reserved.
//

#import "RadarViewController.h"
#import "RadarLocation.h"
#import "RadarUserLocationButton.h"
#import "RadarLoader.h"

@interface RadarViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *circle4;
@property (weak, nonatomic) IBOutlet UIImageView *circle3;
@property (weak, nonatomic) IBOutlet UIImageView *circle2;
@property (weak, nonatomic) IBOutlet UIImageView *cirlce1;
@property (weak, nonatomic) IBOutlet UIImageView *centralPoint;

@property (strong, nonatomic) NSTimer *timer;

@end

@implementation RadarViewController

@synthesize nearbyUsers;
@synthesize chatViewController;
@synthesize profileViewer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

#pragma mark - Life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
	// Do any additional setup after loading the view.
    
    buttonArray = [NSMutableArray new];
    
    //  Provile View Settings
    profileViewer = [[ProfileViewer alloc]init];
    profileViewer.delegate = self;
    [self.view addSubview:profileViewer];
    profileViewer.hidden =YES;
    
    
    [self loadUserAndDrawPointsInBackground];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0f
                                                  target:self
                                                selector:@selector(loadUserAndDrawPointsInBackground)
                                                userInfo:nil
                                                 repeats:YES];
    
    //    [self runSpinAnimationOnView:self.cirlce1 duration:14 rotations:10 repeat:10];
    //    [self runSpinAnimationOnView:self.circle2 duration:31 rotations:10 repeat:10];
    //    [self runSpinAnimationOnView:self.circle3 duration:36 rotations:10 repeat:10];
    //    [self runSpinAnimationOnView:self.circle4 duration:43 rotations:10 repeat:10];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.timer invalidate];
}

#pragma mark - load and draw users

- (void)  loadUserAndDrawPointsInBackground// draw switch on mainThread
{
    [self performSelectorInBackground:@selector(loadUsers) withObject:nil];
}

- (void) loadUsers
{
    NSLog( @"START LOADING USERS around ME" );
    nearbyUsers = [NetworkConnection getNearbyUsers];
    NSLog(@"%lu users around me",(unsigned long)[nearbyUsers count]);
    [self updateRadar];
}

- (void) updateRadar
{
    CLLocationCoordinate2D coord = [[RadarLocation sharedInstance] findCurrentLocation];
    self.latitideLabal.text = [NSString stringWithFormat:@"%f",coord.latitude];
    self.longitude.text = [NSString stringWithFormat:@"%f",coord.longitude];
    
    
    for (UIButton *btn in buttonArray)
    {
        [btn removeFromSuperview];
    }
    [buttonArray removeAllObjects];
    
    
    [self drawRadarPoints];
}

- (void) drawRadarPoints
{
    [self createButtonArrayWithUsers:nearbyUsers];
    [self performSelectorOnMainThread:@selector(displayButtonArray)  withObject:nil waitUntilDone:YES];
}



- (void) createButtonArrayWithUsers:(NSArray *) users
{
    for (User *userInUsers in users)
    {
        RadarUserLocationButton *newButton = [[RadarUserLocationButton alloc]initWithUser:userInUsers];
        [newButton addTarget:self
                      action:@selector(tapRadarUserLocationButton:)
            forControlEvents:UIControlEventTouchUpInside];
        [buttonArray addObject:newButton];
    }
}

- (void) displayButtonArray
{
    for (RadarUserLocationButton *btn in buttonArray)
    {
        btn.frame = CGRectMake(self.centralPoint.center.x+btn.coordinate.x, self.centralPoint.center.y+btn.coordinate.y, 22, 22);
        
        [self.view addSubview:btn];
    }
    
}

#pragma mark - User's interaction

- (void) tapRadarUserLocationButton:(RadarUserLocationButton*) sender
{
    
    //    [UIView beginAnimations:@"ScaleButton" context:NULL];
    //    [UIView setAnimationDuration: 0.5f];
    //    sender.transform = CGAffineTransformMakeScale(5.0,5.0);
    //
    //    [UIView commitAnimations];
    //
    
    //    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"scale"];
    //    anim.duration = 5.0f;
    //    anim.fromValue = [NSValue valueWithCGAffineTransform:CGAffineTransformMakeScale(1.0f, 1.0f)];
    //    anim.toValue = [NSValue valueWithCGAffineTransform:CGAffineTransformMakeScale(5.0f, 5.0f)];
    //    anim.byValue  = [NSValue valueWithCGAffineTransform:sender.transform];
    //    //    anim.toValue = (id)[UIColor redColor].CGColor;
    //    //    anim.fromValue =  (id)[UIColor blackColor].CGColor;
    //
    //    //anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //    anim.repeatCount = 1;
    //    anim.autoreverses = YES;
    
    //   [sender.layer addAnimation:anim forKey:nil];
    //
//    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"bounds"];
//    anim.duration = 1.f;
//    anim.fromValue = [NSValue valueWithCGRect:CGRectMake(0,0,10,10)];
//    anim.toValue = [NSValue valueWithCGRect:CGRectMake(10,10,200,200)];
//    anim.byValue  = [NSValue valueWithCGRect:sender.bounds];
//    //    anim.toValue = (id)[UIColor redColor].CGColor;
//    //    anim.fromValue =  (id)[UIColor blackColor].CGColor;
//    
//    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    anim.repeatCount = 1;
//    anim.autoreverses = YES;
//    
//    [sender.layer addAnimation:anim forKey:nil];
//    
    //    CABasicAnimation *theAnimation;
    //
    //    theAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    //    theAnimation.duration=1.0;
    //    theAnimation.repeatCount=HUGE_VALF;
    //    theAnimation.autoreverses=YES;
    //    theAnimation.fromValue=[NSNumber numberWithFloat:1.0];
    //    theAnimation.toValue=[NSNumber numberWithFloat:0.0];
    //    [self.view.layer addAnimation:theAnimation forKey:@"animateOpacity"]; //myButton.layer instead of
    
//    CATransition *animation=[CATransition animation];
//    [animation setDelegate:self];
//    [animation setDuration:1.0];
//    [animation setTimingFunction:UIViewAnimationCurveEaseInOut];
//    [animation setType:@"rippleEffect"];
//    
//    [animation setFillMode:kCAFillRuleNonZero];
//    animation.endProgress=0.99;
//    [animation setRemovedOnCompletion:NO];
//    
//    [self.view.layer addAnimation:animation forKey:nil];
//    
    
    [profileViewer showUserProfile:[sender getUser]];
    profileViewer.hidden = NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:touch.view];
    if (location.y < profileViewer.frame.origin.y + profileViewer.frame.size.height ) return;
    [profileViewer setHidden:YES];
}

#pragma mark - Animation


- (void) runSpinAnimationOnView:(UIView*)view duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat;
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 1.0 /* full rotation*/ * rotations * duration ];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeat;
    rotationAnimation.speed = 0.1;
    
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}


#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showChat"]) {
        NSDate *object = sender;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NewActiveChat" object:object];
        [[segue destinationViewController] setIsCurrentInterlocutor:sender];
    }
    
    if ([[segue identifier] isEqualToString:@"showPhoto"]) {
        [[segue destinationViewController] showPhoto:sender];
    }
}

@end
