//
//  AppDelegate.m
//  JoinUp
//
//  Created by Vasily Galuzin on 10/02/14.
//  Copyright (c) 2014 Bros Universe. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"App go to background");
    isBackground = YES;
    
    ManagerMessages *mm = [ManagerMessages sharedInstance];
    
    NSArray *saveFilePathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[NSString alloc] initWithFormat:@"%@.plist", @"UsersWhosemMessagesaArenNotRead"];
    
    NSLog(@"%@", [[saveFilePathArray objectAtIndex:0] stringByAppendingPathComponent:filePath]);
    
    if ([NSKeyedArchiver archiveRootObject:mm toFile:[[saveFilePathArray objectAtIndex:0] stringByAppendingPathComponent:filePath]]) {
        NSLog(@"write");
    }
    
     bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        // Clean up any unfinished task business by marking where you
        // stopped or ending the task outright.
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    
    // Start the long-running task and return immediately.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // Do the work associated with the task, preferably in chunks.
        while (isBackground) {
            //NSLog(@"lol");
        }
        
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    });
}

- (BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder
{
    return YES;
}

- (BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder
{
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        NSLog(@"App go to foreground");
    isBackground = NO;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"App terminate");
    
    ManagerMessages *mm = [ManagerMessages sharedInstance];
    
    NSArray *saveFilePathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[NSString alloc] initWithFormat:@"%@.plist", @"UsersWhosemMessagesaArenNotRead"];
    
    NSLog(@"%@", [[saveFilePathArray objectAtIndex:0] stringByAppendingPathComponent:filePath]);
    
    if ([NSKeyedArchiver archiveRootObject:mm toFile:[[saveFilePathArray objectAtIndex:0] stringByAppendingPathComponent:filePath]]) {
        NSLog(@"write");
    }
}

@end
