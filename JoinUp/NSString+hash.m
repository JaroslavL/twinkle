//
//  NSString+hash.m
//  JoinUp
//
//  Created by solid on 13.02.14.
//  Copyright (c) 2014 Bros Universe. All rights reserved.
//

#import "NSString+hash.h"

@implementation NSString (hash)

- (NSString *) md5_hex {
    const char* _data = [self UTF8String];
    unsigned char hashBuffer[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(_data, strlen(_data), hashBuffer);
    
    NSMutableString *md5result = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for (int i= 0;	i < CC_MD5_DIGEST_LENGTH; i++)
        [md5result	appendFormat:@"%02X", hashBuffer[i]];
    
    return md5result;
}

@end
