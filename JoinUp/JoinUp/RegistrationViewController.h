//
//  RegistrationViewController.h
//  ChatTestApp
//
//  Created by solid on 10.02.14.
//  Copyright (c) 2014 solid. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <CommonCrypto/CommonDigest.h>
#import "XMPPWrapper.h"
#import "NSString+hash.h"

@interface RegistrationViewController : UIViewController <UITextFieldDelegate> {
    XMPPWrapper *xmppwrapper;
}
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;

@property (weak, nonatomic) IBOutlet UITextField *txtLogin;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPassword;

@property (retain, nonatomic) NSURLConnection *connection;
@property (retain, nonatomic) NSMutableData *receiveData;

- (BOOL)CheckingInput: (NSString *)name lastname:(NSString *)lastname email:(NSString *)email
                login:(NSString *)login passwd: (NSString *)passwd confpasswd:(NSString *)confpasswd;


- (IBAction)btnSignIn:(id)sender;
- (IBAction)btnBack:(id)sender;
- (IBAction)btnNextKeybord:(id)sender;

@end
