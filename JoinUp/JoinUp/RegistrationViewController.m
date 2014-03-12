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
    
    _txtName.delegate = self;
    _txtLastName.delegate = self;
    _txtLogin.delegate = self;
    _txtEmail.delegate = self;
    _txtPassword.delegate = self;
    _txtConfirmPassword.delegate = self;
    
    /*[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    float moveSpeed = 0.2f;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:moveSpeed];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.view.frame = CGRectMake(0, -100.0f, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
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


/*- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.2f animations:^{
        
        CGRect frame = _txtConfirmPassword.frame;
        frame.origin.y -= kbSize.height;
        _txtConfirmPassword.frame = frame;
        
        frame = bubbleTable.frame;
        frame.size.height -= kbSize.height;
        bubbleTable.frame = frame;
    }];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.2f animations:^{
        
        CGRect frame = _txtConfirmPassword.frame;
        frame.origin.y += kbSize.height;
        _txtConfirmPassword.frame = frame;
        
        frame = bubbleTable.frame;
        frame.size.height += kbSize.height;
        bubbleTable.frame = frame;
    }];
}*/

/*
 * Cheking input user's data
 */
- (BOOL)CheckingInput: (NSString *)name lastname:(NSString *)lastname email:(NSString *)email
                login:(NSString *)login passwd: (NSString *)passwd confpasswd:(NSString *)confpasswd {
    
    /* 
     * check login
     */
    NSError *error = nil;
    NSRegularExpression *expr = [NSRegularExpression regularExpressionWithPattern:@"[a-zA-Z0-9_]{4,24}"
                                                     options:NSRegularExpressionCaseInsensitive error:&error];
    
    if (error) {
        NSLog(@"Error expression");
    }
    
    NSRange rangeOfFirstMatch = [expr rangeOfFirstMatchInString:login options:0 range:NSMakeRange(0, [login length])];
    
    if (!(BOOL)(rangeOfFirstMatch.length==[login length])) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Registration"
                                  message:[NSString stringWithFormat:@"Login incorrect. Use only a-z symbols and length 4 - 24"]
                                  delegate:nil
                                  cancelButtonTitle:@"Ok"
                                  otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    
    /*
     * check name
     */
    expr = [NSRegularExpression regularExpressionWithPattern:@"[a-zA-Zа-яА-Я]{1,24}"
                                options:NSRegularExpressionCaseInsensitive error:&error];
    
    if (error) {
        NSLog(@"Error expression");
    }
    
    rangeOfFirstMatch = [expr rangeOfFirstMatchInString:name options:0 range:NSMakeRange(0, [name length])];
    
    if (!(BOOL)(rangeOfFirstMatch.length==[name length])) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Registration"
                                  message:[NSString stringWithFormat:@"Incorrect name"]
                                  delegate:nil
                                  cancelButtonTitle:@"Ok"
                                  otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    
    /*
     * check lastname
     */
    rangeOfFirstMatch = [expr rangeOfFirstMatchInString:lastname options:0 range:NSMakeRange(0, [lastname length])];
    
    if (!(BOOL)(rangeOfFirstMatch.length==[lastname length])) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Registration"
                                  message:[NSString stringWithFormat:@"Incorrect last name"]
                                  delegate:nil
                                  cancelButtonTitle:@"Ok"
                                  otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    
    /*
     * check e-mail
     */
    expr = [NSRegularExpression regularExpressionWithPattern:@"([\\w-\\.]+)@((?:[\\w]+\\.)+)([a-zA-Z]{2,4})"
                                options:NSRegularExpressionCaseInsensitive error:&error];
    
    if (error) {
        NSLog(@"Error expression");
    }
    
    rangeOfFirstMatch = [expr rangeOfFirstMatchInString:email options:0 range:NSMakeRange(0, [email length])];
    
    if (!(BOOL)(rangeOfFirstMatch.length==[email length])) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Registration"
                                  message:[NSString stringWithFormat:@"Incorrect e-mail"]
                                  delegate:nil
                                  cancelButtonTitle:@"Ok"
                                  otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    
    /*
     * check password
     */
    
    if (!(5 <= [passwd length] <= 25)) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Registration"
                                  message:[NSString stringWithFormat:@"Password length mast be from 5 to 25"]
                                  delegate:nil
                                  cancelButtonTitle:@"Ok"
                                  otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    
    if (![passwd isEqualToString:confpasswd]) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Registration"
                                  message:[NSString stringWithFormat:@"Passwords not matched"]
                                  delegate:nil
                                  cancelButtonTitle:@"Ok"
                                  otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    
    return YES;
}

- (IBAction)btnSignIn:(id)sender {
    
    if (![self CheckingInput:_txtName.text lastname:_txtLastName.text email:_txtEmail.text
                      login:_txtLogin.text passwd:_txtPassword.text confpasswd:_txtConfirmPassword.text]) {
        return;
    }
    
    [self.connection cancel];
    
    self.receiveData = [[NSMutableData alloc] init];
    
    NSString *urlstr = @"http://192.168.1.100/register/index.php?name=";
    urlstr = [urlstr stringByAppendingString:_txtName.text];
    urlstr = [urlstr stringByAppendingString:@"&last_name="];
    urlstr = [urlstr stringByAppendingString:_txtLastName.text];
    urlstr = [urlstr stringByAppendingString:@"&login="];
    urlstr = [urlstr stringByAppendingString:_txtLogin.text];
    urlstr = [urlstr stringByAppendingString:@"&e_mail="];
    urlstr = [urlstr stringByAppendingString:_txtEmail.text];
    urlstr = [urlstr stringByAppendingString:@"&password="];
    urlstr = [urlstr stringByAppendingString:[_txtPassword.text md5_hex]];
    urlstr = [urlstr stringByAppendingString:@"&password_rep="];
    urlstr = [urlstr stringByAppendingString:[_txtConfirmPassword.text md5_hex]];
    // "http://192.168.1.100/register/index.php?name=ilya&last_name=droschak&login=badsin&e_mail=droschak@mail.ru&password=12345678&password_rep=12345678"
    
    NSURL *url = [NSURL URLWithString:urlstr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSURLResponse *response = [[NSURLResponse alloc] init];
    
    [self.receiveData appendData:[NSURLConnection sendSynchronousRequest:request
                                                  returningResponse:&response error:nil]];
    
    NSString *answer = [[NSString alloc] initWithData:self.receiveData
                                         encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", answer);
    
    if ([answer isEqualToString:@"1"]) {
        
        //TODO: add info about user into vcard
        
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Registration"
                                  message:[NSString stringWithFormat:@"Registration complited"]
                                  delegate:nil
                                  cancelButtonTitle:@"Ok"
                                  otherButtonTitles:nil];
        [alertView show];
        
        [self performSegueWithIdentifier:@"ViewController" sender:self];
        
    } else if ([answer isEqualToString:@"2"]) {
        
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Registration"
                                  message:[NSString stringWithFormat:@"This login is already exists"]
                                  delegate:nil
                                  cancelButtonTitle:@"Ok"
                                  otherButtonTitles:nil];
        [alertView show];
        
    } else if ([answer isEqualToString:@"3"]) {
        
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Registration"
                                  message:[NSString stringWithFormat:@"This mail is already exists"]
                                  delegate:nil
                                  cancelButtonTitle:@"Ok"
                                  otherButtonTitles:nil];
        [alertView show];
        
    } else if ([answer isEqualToString:@"5"]) {
        
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Registration"
                                  message:[NSString stringWithFormat:@"User's catalog is not created"]
                                  delegate:nil
                                  cancelButtonTitle:@"Ok"
                                  otherButtonTitles:nil];
        [alertView show];
        
    }
}

- (IBAction)btnBack:(id)sender {
    [self performSegueWithIdentifier:@"ViewController" sender:self];
}

- (IBAction)btnNextKeybord:(id)sender {
    [sender resignFirstResponder];
}

@end
