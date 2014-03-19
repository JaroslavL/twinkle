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
    
    BOOL add = YES;
    
        NSArray *jid = [[[notification object] fromStr] componentsSeparatedByString:@"@"];
    
    for (User *u in _UsersWhosemMessagesaArenNotRead) {
        if ([[u jabberID] isEqualToString:jid[0]]) {
            add = NO;
            u.countMessages++;
            break;
        }
    }
    
    if (add) {
        
        User *u = [[User alloc] init];
        [u setJabberID:jid[0]];
        [u setCountMessages:1];
        [_UsersWhosemMessagesaArenNotRead addObject:u];
        
    }
    
}

- (BOOL)serialize {
    
    NSArray *saveFilePathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *fileName = [[NSString alloc] initWithFormat:@"%@.plist", @"UsersWhosemMessagesaArenNotRead"];
    NSString *filePath = [[saveFilePathArray objectAtIndex:0] stringByAppendingPathComponent:fileName];

    
    return [NSKeyedArchiver archiveRootObject:self toFile:filePath];
}

- (BOOL)deserialize {
    
    NSArray *saveFilePathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *fileName = [[NSString alloc] initWithFormat:@"%@.plist", @"UsersWhosemMessagesaArenNotRead"];
    NSString *filePath = [[saveFilePathArray objectAtIndex:0] stringByAppendingPathComponent:fileName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        
        [self setUsersWhosemMessagesaArenNotRead: [[NSKeyedUnarchiver unarchiveObjectWithFile:filePath] UsersWhosemMessagesaArenNotRead]];
        
    } else {
        
        if (![self serialize]) {
            NSLog(@"File not created");
            return NO;
        }
        
        NSLog(@"File create");
        NSLog(@"deserialize");
        
        [self setUsersWhosemMessagesaArenNotRead:[[NSKeyedUnarchiver unarchiveObjectWithFile:filePath] UsersWhosemMessagesaArenNotRead]];
        
    }
    
    return YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
