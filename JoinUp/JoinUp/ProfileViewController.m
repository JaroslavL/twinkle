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
    
    _profileViewer = [[ProfileViewer alloc] init];
    _profileViewer.delegate = self;
    [_profileViewer showProfile:profile];
    [self.view addSubview:_profileViewer];
    
    [[self btnSaveChanges] setEnabled:NO];
    
    statusTag = [[NSNumber alloc] initWithInt:0];
    nameTag   = [[NSNumber alloc] initWithInt:1];
    lastnameTag = [[NSNumber alloc] initWithInt:2];
    ageTag    = [[NSNumber alloc] initWithInt:3];
    emailTag  = [[NSNumber alloc] initWithInt:4];
    
    changedFields = [[NSMutableArray alloc] init];
    
    editableField = [[NSNumber alloc] init];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
}

- (void)viewDidDisappear:(BOOL)animated {
    /*_profileViewer.avatar = nil;
    if (![_profileViewer avatar]) {
        NSLog(@"nil");
    }
    _profileViewer = nil;*/
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
    return 6;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath.row) {
        return 22;
    } else return 44;
}*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	ProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileCell"];
    StatusTableViewCell *cellStatus = [tableView dequeueReusableCellWithIdentifier:@"StatusCell"];
    
    switch (indexPath.row) {
        case 0:
            [[cellStatus imageView] setImage:[UIImage imageNamed:@"heart22x22px.png"]];
            
            if ([profile status]) {
                [[cellStatus textStatus] setText:[profile status]];
            } else {
                [[cellStatus textStatus] setText:@"n/a"];
            }
            
            [[cellStatus textStatus] setDelegate:self];
            [[cellStatus textStatus] setTag:[statusTag intValue]];
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(textFieldChanged:)
                                                         name:UITextFieldTextDidChangeNotification
                                                       object:[cellStatus textStatus]];
            return cellStatus;
        case 1:
            [[cell imageView] setImage:[UIImage imageNamed:@"fullname44x44px.png"]];
            [[cell textCell] setText:[profile name]];
            [[cell textCell] setDelegate:self];
            [[cell textCell] setTag:[nameTag intValue]];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(textFieldChanged:)
                                                         name:UITextFieldTextDidChangeNotification
                                                       object:[cell textCell]];
            
            break;
        case 2:
            [[cell imageView] setImage:[UIImage imageNamed:@"fullname44x44px.png"]];
            [[cell textCell] setText:[profile lastName]];
            [[cell textCell] setDelegate:self];
            [[cell textCell] setTag:[lastnameTag intValue]];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(textFieldChanged:)
                                                         name:UITextFieldTextDidChangeNotification
                                                       object:[cell textCell]];
            
            break;
        case 3:
            [[cell imageView] setImage:[UIImage imageNamed:@"years-old44x44px.png"]];
            if (![[profile age] isEqualToString:@"0"]) {
                [[cell textCell] setText:[profile age]];
            } else {
                [[cell textCell] setText:@"Set you age"];
            }
            
            [[cell textCell] setDelegate:self];
            [[cell textCell] setTag:[ageTag intValue]];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(textFieldChanged:)
                                                         name:UITextFieldTextDidChangeNotification
                                                       object:[cell textCell]];
            
            break;
        case 4:
            [[cell imageView] setImage:[UIImage imageNamed:@"email44x44px.png"]];
            [[cell textCell] setText:[profile email]];
            [[cell textCell] setDelegate:self];
            [[cell textCell] setTag:[emailTag intValue]];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(textFieldChanged:)
                                                         name:UITextFieldTextDidChangeNotification
                                                       object:[cell textCell]];
            
            break;
        case 5:
            [[cell imageView] setImage:[UIImage imageNamed:@"passwd44x44px.png"]];
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
    if ([[segue identifier] isEqualToString:@"showPhoto"]) {
        [[segue destinationViewController] showPhoto:sender];
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
    
    editableField = [NSNumber numberWithInt:[textField tag]];
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

- (IBAction)btnSaveChanges:(id)sender {
    
    [[self btnSaveChanges] setEnabled:NO];
    
    NSString *status;
    NSString *name;
    NSString *lastname;
    NSString *age;
    NSString *email;
    
    for (NSNumber *object in changedFields) {
        
        switch ([object intValue]) {
            case 0:
                status = [[(StatusTableViewCell *)
                           [_dataUser cellForRowAtIndexPath:
                                      [NSIndexPath indexPathForRow:0 inSection:0]] textStatus] text];
                break;
            case 1:
                name = [[(ProfileTableViewCell *)
                        [_dataUser cellForRowAtIndexPath:
                                   [NSIndexPath indexPathForRow:1 inSection:0]] textCell] text];
                break;
            case 2:
                lastname = [[(ProfileTableViewCell *)
                          [_dataUser cellForRowAtIndexPath:
                                     [NSIndexPath indexPathForRow:2 inSection:0]] textCell] text];
                break;
            case 3:
                age = [[(ProfileTableViewCell *)
                             [_dataUser cellForRowAtIndexPath:
                              [NSIndexPath indexPathForRow:3 inSection:0]] textCell] text];
                break;
            case 4:
                email = [[(ProfileTableViewCell *)
                             [_dataUser cellForRowAtIndexPath:
                              [NSIndexPath indexPathForRow:4 inSection:0]] textCell] text];
                break;
                
            default:
                break;
        }
        
    }
    
    if ([self CheckingInput:name lastname:lastname age:age email:email]) {
        
        if ([[NetworkConnection setProfile:status
                                name:name
                                lastname:lastname
                                age:age
                                email:email] isEqualToString:@"11"]) {
            
            for (NSNumber *object in changedFields) {
                
                switch ([object intValue]) {
                    case 0:
                        [[Profile sharedInstance] setStatus:status];
                        break;
                    case 1:
                        [[Profile sharedInstance] setName:name];
                        break;
                    case 2:
                        [[Profile sharedInstance] setLastName:lastname];
                        break;
                    case 3:
                        [[Profile sharedInstance] setAge:age];
                        break;
                    case 4:
                        [[Profile sharedInstance] setEmail:email];
                        break;
                        
                    default:
                        break;
                }
            }
            
            [_profileViewer showProfile:profile];
        
            status = nil;
            name   = nil;
            lastname = nil;
            age = nil;
            email = nil;
        
            [changedFields removeAllObjects];
            
        }
        
    }
    
}

- (void)textFieldChanged: (NSNotification *)notification {
    
    if ([editableField intValue] == [[notification object] tag]) {
        
        editableField = [NSNumber numberWithInt:-1];
        
        [[self btnSaveChanges] setEnabled:YES];
        
        if ([[notification object] tag] == [statusTag intValue]) {
            if (![changedFields containsObject:statusTag]) {
                [changedFields addObject:statusTag];
            }
        }
        
        if ([[notification object] tag] == [nameTag intValue]) {
            if (![changedFields containsObject:nameTag]) {
                [changedFields addObject:nameTag];
            }
        }
        if ([[notification object] tag] == [lastnameTag intValue]) {
            if (![changedFields containsObject:lastnameTag]) {
                [changedFields addObject:lastnameTag];
            }
        }
        
        if ([[notification object] tag] == [ageTag intValue]) {
            if (![changedFields containsObject:ageTag]) {
                [changedFields addObject:ageTag];
            }
        }
        
        if ([[notification object] tag] == [emailTag intValue]) {
            if (![changedFields containsObject:emailTag]) {
                [changedFields addObject:emailTag];
            }
        }
    }
}

/*
 * Cheking input user's data
 */
- (BOOL)CheckingInput: (NSString *)name lastname:(NSString *)lastname age: (NSString *)age email:(NSString *)email {
    
    NSError *error = nil;
    NSRegularExpression *expr;
    NSRange rangeOfFirstMatch;
    
    if (name) {
        
        /*
         * check name
         */
        expr = [NSRegularExpression regularExpressionWithPattern:@"[a-zA-Zа-яА-Я]{1,24}"
                                    options:NSRegularExpressionCaseInsensitive
                                    error:&error];
        
        if (error) {
            NSLog(@"Error expression");
        }
        
        rangeOfFirstMatch = [expr rangeOfFirstMatchInString:name
                                                    options:0
                                                    range:NSMakeRange(0, [name length])];
        
        if (!(BOOL)(rangeOfFirstMatch.length==[name length])) {
            
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"Set Profile data"
                                      message:[NSString stringWithFormat:@"Incorrect name"]
                                      delegate:nil
                                      cancelButtonTitle:@"Ok"
                                      otherButtonTitles:nil];
            [alertView show];
            return NO;
            
        }
        
    }
    
    if (lastname) {
        
        /*
         * check lastname
         */
        
        expr = [NSRegularExpression regularExpressionWithPattern:@"[a-zA-Zа-яА-Я]{1,24}"
                                    options:NSRegularExpressionCaseInsensitive
                                    error:&error];
        
        if (error) {
            NSLog(@"Error expression");
        }
        
        rangeOfFirstMatch = [expr rangeOfFirstMatchInString:lastname
                                  options:0
                                  range:NSMakeRange(0, [lastname length])];
        
        if (!(BOOL)(rangeOfFirstMatch.length==[lastname length])) {
            
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"Set Profile Data"
                                      message:[NSString stringWithFormat:@"Incorrect last name"]
                                      delegate:nil
                                      cancelButtonTitle:@"Ok"
                                      otherButtonTitles:nil];
            [alertView show];
            return NO;
            
        }
        
    }
    
    if (age) {
        
        /*
         * check age
         */
        
        expr = [NSRegularExpression regularExpressionWithPattern:@"[0-9]{1,2}"
                                    options:NSRegularExpressionCaseInsensitive
                                    error:&error];
        
        if (error) {
            NSLog(@"Error expression");
        }
        
        rangeOfFirstMatch = [expr rangeOfFirstMatchInString:age
                                  options:0
                                  range:NSMakeRange(0, [age length])];
        
        if (!(BOOL)(rangeOfFirstMatch.length==[age length])) {
            
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"Set Profile Data"
                                      message:[NSString stringWithFormat:@"Incorrect age"]
                                      delegate:nil
                                      cancelButtonTitle:@"Ok"
                                      otherButtonTitles:nil];
            [alertView show];
            return NO;
            
        }
        
    }
    
    if (email) {
        
        /*
         * check e-mail
         */
        expr = [NSRegularExpression regularExpressionWithPattern:@"([\\w-\\.]+)@((?:[\\w]+\\.)+)([a-zA-Z]{2,4})"
                                    options:NSRegularExpressionCaseInsensitive
                                    error:&error];
        
        if (error) {
            NSLog(@"Error expression");
        }
        
        rangeOfFirstMatch = [expr rangeOfFirstMatchInString:email
                                  options:0
                                  range:NSMakeRange(0, [email length])];
        
        if (!(BOOL)(rangeOfFirstMatch.length==[email length])) {
            
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"set Profile Data"
                                      message:[NSString stringWithFormat:@"Incorrect e-mail"]
                                      delegate:nil
                                      cancelButtonTitle:@"Ok"
                                      otherButtonTitles:nil];
            [alertView show];
            return NO;
            
        }
        
    }
    
    return YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
