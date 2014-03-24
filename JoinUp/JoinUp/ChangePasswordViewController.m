//
//  ChangePasswordViewController.m
//  JoinUp
//
//  Created by solid on 21.03.14.
//  Copyright (c) 2014 Bros Universe. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController

@synthesize currentPasswd;
/*@synthesize newPasswd;
@synthesize newPasswdAgain;*/

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

- (BOOL)isMyPasswd {
    
    return [[[Profile sharedInstance] passwd] isEqualToString:[[_txtCurrentPasswd text] md5_hex]];
}

- (BOOL)isPasswdsMatch {
    
    return [[_txtNewPasswd text] isEqualToString:[_txtNewPasswdAgain text]];
}

- (IBAction)sendNewPasswd:(id)sender {
    
    if ([self isMyPasswd] && [self isPasswdsMatch]) {
        NSLog(@"Passwd send");
        
        if ([@"11" isEqualToString:[NetworkConnection setNewPasswd:[[_txtNewPasswd text] md5_hex]]]) {
            
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"Set Profile Data"
                                      message:[NSString stringWithFormat:@"Password changed"]
                                      delegate:nil
                                      cancelButtonTitle:@"Ok"
                                      otherButtonTitles:nil];
            [alertView show];
            
        } else {
            
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"Set Profile Data"
                                      message:[NSString stringWithFormat:@"Password not changet"]
                                      delegate:nil
                                      cancelButtonTitle:@"Ok"
                                      otherButtonTitles:nil];
            [alertView show];
            
        }
    } else {
        
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Set Profile Data"
                                  message:[NSString stringWithFormat:@"Password not matched"]
                                  delegate:nil
                                  cancelButtonTitle:@"Ok"
                                  otherButtonTitles:nil];
        [alertView show];
        
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
