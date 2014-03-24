//
//  ChangePasswordViewController.h
//  JoinUp
//
//  Created by solid on 21.03.14.
//  Copyright (c) 2014 Bros Universe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+hash.h"
#import "Profile.h"
#import "NetworkConnection.h"

@interface ChangePasswordViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *txtCurrentPasswd;
@property (weak, nonatomic) IBOutlet UITextField *txtNewPasswd;
@property (weak, nonatomic) IBOutlet UITextField *txtNewPasswdAgain;

@property (nonatomic, strong) NSString *currentPasswd;
@property (nonatomic, strong) NSString *strNewPasswd;
@property (nonatomic, strong) NSString *strNewPasswdAgain;

- (BOOL)isMyPasswd;
- (BOOL)isPasswdsMatch;
- (IBAction)sendNewPasswd:(id)sender;

@end
