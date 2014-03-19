//
//  ProfileViewController.h
//  JoinUp
//
//  Created by solid on 18.02.14.
//  Copyright (c) 2014 Bros Universe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Profile.h"
#import "ProfileTableViewCell.h"
#import "StatusTableViewCell.h"
#import "ProfileViewer.h"
#import "NetworkConnection.h"

@interface ProfileViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISplitViewControllerDelegate, UITextFieldDelegate> {
    Profile *profile;
}

@property (readwrite, nonatomic) Profile *profile;
@property (nonatomic, strong) ProfileViewer *profileViewer;
@property (nonatomic, strong) NSArray *data;
@property (strong, nonatomic) IBOutlet UITableView *dataUser;
@property (weak, nonatomic) IBOutlet UIButton *btnSaveChanges;

- (IBAction)keyboardRetnKeyPress: (id)sender;
- (IBAction)btnSaveChanges:(id)sender;

- (void)textFieldChanged: (UITextField *)txtField;

@end
