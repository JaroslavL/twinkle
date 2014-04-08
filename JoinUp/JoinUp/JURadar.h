//
//  JURadar.h
//  JURadar
//
//  Created by Andrew on 02/04/14.
//  Copyright (c) 2014 Bros Universe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkConnection.h"

@protocol JURadarProtocol;


@interface JURadar : NSObject

@property (nonatomic, assign) id <JURadarProtocol> delegate;

- (void) startRadar;
- (void) stopRadar;
- (NSArray *) getAllUsers;

@end

@protocol  JURadarProtocol

- (void) didStartLoading;
- (void) didUserOffline: (User *) user;
- (void) didUserOnline: (User *) user;
- (void) didUserMove: (User *) user;

@end