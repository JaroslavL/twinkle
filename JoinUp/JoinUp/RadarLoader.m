//
//  RadarLoader.m
//  JoinUp
//
//  Created by Andrew on 24/03/14.
//  Copyright (c) 2014 Bros Universe. All rights reserved.
//

#import "RadarLoader.h"
#import <CoreLocation/CoreLocation.h>
#import "RadarLocation.h"

@implementation RadarLoader

NSString *const NS_TEST_GET_USERS_URL_LL11 = @"http://192.168.1.100/other/index.php?login=test";
NSString *const KEY_USERS1 = @"users";
NSString *const KEY_AVATAR1 = @"avatar";
NSString *const KEY_LAST_NAME1 = @"last_name";
NSString *const KEY_NAME1 = @"name";
NSString *const KEY_STATUS1 = @"status";
NSString *const KEY_LOGIN1 = @"login";
NSString *const KEY_AGE1 = @"age";
NSString *const KEY_EMAIL1 = @"email";

@synthesize delegate, index;

- (void)loadNearUsers{
    
    NSLog(@"Start load");

    CLLocationCoordinate2D coord = [[RadarLocation sharedInstance] findCurrentLocation];
    NSString *url = [NS_TEST_GET_USERS_URL_LL11 stringByAppendingString:[NSString stringWithFormat:@"&longitude=%f",coord.longitude]];
    url = [url stringByAppendingString:[NSString stringWithFormat:@"&latitude=%f",coord.latitude]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    
    [request setHTTPMethod: @"GET"];
    
    NSURLConnection *newConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (newConnection) {
        activeDownloadData = [NSMutableData data];
    }
    
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [activeDownloadData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [activeDownloadData appendData:data]; 
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    

     NSLog(@"Finish load");
    NSMutableArray* nearbyUsers = [[NSMutableArray alloc] init];
    
    NSError *error = nil;
    
    NSDictionary *JSONdictionary = [NSJSONSerialization JSONObjectWithData: activeDownloadData
                                                                   options: NSJSONReadingMutableContainers
                                                                     error: &error];
    
    NSArray *near_users = [JSONdictionary objectForKey:@"users"];
    
    if ([near_users isEqual:[NSNull null]]) {
        if (delegate != nil) {
            [delegate  nearUserDidLoad:nearbyUsers];
        }
        else {
            activeDownloadData = nil;
            NSLog(@"Can't find delegate for radarLoader");
        }

        return;
    }
    
    for (NSDictionary* user in near_users) {
        
        User *u = [[User alloc] init];
        
        [u setName:[user objectForKey:KEY_NAME1]];
        [u setLastName:[user objectForKey:KEY_LAST_NAME1]];
        [u setAge:[user objectForKey:KEY_AGE1]];
        [u setEmail:[user objectForKey:KEY_EMAIL1]];
        [u setJabberID:[user objectForKey:KEY_LOGIN1]];
        [u setAvatar:[user objectForKey:KEY_AVATAR1]];
        [u setStatus:[user objectForKey:KEY_STATUS1]];
        [u setCountMessages:0];
        
        [u setLongitude:[user objectForKey:@"longitude"]];
        [u setLatitude:[user objectForKey:@"latitude"]];
        
        id path = [user objectForKey:KEY_AVATAR1];
        NSURL *url = [NSURL URLWithString:path];
        NSData *avatar = [NSData dataWithContentsOfURL:url];
        
        [u setImgAvatar:[[UIImage alloc] initWithData:avatar]];
        
        [nearbyUsers addObject:u];
    }

    if (delegate != nil) {
        [delegate  nearUserDidLoad:nearbyUsers]; // Вызываем метод делегата
    }
    else {
        activeDownloadData = nil;
        NSLog(@"Can't find delegate for radarLoader");
    }
}


@end
 

