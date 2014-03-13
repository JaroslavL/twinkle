//
//  TabBarController.m
//  JoinUp
//
//  Created by solid on 17.02.14.
//  Copyright (c) 2014 Bros Universe. All rights reserved.
//

#import "TabBarController.h"

@interface TabBarController ()

@end

@implementation TabBarController

@synthesize chatIsActive;

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
                                             selector:@selector(didGetNewMessageNotification:)
                                                 name:@"NewMessage"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didGetMessageReadingNotification:)
                                                 name:@"NewMessageReading"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChatDeallocNotification)
                                                 name:@"ChatDealloc"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChatAllocNotification)
                                                 name:@"ChatAlloc"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didAnotherInterlocatorNotification)
                                                 name:@"AnotherInterlocator"
                                               object:nil];
    
    chatIsActive = NO;
    
    ManagerMessages *managerMessages = [ManagerMessages sharedInstance];
    
    if ([managerMessages UsersWhosemMessagesaArenNotRead]) {
        
        for (User *u in [managerMessages UsersWhosemMessagesaArenNotRead]) {
            _countMessage += u.countMessages;
        }
        
        NSLog(@"%d", _countMessage);
        
    } else {
        
        _countMessage = 0;
        
    }
    
    if (_countMessage) {
        
        UITabBarItem *chatItem = (UITabBarItem *)[self.tabBar.items objectAtIndex:2];
        chatItem.badgeValue = [NSString stringWithFormat:@"%d", _countMessage];
        
    }

    [self setSelectedIndex:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didGetNewMessageNotification:(NSNotification *)notification {
    
    if (!chatIsActive) {
        
        NetworkConnection *nc = [[NetworkConnection alloc] init];
        NSArray *login = [[[notification object] fromStr] componentsSeparatedByString:@"@"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AnotherInterlocator" object:[nc getProfile:login[0]]];
        
        _countMessage++;
        
        UITabBarItem *chatItem = (UITabBarItem *)[self.tabBar.items objectAtIndex:2];
        chatItem.badgeValue = [NSString stringWithFormat:@"%d", _countMessage];
        
    }
}

- (void)didGetMessageReadingNotification: (NSNotification *)notification {
    
    UITabBarItem *chatItem = (UITabBarItem *)[self.tabBar.items objectAtIndex:2];
    
    _countMessage = _countMessage - [[notification object] intValue];
    
    if (_countMessage > 0) {
        
        chatItem.badgeValue = [NSString stringWithFormat:@"%d", _countMessage];
        
    } else {
        
        chatItem.badgeValue = nil;
        _countMessage = 0;
        
    }
    
}

- (void)didChatDeallocNotification {
    
    chatIsActive = NO;
    [self.tabBar setHidden:NO];
    
}

- (void)didChatAllocNotification {
    
    chatIsActive = YES;
    [self.tabBar setHidden:YES];
    
}

- (void)didAnotherInterlocatorNotification {
    
    UITabBarItem *chatItem = (UITabBarItem *)[self.tabBar.items objectAtIndex:2];
    
    if (_countMessage >= 0 && chatIsActive) {
        
        _countMessage++;
        chatItem.badgeValue = [NSString stringWithFormat:@"%d", _countMessage];
        
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
