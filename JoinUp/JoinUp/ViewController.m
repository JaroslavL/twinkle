//
//  ViewController.m
//  ChatTestApp
//
//  Created by solid on 06.02.14.
//  Copyright (c) 2014 solid. All rights reserved.
//

#import "ViewController.h"
#import "XMPP.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
    
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// http://192.168.1.100/auth/index.php?login=badsin&password=droschak

- (IBAction)btnConnect:(id)sender {
    
    //TODO: isert tis code into NetworkCommunication
    
    [self.connection cancel];
    
    self.receiveData = [[NSMutableData alloc] init];
    
    NSString *urlstr = @"http://192.168.1.100/auth/index.php?login=";
    urlstr = [urlstr stringByAppendingString:_txtUserName.text];
    urlstr = [urlstr stringByAppendingString:@"&password="];
    urlstr = [urlstr stringByAppendingString:[_txtUserPassword.text md5_hex]];
    
    NSURL *url = [NSURL URLWithString:urlstr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSURLResponse *response = [[NSURLResponse alloc] init];
    
    [self.receiveData appendData:[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil]];
    
    NSString *answer = [[NSString alloc] initWithData:self.receiveData
                                              encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", answer);
    
    if ([answer isEqualToString:@"4"]) {
        xmppwrapper = [[XMPPWrapper alloc] initWithUserData:[_txtUserName.text stringByAppendingString:@"@shiva"]
                                           andPasswd:_txtUserPassword.text
                                           andHostName:@"192.168.1.100"];
        if ([xmppwrapper connect]) {
            
            NetworkConnection *nc = [[NetworkConnection alloc] init];
            profile = [[Profile alloc] initWithUserData:[nc getProfile:_txtUserName.text]];
            
            NSArray *saveFilePathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *filePath = [[NSString alloc] initWithFormat:@"%@.plist", @"UsersWhosemMessagesaArenNotRead"];
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:[[saveFilePathArray objectAtIndex:0] stringByAppendingPathComponent:filePath]]) {
                
                managerMessage = [NSKeyedUnarchiver unarchiveObjectWithFile:[[saveFilePathArray objectAtIndex:0] stringByAppendingPathComponent:filePath]];
                
                NSLog(@"exist");
                NSLog(@"%@", [managerMessage UsersWhosemMessagesaArenNotRead]);
                
            } else {
                
                [[NSFileManager defaultManager] createFileAtPath:[[saveFilePathArray objectAtIndex:0] stringByAppendingPathComponent:filePath]
                                                        contents:nil
                                                      attributes:nil];
                
                NSLog(@"file create");
                
                managerMessage = [NSKeyedUnarchiver unarchiveObjectWithFile:[[saveFilePathArray objectAtIndex:0] stringByAppendingPathComponent:filePath]];
                
                //managerMessage = [[ManagerMessages alloc] init];
                
                if (managerMessage) {
                    NSLog(@"not nil");
                }
                
            }
            
            [self performSegueWithIdentifier:@"TabBarController" sender:self];
            
        } else {
            
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"Connection"
                                      message:[NSString stringWithFormat:@"Connaction faild"]
                                      delegate:nil
                                      cancelButtonTitle:@"Ok"
                                      otherButtonTitles:nil];
            [alertView show];
            
        }
    } else {
        
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Auth"
                                  message:[NSString stringWithFormat:@"You not register"]
                                  delegate:nil
                                  cancelButtonTitle:@"Ok"
                                  otherButtonTitles:nil];
        [alertView show];
        
    }
}

- (IBAction)btnRegistration:(id)sender {
    [self performSegueWithIdentifier:@"RegistrationViewController" sender:self];
}
@end
