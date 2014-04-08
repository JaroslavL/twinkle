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
//1//2//3///4//
//2
//привет работй лучше
NSString *const NS_KEY_ID = @"id";
NSString *const NS_KEY_USERS = @"users";

NSString *const NS_TEST_GET_USERS_URL = @"http://192.168.1.100/other/index.php?login=test&longitude=59.935906500&latitude=30.37689700";
NSString *const NS_TEST_GET_USERS_URL_LL = @"http://192.168.1.100/radar/index.php?login=test";
NSString *const NS_TEST_GET_USERS_URL_LL1 = @"http://192.168.1.100/other/index.php?login=test";

NSString *const NS_TEST_SET_PROFILES_URL = @"http://192.168.1.100/profile/change.php?";

NSString *const NS_TEST_GET_PROFILE_URL = @"http://192.168.1.100/profile/index.php?login=";
NSString *const NS_TEST_GET_PROFILES_URL = @"http://192.168.1.100/profile/profiles.php?";
NSString *const NS_TEST_SET_OFFLINE_STATUS = @"http://192.168.1.100/logout/index.php?";

+ (BOOL) sendOfflineStatus {
    
    NSMutableData *receiveData = [[NSMutableData alloc] init];
    
    NSString *urlstr = NS_TEST_SET_OFFLINE_STATUS;
    
    urlstr = [urlstr stringByAppendingString:[NSString stringWithFormat:@"login=%@&password=%@",
                                              [[Profile sharedInstance] jabberID],
                                              [[Profile sharedInstance] passwd]]];
    
    NSURL *url = [NSURL URLWithString:[urlstr stringByAddingPercentEscapesUsingEncoding:
                                       NSUTF8StringEncoding]];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSURLResponse *response = [[NSURLResponse alloc] init];
    
    [receiveData appendData:[NSURLConnection sendSynchronousRequest:request
                                                  returningResponse:&response error:nil]];
    
    NSString *answer = [[NSString alloc] initWithData:receiveData
                                             encoding:NSUTF8StringEncoding];
    
    
    if ([answer isEqualToString:@"20"]) {
        return YES;
    } else {
        return NO;
    }
}

+ (NSString *) setProfile: (NSString *)status name: (NSString *)name lastname: (NSString *)lastname age: (NSString *)age email: (NSString *)email {
    
    NSMutableData *receiveData = [[NSMutableData alloc] init];
    
    NSString *urlstr = NS_TEST_SET_PROFILES_URL;
    
    if (status) {
        
        urlstr = [urlstr stringByAppendingString:
                  [NSString stringWithFormat:@"status=%@&", status]];
    }
    
    if (name) {
        
        urlstr = [urlstr stringByAppendingString:
                  [NSString stringWithFormat:@"name=%@&", name]];
    }
    
    if (lastname) {
        
        urlstr = [urlstr stringByAppendingString:
                  [NSString stringWithFormat:@"lastname=%@&", lastname]];
    }
    
    if (age) {
        
        urlstr = [urlstr stringByAppendingString:
                  [NSString stringWithFormat:@"age=%@&", age]];
    }
    
    if (email) {
        
        urlstr = [urlstr stringByAppendingString:
                  [NSString stringWithFormat:@"email=%@&", email]];
    }
    
    urlstr = [urlstr stringByAppendingString:
              [NSString stringWithFormat:@"login=%@&", [[Profile sharedInstance] jabberID]]];
    
    urlstr = [urlstr stringByAppendingString:
              [NSString stringWithFormat:@"password=%@&", [[Profile sharedInstance] passwd]]];
    
    NSURL *url = [NSURL URLWithString:[urlstr stringByAddingPercentEscapesUsingEncoding:
                                                NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSURLResponse *response = [[NSURLResponse alloc] init];
    
    [receiveData appendData:[NSURLConnection sendSynchronousRequest:request
                                                  returningResponse:&response error:nil]];
    
    NSString *answer = [[NSString alloc] initWithData:receiveData
                                             encoding:NSUTF8StringEncoding];
    
    return answer;
}

+ (NSString *) setNewPasswd: (NSString *) newPasswd {
    
    NSMutableData *receiveData = [[NSMutableData alloc] init];
    
    NSString *urlstr = NS_TEST_SET_PROFILES_URL;
    
    urlstr = [urlstr stringByAppendingString:
              [NSString stringWithFormat:@"login=%@&", [[Profile sharedInstance] jabberID]]];
    
    urlstr = [urlstr stringByAppendingString:
              [NSString stringWithFormat:@"password=%@&", [[Profile sharedInstance] passwd]]];
    
    urlstr = [urlstr stringByAppendingString:
              [NSString stringWithFormat:@"newpassword=%@&", newPasswd]];
    
    NSURL *url = [NSURL URLWithString:[urlstr stringByAddingPercentEscapesUsingEncoding:
                                       NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSURLResponse *response = [[NSURLResponse alloc] init];
    
    [receiveData appendData:[NSURLConnection sendSynchronousRequest:request
                                                  returningResponse:&response error:nil]];
    
    NSString *answer = [[NSString alloc] initWithData:receiveData
                                             encoding:NSUTF8StringEncoding];
    
    
    
    return answer;
}

- (NSString*)formUrlGetNearbyUsers
{
    NSString *result;
    result = [NS_SERVER_URL stringByAppendingString:@"id/?jabber_id="];
    return result;
}

+ (NSArray*) getNearbyUsers
{
    NSMutableArray* nearbyUsers = [[NSMutableArray alloc] init];
    
    //NSString *url = NS_TEST_GET_USERS_URL;
    
    CLLocationCoordinate2D coord = [[RadarLocation sharedInstance] findCurrentLocation];
    NSString *url = [NS_TEST_GET_USERS_URL_LL1 stringByAppendingString:[NSString stringWithFormat:@"&longitude=%f",coord.longitude]];
    url = [url stringByAppendingString:[NSString stringWithFormat:@"&latitude=%f",coord.latitude]];
    
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
    
    if ([near_users isEqual:[NSNull null]]) {
        return nil;
    }
    
    for (NSDictionary* user in near_users) {
        
        User *u = [[User alloc] initWithDictionary:user];
        [nearbyUsers addObject:u];
        
    }
    
    return nearbyUsers;
    
}

+ (User *) getProfile: (NSString *)jid {
    
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
    User *u;
    for (NSDictionary* data in userData) {
        
          u = [[User alloc] initWithDictionary:data];
          [u setCountMessages:0];
        
    }
    
    return u;
}

+ (NSMutableArray *) getProfiles: (NSArray *)jids {
    
    if (!jids) {
        return nil;
    }
    
    NSMutableArray* profiles = [[NSMutableArray alloc] init];
    
    NSString *url = NS_TEST_GET_PROFILES_URL;
    
    int i = 0;
    
    for (User *u in jids) {
        url = [url stringByAppendingFormat:@"logins[%d]=%@&", i, [u jabberID]];
        i++;
    }
    
    i = 0;
    
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
        
        User *u = [[User alloc] initWithDictionary:user];
        [u setCountMessages:[[jids objectAtIndex:i] countMessages]];
        [profiles addObject:u];
        
        i++;

    }
    
    return profiles;
}

+ (BOOL) sendCoordinate:(CLLocationCoordinate2D) coordinate
{
    CLLocationCoordinate2D coord = [[RadarLocation sharedInstance] findCurrentLocation];
    NSString *url = [NS_TEST_GET_USERS_URL_LL  stringByAppendingString:[NSString stringWithFormat:@"&latitude=%f",coord.latitude]];
    url = [url stringByAppendingString:[NSString stringWithFormat:@"&longitude=%f",coord.longitude]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    [request setHTTPMethod: @"GET"];
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    [NSURLConnection sendSynchronousRequest:request
                          returningResponse:&urlResponse
                                      error:&requestError];
    
    
    
    
    return YES;
}


@end
