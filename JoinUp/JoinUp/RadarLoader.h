//
//  RadarLoader.h
//  JoinUp
//
//  Created by Andrew on 24/03/14.
//  Copyright (c) 2014 Bros Universe. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "RadarLoaderProtocol.h"

@interface RadarLoader : NSObject
{
    int index;
    NSMutableData *activeDownloadData;
}

@property (nonatomic, assign) id <RadarLoaderProtocol> delegate;
@property (nonatomic) int index;

- (void)loadNearUsers; 

@end
