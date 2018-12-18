//
//  UIImage+OCTSupport.m
//  SinaMVVM
//
//  Created by SD on 2018/11/9.
//  Copyright © 2018年 Mr.Huang. All rights reserved.
//

#import "UIImage+OCTSupport.h"

@implementation UIImage (OCTSupport)
+ (UIImage *)imageWithName:(NSString *)name size:(CGSize)size {
    
    UIImage *icon = [self imageNamed:name];
    CGSize itemSize = size;
    UIGraphicsBeginImageContextWithOptions(itemSize, NO,0.0);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [icon drawInRect:imageRect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIGraphicsEndImageContext();
    return image;
}
@end
