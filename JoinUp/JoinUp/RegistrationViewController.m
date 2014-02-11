//
//  RegistrationViewController.m
//  ChatTestApp
//
//  Created by solid on 10.02.14.
//  Copyright (c) 2014 solid. All rights reserved.
//

#import "RegistrationViewController.h"

@interface RegistrationViewController ()

@end

@implementation RegistrationViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"joinup"])
    {
        //[[segue destinationViewController] setText:@"SecondViewController"];
        //NSLog(@"joinup segue");
    }
    else
    {
        [super prepareForSegue:segue sender:sender];
    }
}

- (IBAction)btnSignIn:(id)sender {
    xmppwrapper = [[XMPPWrapper alloc] initWithUserData:_txtLogin.text andPasswd:_txtPassword.text andHostName:@"192.168.1.100"];
    xmppwrapper.REGISTER = YES;
    [xmppwrapper connect];
    //[xmppwrapper registration];
}
@end
