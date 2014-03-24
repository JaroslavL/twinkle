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
    
    NSNumber *statusTag;
    NSNumber *nameTag;
    NSNumber *lastnameTag;
    NSNumber *ageTag;
    NSNumber *emailTag;
    
    NSMutableArray *changedFields;
    
    NSNumber *editableField;
    
}

@property (readwrite, nonatomic) Profile *profile;
@property (nonatomic, strong) ProfileViewer *profileViewer;
@property (nonatomic, strong) NSArray *data;
@property (strong, nonatomic) IBOutlet UITableView *dataUser;
@property (weak, nonatomic) IBOutlet UIButton *btnSaveChanges;

- (IBAction)keyboardRetnKeyPress: (id)sender;
- (IBAction)btnSaveChanges:(id)sender;

- (void)textFieldChanged: (NSNotification *)notification;

- (BOOL)CheckingInput: (NSString *)name lastname:(NSString *)lastname age: (NSString *)age email:(NSString *)email;

@end
