//
//  UIUserCellTableViewCell.h
//  JoinUp
//
//  Created by Vasily Galuzin on 11/02/14.
//  Copyright (c) 2014 Bros Universe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDBadgedCell.h"

@interface UIUserCellTableViewCell : TDBadgedCell

@property (nonatomic, strong) NSString *userLogin;
@property (nonatomic, readwrite) IBOutlet UILabel *userNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *distanceLabel;
@property (nonatomic, strong) IBOutlet UIImageView *userAvatarImageView;
@property (nonatomic, strong) IBOutlet UIImageView *userStatusImageView;
@property (nonatomic, strong) IBOutlet UIImageView *distanceImageView;

@end
