//
//  RadarViewController.m
//  JURadar
//
//  Created by Andrew on 02/04/14.
//  Copyright (c) 2014 Bros Universe. All rights reserved.
//

#import "RadarViewController.h"

#define JURADAR_RADIUS_MAX 100
#define JURADAR_RADIUS_MIN 25
#define JURADAR_RADIUS_PX 130 // = последнему кругу

#define TOUCHRECT_WIDTH 10
#define TOUCHRECT_HEIGHT 10

#define JURADAR_RADIUS_MIN_PX 32.5 //px

#define JURADAR_ZOOMBUTTON_CHANGEZOOMVALUE 1

@interface RadarViewController ()

@property (weak, nonatomic) IBOutlet UIView *radarView;
@property (weak, nonatomic) IBOutlet UIButton *centralRadarButton;
@property (weak, nonatomic) IBOutlet UISlider *zoomSlider;
@property (weak, nonatomic) IBOutlet UILabel *zoomLabel;
@property (weak, nonatomic) IBOutlet UILabel *onlineUsersLabel;

@property (weak, nonatomic) IBOutlet UIImageView *circle1View;
@property (weak, nonatomic) IBOutlet UIImageView *circle2View;
@property (weak, nonatomic) IBOutlet UIImageView *circle3View;
@property (weak, nonatomic) IBOutlet UIImageView *circle4View;

@property (nonatomic, strong) JURadar *radar;
@property (nonatomic, strong) JURadarProfileView *juRadarProfileView;
@property (nonatomic, strong) NSMutableArray *juRadarButtons; //
@property (nonatomic, strong) NSMutableArray *juRadarButtonsLabels;


@property float zoom;
@property int displayedPeople;

@end

@implementation RadarViewController

@synthesize zoom;

#pragma mark - Lazy

- (NSMutableArray *)juRadarButtons
{
    if (!_juRadarButtons) _juRadarButtons = [[NSMutableArray alloc] init];
    return _juRadarButtons;
}

- (NSMutableArray *)juRadarButtonsLabels
{
    if (!_juRadarButtonsLabels) _juRadarButtonsLabels = [[NSMutableArray alloc]init];
    return _juRadarButtonsLabels;
}

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.zoomSlider.maximumTrackTintColor =[UIColor whiteColor];
    [[UISlider appearance] setThumbImage:[UIImage imageNamed:@"rolik.png"] forState:UIControlStateNormal];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAreaJURadarButton:)];
    [self.radarView addGestureRecognizer:tap];
    
    [NetworkConnection sendCoordinate:[[RadarLocation sharedInstance] findCurrentLocation]];
    self.radar = [[JURadar alloc] init];
    self.radar.delegate = self;
    [self.radar startRadar];
    
    self.zoom = -self.zoomSlider.value;
    self.displayedPeople = 0;
    self.zoomLabel.text = [NSString stringWithFormat:@"%.1f m",JURADAR_RADIUS_MAX/zoom];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    
    [self appearAnimationCircle:self.circle1View];
    [self appearAnimationCircle:self.circle2View];
    [self appearAnimationCircle:self.circle3View];
    [self appearAnimationCircle:self.circle4View];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - taps




- (IBAction) tapCentralRadarButton:(UIButton *) centralRadarButton
{
    [self.radar stopRadar];
    [self.radar startRadar];
}

- (void) tapJURadarButton: (JURadarButton *) sender
{
    NSLog( @" Button tap %@", [sender getUser].jabberID );
    UILabel *juButtonPopUpLabel = [[UILabel alloc] init];
    juButtonPopUpLabel.text = [ sender getUser].jabberID;
    juButtonPopUpLabel.textAlignment = UITextAlignmentCenter;
    juButtonPopUpLabel.backgroundColor = [UIColor whiteColor];
    
    CGPoint convertPoint = [self.radarView convertPoint:sender.center toView:self.view];
    if (convertPoint.x > 160 ) juButtonPopUpLabel.frame = CGRectMake(convertPoint.x - 80, convertPoint.y, 80, 20);
     else juButtonPopUpLabel.frame = CGRectMake(convertPoint.x, convertPoint.y, 80, 20);
    //juButtonPopUpLabel.frame = CGRectMake(sender.center.x,sender.center.y,80,20);
    juButtonPopUpLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    juButtonPopUpLabel.layer.shadowOffset = CGSizeMake(0, 0);
    juButtonPopUpLabel.layer.shadowOpacity = 1.0;
    juButtonPopUpLabel.layer.shadowRadius = 1.0;
    
    juButtonPopUpLabel.font = [juButtonPopUpLabel.font fontWithSize:10];
    
    sender.juRadarPopUpLabel = juButtonPopUpLabel;
    [self.juRadarButtonsLabels addObject:juButtonPopUpLabel];
    [self.view addSubview:juButtonPopUpLabel];

    
}

- (void)tapAreaJURadarButton:(UITapGestureRecognizer *)sender {
    
    NSMutableArray* tapUsers = [[NSMutableArray alloc] init];
    
    for ( UILabel* juButtonPopUpLabel in self.juRadarButtonsLabels)
    {
        [juButtonPopUpLabel removeFromSuperview];
    }
    
    [self.juRadarButtonsLabels removeAllObjects];
    
    for (JURadarButton *btn in self.juRadarButtons)
    {
        CGPoint touchPoint = [sender locationInView:self.radarView];
        
        CGRect touchesRect = CGRectMake(touchPoint.x - TOUCHRECT_WIDTH/2, touchPoint.y - TOUCHRECT_HEIGHT/2, TOUCHRECT_WIDTH, TOUCHRECT_HEIGHT);
        
        CGRect btnRect = btn.frame;
        
        if ( CGRectIntersectsRect(touchesRect, btnRect)){
            
            [self tapJURadarButton:btn];
            [tapUsers addObject:[btn getUser]];
        }
    }
    
    [self showUserProfilesWithUsers:tapUsers];

}

- (void) showUserProfilesWithUsers:(NSMutableArray *) users
{
    [self.juRadarProfileView removeFromSuperview];
    if ([users count]){
        self.juRadarProfileView = [[JURadarProfileView alloc] initWithUsers:users];
        self.juRadarProfileView.delegate = self;
        [self.view addSubview:self.juRadarProfileView];
        self.juRadarProfileView.delegate = self;
    }
}

#pragma mark - Zoom actions

- (IBAction)zoomValueChanged:(UISlider *)sender {
    
    zoom = -sender.value;
    [self zoomJURadar];

    
}
- (IBAction)tapZoomPlusButton:(UIButton *)sender {
    
    //self.zoomSlider.value += JURADAR_ZOOMBUTTON_CHANGEZOOMVALUE;
   
    float radiusMinus25 = 1 - (JURADAR_RADIUS_MAX/((JURADAR_RADIUS_MAX/zoom) + 25));
    self.zoomSlider.value = -1 + radiusMinus25 ;
    
    [self.zoomSlider sendActionsForControlEvents:UIControlEventValueChanged];
    
}
- (IBAction)tapZoomMinusButton:(UIButton *)sender {
    
   // self.zoomSlider.value -= JURADAR_ZOOMBUTTON_CHANGEZOOMVALUE;
    float radiusMinus25 = 1 - (JURADAR_RADIUS_MAX/((JURADAR_RADIUS_MAX/zoom) - 25));
    self.zoomSlider.value = -1 + radiusMinus25 ;
    
    [self.zoomSlider sendActionsForControlEvents:UIControlEventValueChanged];
    
}

- (void) zoomJURadar
{
    self.zoomLabel.text = [NSString stringWithFormat:@"%.1f m",JURADAR_RADIUS_MAX/zoom];

    for (JURadarButton *btn in self.juRadarButtons)
    {
        [self zoomWithJURadarButton:btn];
    }
    
    [self zoomAnimationCircles];
}

- (void) zoomWithJURadarButton:(JURadarButton *) btn
{
    [self zoomAnimation:btn withZoom:zoom];
    
    CGPoint btnPoint = CGPointMake(btn.frame.origin.x + RADARUSERBUTTON_WIDTH/2,btn.frame.origin.y + RADARUSERBUTTON_HEIGHT/2 );
    
    if ( [self isPointInsiseRadar:btnPoint]){
        if (btn.hidden) self.displayedPeople++;
        btn.hidden = NO;
        btn.juRadarPopUpLabel.hidden = NO;
    } else {
        if (!btn.hidden) self.displayedPeople--;
        btn.hidden = YES;
        btn.juRadarPopUpLabel.hidden = YES;
    }
    self.onlineUsersLabel.text = [NSString stringWithFormat:@"%d",self.displayedPeople];
}


#pragma mark - JURadarProtocol

- (void) didUserOnline:(User *)user
{
    NSLog(@"NEW USER %@", user.jabberID);
    
    JURadarButton *newButton = [self createJURadarButtonWithUser:user];
    
    [self.juRadarButtons addObject:newButton];
    
    CGPoint btnPoint = CGPointMake(newButton.frame.origin.x - RADARUSERBUTTON_WIDTH/2,newButton.frame.origin.y - RADARUSERBUTTON_HEIGHT/2);
    
    if ( [self isPointInsiseRadar:btnPoint]){
        newButton.hidden = NO;
        self.displayedPeople++;
    } else {
        newButton.hidden = YES;
    }
    self.onlineUsersLabel.text = [NSString stringWithFormat:@"%d",self.displayedPeople];
}

- (void) didUserOffline:(User *)user
{
    NSLog(@" USER OFFLINE %@",user.jabberID);
    for ( JURadarButton *btn in self.juRadarButtons)
    {
        if([[btn getUser].jabberID isEqual:user.jabberID])
        {
            [btn removeFromSuperview];
            [self.juRadarButtons removeObject:btn];
            self.displayedPeople--;
            break;
        }
    }
    self.onlineUsersLabel.text = [NSString stringWithFormat:@"%d",self.displayedPeople];
}

- (void) didUserMove:(User *)user
{
    NSLog(@" USER MOVE %@",user.jabberID);
    [self didUserOffline:user];
    [self didUserOnline:user];
}

- (void)didStartLoading
{
    CGPoint touchPoint = [self.radarView convertPoint:self.centralRadarButton.center toView:self.view];
   // [SCWaveAnimationView waveAnimationAtPosition:touchPoint];
}


- (JURadarButton *) createJURadarButtonWithUser:(User *) user
{
    JURadarButton *newButton = [[JURadarButton alloc]initWithUser:user];
    
    CGPoint p = CGPointMake(newButton.coordinate.x*JURADAR_RADIUS_PX/(JURADAR_RADIUS_MAX/zoom ), newButton.coordinate.y*JURADAR_RADIUS_PX/(JURADAR_RADIUS_MAX/zoom ));
    
    newButton.frame = CGRectMake(self.centralRadarButton.center.x+p.x, self.centralRadarButton.center.y+p.y, RADARUSERBUTTON_WIDTH, RADARUSERBUTTON_HEIGHT);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(tapAreaJURadarButton:)];
    [newButton addGestureRecognizer:tap];

    [self.radarView addSubview:newButton];
    [self jumpAnimationRadarButton:newButton];

    return newButton;
    
}




- (BOOL) isPointInsiseRadar:(CGPoint) point
{
    CGPoint radarCenter = [self.centralRadarButton convertPoint:self.centralRadarButton.center toView:self.centralRadarButton];
    
    point = [self.centralRadarButton convertPoint:point toView:self.centralRadarButton];
    point.x = point.x - radarCenter.x;
    point.y = point.y - radarCenter.y;
    
    double distanceBetweenCenterAndPoint = sqrt(pow(point.x ,2) + pow(point.y ,2));
    double radiusRadarView  = self.radarView.bounds.size.height - radarCenter.y;
    
    if ( distanceBetweenCenterAndPoint > radiusRadarView )
        return NO;
    else return YES;
    
}

#pragma mark - scrollview delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSString *jID = [self.juRadarProfileView getCurrentUser].jabberID;
    
    for (UILabel* lbl in self.juRadarButtonsLabels)
    {
        if ([jID isEqualToString:lbl.text])
        {
            [self.radarView bringSubviewToFront:lbl];
            
        }
    }
}


#pragma mark - Animations

- (void) jumpAnimationRadarButton:(UIButton *) btn
{
    btn.clipsToBounds = YES;
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform"];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.duration = 0.125;
    anim.repeatCount = 1000;
    anim.autoreverses = YES;
    anim.removedOnCompletion = YES;
    anim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)];
    [btn.layer addAnimation:anim forKey:nil];
}

- (void) zoomAnimation:(JURadarButton *)btn withZoom:(double)zoom1
{
    CGPoint p = CGPointMake(btn.coordinate.x*JURADAR_RADIUS_PX/(JURADAR_RADIUS_MAX/zoom1 ), btn.coordinate.y*JURADAR_RADIUS_PX/(JURADAR_RADIUS_MAX/zoom1 ));
    CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:@"position"];
    theAnimation.duration=0.2;
    theAnimation.repeatCount=1;
    theAnimation.autoreverses=NO;
    theAnimation.removedOnCompletion = YES;
    theAnimation.fillMode = kCAFillModeForwards;
    theAnimation.timingFunction =[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    btn.frame = CGRectMake(self.centralRadarButton.center.x+p.x, self.centralRadarButton.center.y+p.y , RADARUSERBUTTON_WIDTH, RADARUSERBUTTON_HEIGHT);
    
    CGPoint convertPoint = [self.radarView convertPoint:btn.center toView:self.view];
    if (convertPoint.x > 160 ) btn.juRadarPopUpLabel.frame = CGRectMake(convertPoint.x - 80, convertPoint.y, 80, 20);
    else btn.juRadarPopUpLabel.frame = CGRectMake(convertPoint.x, convertPoint.y, 80, 20);
    //btn.juRadarPopUpLabel.frame = CGRectMake(convertPoint.x,convertPoint.y,80,20);
    [btn.layer addAnimation:theAnimation forKey:@"position"];
    [btn.juRadarPopUpLabel.layer addAnimation:theAnimation forKey:@"position"];
    
}


- (void) zoomAnimationCircles
{
    
    
    [self zoomAnimationCircle:self.circle1View WithNumber:1];
    [self zoomAnimationCircle:self.circle2View WithNumber:2];
    [self zoomAnimationCircle:self.circle3View WithNumber:3];
    [self zoomAnimationCircle:self.circle4View WithNumber:4];
    /*
    circleImage.transform = CGAffineTransformMakeScale(1.0,1.0);
    [UIView beginAnimations:@"fadeInNewView" context:NULL];
    [UIView setAnimationDuration:1.0];
    circleImage.transform = CGAffineTransformMakeScale(1.0*zoom,1*zoom);
    circleImage.center = self.centralRadarButton.center;
    [UIView commitAnimations];*/
}

- (void) zoomAnimationCircle:(UIImageView *)circle WithNumber:(NSUInteger) number
{
    CGPoint p = CGPointMake((JURADAR_RADIUS_MIN_PX*number) *  zoom, (JURADAR_RADIUS_MIN_PX*number)* zoom );
    CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:@"position"];
    theAnimation.duration=0.1;
    theAnimation.repeatCount=1;
    theAnimation.autoreverses=NO;
    theAnimation.removedOnCompletion = YES;
    theAnimation.fillMode = kCAFillModeForwards;
    theAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [circle.layer addAnimation:theAnimation forKey:@"position"];
    
    
    circle.frame = CGRectMake(self.centralRadarButton.center.x - p.x, self.centralRadarButton.center.y - p.y , p.x * 2, p.y * 2);
    if (p.x > JURADAR_RADIUS_MIN_PX*4) circle.hidden = YES;
    else circle.hidden = NO;
}

- (void) appearAnimationCircle:(UIImageView *) circleImage
{
    circleImage.transform = CGAffineTransformMakeScale(0.1,0.1);
    [UIView beginAnimations:@"fadeInNewView" context:NULL];
    [UIView setAnimationDuration:1.0];
    circleImage.transform = CGAffineTransformMakeScale(1.0*zoom,1*zoom);
    circleImage.center = self.centralRadarButton.center;
    [UIView commitAnimations];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"toJURadarTableViewController"]) {
        
        //((JURadarTableViewController *)[segue destinationViewController]).radar = self.radar;
              //  [[segue destinationViewController] setIsCurrentInterlocutor:sender];
    }
    
    if ([[segue identifier] isEqualToString:@"showChat"]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NewActiveChat" object:sender];
        [[segue destinationViewController] setIsCurrentInterlocutor:sender];
        
    }
    
    if ([[segue identifier] isEqualToString:@"showPhoto"]) {
        
        //((JURadarTableViewController *)[segue destinationViewController]).radar = self.radar;
          [[segue destinationViewController] showPhoto:sender];
    }
}

@end
