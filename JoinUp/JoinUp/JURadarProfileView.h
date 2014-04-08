//
//  RadarProfileView.h
//  JURadar
//
//  Created by Kristina on 04.04.14.
//  Copyright (c) 2014 Bros Universe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface JURadarProfileView : UIScrollView

@property (nonatomic, strong) NSMutableArray* users;
@property (nonatomic, weak) id delegate;

- (id)initWithUsers:(NSMutableArray *) users;
- (User *) getCurrentUser;


@end
