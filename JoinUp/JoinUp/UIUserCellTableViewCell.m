//
//  UIUserCellTableViewCell.m
//  JoinUp
//
//  Created by Vasily Galuzin on 11/02/14.
//  Copyright (c) 2014 Bros Universe. All rights reserved.
//

#import "UIUserCellTableViewCell.h"

@implementation UIUserCellTableViewCell

@synthesize userLogin;
@synthesize userNameLabel;
@synthesize userAvatarImageView;
@synthesize distanceLabel;
@synthesize distanceImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
