//
//  NSString+hash.h
//  JoinUp
//
//  Created by solid on 13.02.14.
//  Copyright (c) 2014 Bros Universe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface NSString (hash)

- (NSString *) md5_hex;

@end
