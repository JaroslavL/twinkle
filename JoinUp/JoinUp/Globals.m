//
//  Globals.m
//  SCWaveAnimation
//
//  Created by Marton Fodor on 2/2/11.
//  Copyright 2011 The Subjective-C. No rights reserved.
//

#import "Globals.h"


@implementation Globals
@synthesize animationDuration;
@synthesize numberOfWaves;
@synthesize spawnInterval;
@synthesize spawnSize;
@synthesize scaleFactor;
@synthesize shadowRadius;

static Globals* _sharedInstance;

+ (Globals *) sharedGlobals{
    
    @synchronized(self) {
        
        if (!_sharedInstance) {
            _sharedInstance = [[Globals alloc] init];
        }
    }
    
    return _sharedInstance;
    
}

- (instancetype)init {
    
    self = [super init];
    
    if (self){
        
        self.animationDuration = 0.7f;
        self.numberOfWaves = 1;
        self.spawnInterval = 3;
        self.spawnSize = 120;
        self.scaleFactor = 2.4;
        self.shadowRadius = 1;
        
        
    }
    
    return self;
}

@end
