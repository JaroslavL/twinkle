//
//  AppDelegate.h
//  JoinUp
//
//  Created by Vasily Galuzin on 10/02/14.
//  Copyright (c) 2014 Bros Universe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPWrapper.h"
#import "ManagerMessages.h"
#import "Profile.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    UIBackgroundTaskIdentifier bgTask;
    BOOL isBackground;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, readonly) BOOL isBackground;

@end
