//
//  PhotoViewController.h
//  JoinUp
//
//  Created by solid on 24.03.14.
//  Copyright (c) 2014 Bros Universe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Profile.h"
#import "UIImage+ChangeResolution.h"

@interface PhotoViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIImageView *photoView;



- (IBAction)changePhoto:(id)sender;
- (IBAction)takePhoto:(id)sender;

- (void)showPhoto: (id)data;
- (BOOL)uploadPhoto: (NSData *)imageData;


@end
