//
//  NetworkConnection.m
//  JoinUp
//
//  Created by Vasily Galuzin on 14/02/14.
//  Copyright (c) 2014 Bros Universe. All rights reserved.
//

#import "NetworkConnection.h"

@implementation NetworkConnection

NSString *const NS_SERVER_URL = @"http://192.168.1.100/?";
NSString *const NS_ARG_ID = @"id=";
NSString *const NS_ARG_LONGITUDE = @"longitude=";
NSString *const NS_ARG_LATITUDE = @"latitude=";
NSString *const NS_ARG_PHONEID = @"tel_id=";

NSString *const NS_KEY_ID = @"id";
NSString *const NS_KEY_USERS = @"users";

NSString *const NS_TEST_GET_USERS_URL = @"http://192.168.1.100/other/index.php?login=test&longitude=0.000000&latitude=0.000000";
NSString *const NS_TEST_GET_PROFILE_URL = @"http://192.168.1.100/profile/index.php?login=";
NSString *const NS_TEST_GET_PROFILES_URL = @"http://192.168.1.100/profile/profiles.php?logins=";
//TODO: insert url to get profile data

NSString *const KEY_USERS = @"users";
NSString *const KEY_AVATAR = @"avatar";
NSString *const KEY_LAST_NAME = @"last_name";
NSString *const KEY_NAME = @"name";
NSString *const KEY_STATUS = @"status";
NSString *const KEY_LOGIN = @"login";

- (BOOL) registration {
    return YES;
}

- (BOOL) login {
    return YES;
}

- (BOOL) setProfile {
    return YES;
}

- (NSString*)formUrlGetNearbyUsers
{
    NSString *result;
    result = [NS_SERVER_URL stringByAppendingString:@"id/?jabber_id="];
    return result;
}

- (NSArray*) getNearbyUsers
{
    NSMutableArray* nearbyUsers = [[NSMutableArray alloc] init];
    
    NSString *url = NS_TEST_GET_USERS_URL;
    

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                        cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                        timeoutInterval:10];
    

    [request setHTTPMethod: @"GET"];
    
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    

    NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                                            returningResponse:&urlResponse
                                            error:&requestError];
    
    NSError *error = nil;

    NSDictionary *JSONdictionary = [NSJSONSerialization JSONObjectWithData:responseData
                                                        options: NSJSONReadingMutableContainers
                                                        error: &error];
    
    NSArray *near_users = [JSONdictionary objectForKey:@"users"];
    
    for (NSDictionary* user in near_users) {
        
        User *u = [[User alloc] init];
        
        [u setName:[user objectForKey:KEY_NAME]];
        [u setLastName:[user objectForKey:KEY_LAST_NAME]];
        [u setJabberID:[user objectForKey:KEY_LOGIN]];
        [u setAvatar:[user objectForKey:KEY_AVATAR]];
        [u setStatus:[user objectForKey:KEY_STATUS]];
        [u setCountMessages:0];
        
        id path = [user objectForKey:KEY_AVATAR];
        NSURL *url = [NSURL URLWithString:path];
        NSData *avatar = [NSData dataWithContentsOfURL:url];
        
        [u setImgAvatar:[[UIImage alloc] initWithData:avatar]];
        
        [nearbyUsers addObject:u];
    }
    
    return nearbyUsers;
    
}

- (User *) getProfile: (NSString *)jid {
    
    NSString *url = [NS_TEST_GET_PROFILE_URL stringByAppendingString:jid];
    

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                        cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                        timeoutInterval:10];
    

    [request setHTTPMethod: @"GET"];
    
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    

    NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                                            returningResponse:&urlResponse
                                            error:&requestError];
    
    NSError *error = nil;

    NSDictionary *userData = [NSJSONSerialization JSONObjectWithData:responseData
                                                  options: NSJSONReadingMutableContainers
                                                  error: &error];
    
    User *u = [[User alloc] init];
    
    for (NSDictionary* data in userData) {
        
        [u setName:[data objectForKey:KEY_NAME]];
        [u setLastName:[data objectForKey:KEY_LAST_NAME]];
        [u setJabberID:[data objectForKey:KEY_LOGIN]];
        [u setAvatar:[data objectForKey:KEY_AVATAR]];
        [u setStatus:[data objectForKey:KEY_STATUS]];
        //[u setIAmWroteMessage:NO];
        [u setCountMessages:0];
        
        id path = [data objectForKey:KEY_AVATAR];
        NSURL *url = [NSURL URLWithString:path];
        NSData *avatar = [NSData dataWithContentsOfURL:url];
        
        [u setImgAvatar:[[UIImage alloc] initWithData:avatar]];

    }
    
    return u;
}

- (NSMutableArray *) getProfiles: (NSArray *)jids {
    
    if (!jids) {
        return nil;
    }
    
    NSMutableArray* profiles = [[NSMutableArray alloc] init];
    
    NSString *url = NS_TEST_GET_PROFILES_URL;
    
    for (User *u in jids) {
        url = [url stringByAppendingFormat:@"%@,", [u jabberID]];
    }
    
    NSLog(@"%@", url);
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    
    [request setHTTPMethod: @"GET"];
    
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&urlResponse
                                                             error:&requestError];
    
    NSError *error = nil;
    
    NSDictionary *JSONdictionary = [NSJSONSerialization JSONObjectWithData:responseData
                                                                   options: NSJSONReadingMutableContainers
                                                                     error: &error];
    
    NSArray *users = [JSONdictionary objectForKey:@"users"];
    
    if (!users) {
        return nil;
    }
    
    for (NSDictionary* user in users) {
        
        User *u = [[User alloc] init];
        
        [u setName:[user objectForKey:KEY_NAME]];
        [u setLastName:[user objectForKey:KEY_LAST_NAME]];
        [u setJabberID:[user objectForKey:KEY_LOGIN]];
        [u setAvatar:[user objectForKey:KEY_AVATAR]];
        [u setStatus:[user objectForKey:KEY_STATUS]];
        [u setCountMessages:0];
        
        id path = [user objectForKey:KEY_AVATAR];
        NSURL *url = [NSURL URLWithString:path];
        NSData *avatar = [NSData dataWithContentsOfURL:url];
        
        [u setImgAvatar:[[UIImage alloc] initWithData:avatar]];
        
        [profiles addObject:u];
    }
    
    return profiles;
}



@end
