//
//  RegistrationViewController.h
//  ChatTestApp
//
//  Created by solid on 10.02.14.
//  Copyright (c) 2014 solid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPWrapper.h"

@interface RegistrationViewController : UIViewController {
    XMPPWrapper *xmppwrapper;
}

@property (weak, nonatomic) IBOutlet UITextField *txtLogin;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

- (IBAction)btnSignIn:(id)sender;

@end
