//
//  UIImage+ChangeResolution.m
//  JoinUp
//
//  Created by solid on 26.03.14.
//  Copyright (c) 2014 Bros Universe. All rights reserved.
//

#import "UIImage+ChangeResolution.h"

@implementation UIImage (ChangeResolution)

- (NSData *) transformation
{
    /*if(self.size.width>self.size.height)
    {
        NSLog(@"LandScape");
        size1=CGSizeMake((self.size.width/self.size.height)*size1.height,size1.height);
    }
    else
    {
        NSLog(@"Potrait");
        size1=CGSizeMake(size1.width,(self.size.height/self.size.width)*size1.width);
    }*/
    
    CGSize newSize=CGSizeMake(320, 284);
    
    UIGraphicsBeginImageContext(newSize);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return UIImageJPEGRepresentation(newImage, 0.5);
}

- (NSData *) maskImage: (UIImage *)maskImage
{
    CGImageRef maskRef = maskImage.CGImage;
    
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageRef masked = CGImageCreateWithMask([self CGImage], mask);
    
    return UIImageJPEGRepresentation([UIImage imageWithCGImage:masked], 1.0);
}

@end
