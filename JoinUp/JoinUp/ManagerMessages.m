//
//  ManagerMessages.m
//  JoinUp
//
//  Created by solid on 07.03.14.
//  Copyright (c) 2014 Bros Universe. All rights reserved.
//

#import "ManagerMessages.h"

@implementation ManagerMessages

static ManagerMessages* _sharedInstance;

+ (ManagerMessages *)sharedInstance {
    
    @synchronized(self) {
        
        if (!_sharedInstance) {
            _sharedInstance = [[ManagerMessages alloc] init];
        }
    }
    
    return _sharedInstance;
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(add:) name:@"NewMessage" object:nil];
        
        _UsersWhosemMessagesaArenNotRead = [[NSMutableArray alloc] init];
        
        [_UsersWhosemMessagesaArenNotRead addObjectsFromArray:[aDecoder decodeObjectForKey:@"users"]];
        
        _sharedInstance = self;
    }
    return _sharedInstance;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:_UsersWhosemMessagesaArenNotRead forKey:@"users"];
    
}

- (void)add: (NSNotification *)notification {
    
    NSLog(@"add");
    
    BOOL add = YES;
    
        NSArray *jid = [[[notification object] fromStr] componentsSeparatedByString:@"/"];
    
    for (User *u in _UsersWhosemMessagesaArenNotRead) {
        if ([[u jabberID] isEqualToString:[jid[0] componentsSeparatedByString:@"@"][0]]) {
            add = NO;
            u.countMessages++;
            break;
        }
    }
    
    if (add) {
        NSLog(@"add user");
        User *u = [[User alloc] init];
        NSArray *login = [jid[0] componentsSeparatedByString:@"@"];
        [u setJabberID:login[0]];
        [u setCountMessages:1];
        [_UsersWhosemMessagesaArenNotRead addObject:u];
    }
    
    NSLog(@"%@", _UsersWhosemMessagesaArenNotRead);
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
