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

@interface ProfileViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISplitViewControllerDelegate, UITextFieldDelegate> {
    Profile *profile;
}

@property (readwrite, nonatomic) Profile *profile;
@property (nonatomic, strong) NSArray *data;
@property (strong, nonatomic) IBOutlet UITableView *dataUser;

- (IBAction)keyboardRetnKeyPress: (id)sender;

@end
