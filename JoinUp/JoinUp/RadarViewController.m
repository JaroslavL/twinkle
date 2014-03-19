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

#define CENTRAL_POSITION_X 160
#define CENTRAL_POSITION_Y 300

@interface RadarViewController ()

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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    buttonArray = [NSMutableArray new];
    profileViewer = [[ProfileViewer alloc]init];
    profileViewer.delegate = self;
    [self.view addSubview:profileViewer];
    [NSTimer scheduledTimerWithTimeInterval:5.0f
                                     target:self
                                   selector:@selector(updateRadar)
                                   userInfo:nil
                                    repeats:YES];
    
    profileViewer.hidden =YES;
    
    //TODO: get near users every time
    
    [self drawRadarPoints];
    
    [_tableNearUsers setDelegate:self];
    [_tableNearUsers setDataSource:self];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [nearbyUsers count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UIUserCellTableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"NewCurrent" object:selectedCell.userLogin];
    //self.chatViewController.isCurrentInterlocutor = selectedCell.userLogin;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UIUserCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
	User *user = [self.nearbyUsers objectAtIndex:indexPath.row];
    [cell setUserLogin:[user jabberID]];
    [[cell userNameLabel] setText:[user name]];
    //cell.userAvatarImageView.image = [user imgAvatar];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showChat"]) {
        
        /// NSIndexPath *indexPath = [self.tableNearUsers indexPathForSelectedRow];
        NSDate *object = sender;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NewActiveChat" object:object];
        [[segue destinationViewController] setIsCurrentInterlocutor:sender];
    }
}

- (void) drawRadarPoints
{
    /*
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
     (unsigned long)NULL), ^(void) {
     nearbyUsers = [NetworkConnection getNearbyUsers];
     [self createButtonArrayWithUsers:nearbyUsers];
     });*/
    nearbyUsers = [NetworkConnection getNearbyUsers];
    [self createButtonArrayWithUsers:nearbyUsers];
    [self displayButtonArray];
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
    [self.view setNeedsDisplay];
    
    [self drawRadarPoints];
}

- (void) createButtonArrayWithUsers:(NSArray *) users
{
    for (User *user in users)
    {
        RadarUserLocationButton *newButton = [[RadarUserLocationButton alloc]initWithUser:user];
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
        btn.frame = CGRectMake(CENTRAL_POSITION_X+btn.coordinate.x, CENTRAL_POSITION_Y+btn.coordinate.y, 10, 10);
        [self.view addSubview:btn];
    }
    
}

- (void) tapRadarUserLocationButton:(RadarUserLocationButton*) sender
{
    [profileViewer showUserProfile:[sender getUser]];
    profileViewer.hidden = NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:touch.view];
    if (location.y < 73 ) return;
    [profileViewer setHidden:YES];
}

@end
