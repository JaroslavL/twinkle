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

NSString *const NS_TEST_GET_USERS_URL = @"http://192.168.1.100/other/index.php?login=test&longitude=59.935906500&latitude=30.37689700";
NSString *const NS_TEST_GET_USERS_URL_LL = @"http://192.168.1.100/radar/index.php?login=test";
NSString *const NS_TEST_GET_USERS_URL_LL1 = @"http://192.168.1.100/other/index.php?login=test";

NSString *const NS_TEST_SET_PROFILES_URL = @"http://192.168.1.100/profile/change.php?";

NSString *const NS_TEST_GET_PROFILE_URL = @"http://192.168.1.100/profile/index.php?login=";
NSString *const NS_TEST_GET_PROFILES_URL = @"http://192.168.1.100/profile/profiles.php?";
//TODO: insert url to get profile data

NSString *const KEY_USERS = @"users";
NSString *const KEY_AVATAR = @"avatar";
NSString *const KEY_LAST_NAME = @"last_name";
NSString *const KEY_NAME = @"name";
NSString *const KEY_STATUS = @"status";
NSString *const KEY_LOGIN = @"login";
NSString *const KEY_AGE = @"age";
NSString *const KEY_EMAIL = @"email";

- (BOOL) registration {
    return YES;
}

- (BOOL) login {
    return YES;
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
        
        User *u = [[User alloc] init];
        
        [u setName:[user objectForKey:KEY_NAME]];
        [u setLastName:[user objectForKey:KEY_LAST_NAME]];
        [u setAge:[user objectForKey:KEY_AGE]];
        [u setEmail:[user objectForKey:KEY_EMAIL]];
        [u setJabberID:[user objectForKey:KEY_LOGIN]];
        [u setAvatar:[user objectForKey:KEY_AVATAR]];
        [u setStatus:[user objectForKey:KEY_STATUS]];
        [u setCountMessages:0];
        
        [u setLongitude:[user objectForKey:@"longitude"]];
        [u setLatitude:[user objectForKey:@"latitude"]];
        
        id path = [user objectForKey:KEY_AVATAR];
        NSURL *url = [NSURL URLWithString:path];
        NSData *avatar = [NSData dataWithContentsOfURL:url];
        
        [u setImgAvatar:[[UIImage alloc] initWithData:avatar]];
        
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
    
    User *u = [[User alloc] init];
    
    for (NSDictionary* data in userData) {
        
        [u setName:[data objectForKey:KEY_NAME]];
        [u setLastName:[data objectForKey:KEY_LAST_NAME]];
        [u setAge:[data objectForKey:KEY_AGE]];
        [u setEmail:[data objectForKey:KEY_EMAIL]];
        [u setJabberID:[data objectForKey:KEY_LOGIN]];
        [u setAvatar:[data objectForKey:KEY_AVATAR]];
        [u setStatus:[data objectForKey:KEY_STATUS]];
        [u setCountMessages:0];
        
        [u setLongitude:[data objectForKey:@"longitude"]];
        [u setLatitude:[data objectForKey:@"latitude"]];
        
        id path = [data objectForKey:KEY_AVATAR];
        NSURL *url = [NSURL URLWithString:path];
        NSData *avatar = [NSData dataWithContentsOfURL:url];
        
        [u setImgAvatar:[[UIImage alloc] initWithData:avatar]];
        
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
        
        User *u = [[User alloc] init];
        
        [u setName:[user objectForKey:KEY_NAME]];
        [u setLastName:[user objectForKey:KEY_LAST_NAME]];
        [u setAge:[user objectForKey:KEY_AGE]];
        [u setEmail:[user objectForKey:KEY_EMAIL]];
        [u setJabberID:[user objectForKey:KEY_LOGIN]];
        [u setAvatar:[user objectForKey:KEY_AVATAR]];
        [u setStatus:[user objectForKey:KEY_STATUS]];
        [u setCountMessages:[[jids objectAtIndex:i] countMessages]];
        
        [u setLongitude:[user objectForKey:@"longitude"]];
        [u setLatitude:[user objectForKey:@"latitude"]];
        
        id path = [user objectForKey:KEY_AVATAR];
        NSURL *url = [NSURL URLWithString:path];
        NSData *avatar = [NSData dataWithContentsOfURL:url];
        
        [u setImgAvatar:[[UIImage alloc] initWithData:avatar]];
        
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
