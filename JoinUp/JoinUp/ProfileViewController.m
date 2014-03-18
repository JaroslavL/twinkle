//
//  ProfileViewController.m
//  JoinUp
//
//  Created by solid on 18.02.14.
//  Copyright (c) 2014 Bros Universe. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

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
    
    profile = [Profile sharedInstance];
    
    [_dataUser setDelegate:self];
    [_dataUser setDataSource:self];
    
    ProfileViewer *pv = [[ProfileViewer alloc] initWithFrame:CGRectMake(0, 65, 320, 72)];
    [pv drawRect:CGRectMake(0, 65, 320, 72)];
    [self.view addSubview:pv];
    //[[[[UIApplication sharedApplication] delegate] window] addSubview:pv];
    //[self.view insertSubview:pv belowSubview:self.view];
    //[self.navigationController.topViewController.view insertSubview:pv atIndex:5];
    //[self.view insertSubview:pv atIndex:2];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 5;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 22;
    } else return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	ProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileCell"];
    StatusTableViewCell *cellStatus = [tableView dequeueReusableCellWithIdentifier:@"StatusCell"];
    
    switch (indexPath.row) {
        case 0:
            [[cellStatus icon] setHighlighted:YES];
            [[cellStatus icon] setHighlightedImage:[UIImage imageNamed:@"heart22x22px.png"]];
            
            if ([profile status]) {
                [[cellStatus labelStatus] setText:[profile status]];
            } else {
                [[cellStatus labelStatus] setText:@"n/a"];
            }
            
            [[cellStatus labelStatus] setDelegate:self];
            return cellStatus;
        case 1:
            [[cell imgCell] setHighlighted:YES];
            [[cell imgCell] setHighlightedImage:[UIImage imageNamed:@"fullname44x44px.png"]];
            [[cell textCell] setText:[NSString stringWithFormat:@"%@ %@", [profile name], [profile lastName]]];
            [[cell textCell] setDelegate:self];
            break;
        case 2:
            [[cell imgCell] setHighlighted:YES];
            [[cell imgCell] setHighlightedImage:[UIImage imageNamed:@"years-old44x44px.png"]];
            
            if ([profile status]) {
                [[cell textCell] setText:[profile age]];
            } else {
                [[cell textCell] setText:@"n/a"];
            }
            
            [[cell textCell] setDelegate:self];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            break;
        case 3:
            [[cell imgCell] setHighlighted:YES];
            [[cell imgCell] setHighlightedImage:[UIImage imageNamed:@"email44x44px.png"]];
            [[cell textCell] setText:[profile email]];
            [[cell textCell] setDelegate:self];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            break;
        case 4:
            [[cell imgCell] setHighlighted:YES];
            [[cell imgCell] setHighlightedImage:[UIImage imageNamed:@"passwd44x44px.png"]];
            [[cell textCell] setText:@"Change Password"];
            [[cell textCell] setDelegate:self];
            [[cell textCell] setEnabled:NO];
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ProfileDetail"]) {
        /*NSIndexPath *indexPath = [self.tableNearUsers indexPathForSelectedRow];
        NSDate *object = nearbyUsers[indexPath.row];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NewActiveChat" object:object];
        [[segue destinationViewController] setIsCurrentInterlocutor:object];*/
        [segue destinationViewController];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    float moveSpeed = 0.2f;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:moveSpeed];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.view.frame = CGRectMake(0, -100.0f, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    float moveSpeed = 0.2f;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:moveSpeed];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

- (IBAction)keyboardRetnKeyPress: (id)sender {
    [sender resignFirstResponder];
}



@end
