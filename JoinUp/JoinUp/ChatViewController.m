//
//  ChatViewController.m
//  JoinUp
//
//  Created by solid on 11.02.14.
//  Copyright (c) 2014 Bros Universe. All rights reserved.
//

#import "ChatViewController.h"

@interface ChatViewController () {
    IBOutlet UIBubbleTableView *bubbleTable;
    
    NSMutableArray *bubbleData;
}

@end

@implementation ChatViewController

@synthesize xmppwrapper;

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveMessage:)
                                                 name:@"NewMessage"
                                               object:nil];
    
    xmppwrapper = [XMPPWrapper sharedInstance];
    
    profile = [Profile sharedInstance];
    
    //xmppwrapper.delegate = self;
    
    /*NSBubbleData *heyBubble = [NSBubbleData dataWithText:@"Hey, halloween is soon" date:[NSDate dateWithTimeIntervalSinceNow:-300] type:BubbleTypeSomeoneElse];
    heyBubble.avatar = nil; //[UIImage imageNamed:@"avatar1.png"];
    
    //NSBubbleData *photoBubble = [NSBubbleData dataWithImage:[UIImage imageNamed:@"halloween.jpg"] date:[NSDate dateWithTimeIntervalSinceNow:-290] type:BubbleTypeSomeoneElse];
    //photoBubble.avatar = [UIImage imageNamed:@"avatar1.png"];
    
    NSBubbleData *replyBubble = [NSBubbleData dataWithText:@"Wow.. Really cool picture out there. iPhone 5 has really nice camera, yeah?" date:[NSDate dateWithTimeIntervalSinceNow:-5] type:BubbleTypeMine];
    replyBubble.avatar = nil;*/
    
    bubbleData = [[NSMutableArray alloc] init];
    bubbleTable.bubbleDataSource = self;
    
    [self showHistoryMessage:[xmppwrapper loadArchiveMessage:[[_isCurrentInterlocutor jabberID] stringByAppendingString:@"@shiva"]
                                                           i:[[profile jabberID] stringByAppendingString:@"@shiva"]]];
    
    managerMessages = [ManagerMessages sharedInstance];
    
    for (User *u in [managerMessages UsersWhosemMessagesaArenNotRead]) {
        
        if ([[u jabberID] isEqualToString:[_isCurrentInterlocutor jabberID]]) {
            
            [[managerMessages UsersWhosemMessagesaArenNotRead] removeObject:u];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NewMessageReading"
                                                  object:[[NSNumber alloc] initWithInt:[u countMessages]]];
            break;
            
        }
        
    }
    

    
    // The line below sets the snap interval in seconds. This defines how the bubbles will be grouped in time.
    // Interval of 120 means that if the next messages comes in 2 minutes since the last message, it will be added into the same group.
    // Groups are delimited with header which contains date and time for the first message in the group.
    
    bubbleTable.snapInterval = 120;
    
    // The line below enables avatar support. Avatar can be specified for each bubble with .avatar property of NSBubbleData.
    // Avatars are enabled for the whole table at once. If particular NSBubbleData misses the avatar, a default placeholder will be set (missingAvatar.png)
    
    //bubbleTable.showAvatars = YES;
    
    // Uncomment the line below to add "Now typing" bubble
    // Possible values are
    //    - NSBubbleTypingTypeSomebody - shows "now typing" bubble on the left
    //    - NSBubbleTypingTypeMe - shows "now typing" bubble on the right
    //    - NSBubbleTypingTypeNone - no "now typing" bubble
    
    //bubbleTable.typingBubble = NSBubbleTypingTypeSomebody;
    
    [bubbleTable reloadData];
     
    [[self navigationItem] setTitle:@"Chat"];
    [[self navigationItem] setPrompt:[@"Chat with " stringByAppendingString:[_isCurrentInterlocutor jabberID]]];
    
    // Keyboard events
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)setIsCurrentInterlocutor:(User *)newInterlocutor
{
    if (_isCurrentInterlocutor != newInterlocutor) {
        _isCurrentInterlocutor = newInterlocutor;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewMessageReading" object:[[NSNumber alloc] initWithInt:[_isCurrentInterlocutor countMessages]]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChatAlloc" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    
}

- (void)sendMessage:(NSString *)msgContent {
    NSLog(@"Send message %@", msgContent);
    
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
	[body setStringValue:msgContent];
	
	NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    [message addAttributeWithName:@"to" stringValue:[[_isCurrentInterlocutor jabberID] stringByAppendingString:@"@shiva"]];
	[message addChild:body];
    
    [xmppwrapper sendMessage:message];
}

- (void)receiveMessage:(NSNotification *)notification {
    
    //TODO: normal get jid
    NSArray *jid = [[[notification object] fromStr] componentsSeparatedByString:@"/"];
    
    if ([[[_isCurrentInterlocutor jabberID] stringByAppendingString:@"@shiva"] isEqualToString:jid[0]]) {
        
        bubbleTable.typingBubble = NSBubbleTypingTypeNobody;
        NSBubbleData *sayBubble = [NSBubbleData dataWithText:[[notification object] body] date:[NSDate dateWithTimeIntervalSinceNow:0] type:BubbleTypeSomeoneElse];
        [bubbleData addObject:sayBubble];
        [bubbleTable reloadData];
        [bubbleTable scrollBubbleViewToBottomAnimated:YES];
        
    } else {
        
        //TODO: make NC singleton or init him in viewDidLoad
        NetworkConnection *nc = [[NetworkConnection alloc] init];
        NSArray *login = [jid[0] componentsSeparatedByString:@"@"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AnotherInterlocator" object:[nc getProfile:login[0]]];
        
    }
}

- (void)showHistoryMessage:(NSArray *)messages {
    
    if (!messages) {
        //TODO: Show message about empty history
        return;
    }
        
        for (XMPPMessageArchiving_Message_CoreDataObject *message in messages) {
            
            NSXMLElement *element = [[NSXMLElement alloc] initWithXMLString:message.messageStr error:nil];
            
            if (![[element attributeStringValueForName:@"to"] isEqualToString:[[_isCurrentInterlocutor jabberID] stringByAppendingString:@"@shiva"]]) {
                
                NSBubbleData *sayBubble = [NSBubbleData dataWithText:[message body] date:[NSDate dateWithTimeIntervalSinceNow:0] type:BubbleTypeSomeoneElse];
                [bubbleData addObject:sayBubble];
                
            } else {
                
                NSBubbleData *sayBubble = [NSBubbleData dataWithText:[message body] date:[NSDate dateWithTimeIntervalSinceNow:0] type:BubbleTypeMine];
                [bubbleData addObject:sayBubble];
            }
        }
    
    [bubbleTable reloadData];
    [bubbleTable scrollBubbleViewToBottomAnimated:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - UIBubbleTableViewDataSource implementation

- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView
{
    return [bubbleData count];
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row
{
    return [bubbleData objectAtIndex:row];
}

#pragma mark - Keyboard events

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.2f animations:^{
        
        CGRect frame = _txtMessage.frame;
        frame.origin.y -= kbSize.height;
        _txtMessage.frame = frame;
        
        frame = bubbleTable.frame;
        frame.size.height -= kbSize.height;
        bubbleTable.frame = frame;
    }];
    
    [bubbleTable scrollBubbleViewToBottomAnimated:YES];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.2f animations:^{
        
        CGRect frame = _txtMessage.frame;
        frame.origin.y += kbSize.height;
        _txtMessage.frame = frame;
        
        frame = bubbleTable.frame;
        frame.size.height += kbSize.height;
        bubbleTable.frame = frame;
    }];
}

#pragma mark - Actions

- (IBAction)btnDisconnect:(id)sender {
    [xmppwrapper disconnect];
}

- (IBAction)btnSendMessage:(id)sender {
    [self sendMessage:_txtMessage.text];
    
    NSBubbleData *sayBubble = [NSBubbleData dataWithText:_txtMessage.text date:[NSDate dateWithTimeIntervalSinceNow:0] type:BubbleTypeMine];
    [bubbleData addObject:sayBubble];
    [bubbleTable reloadData];
    [bubbleTable scrollBubbleViewToBottomAnimated:YES];
    
    _txtMessage.text = @"";
    [_txtMessage resignFirstResponder];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChatDealloc" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
