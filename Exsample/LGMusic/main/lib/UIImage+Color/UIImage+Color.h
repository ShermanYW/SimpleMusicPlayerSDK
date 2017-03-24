//
//  UIImage+Color.h
//  LGMusic
//
//  Created by SHERMAN on 2017/3/19.
//  Copyright © 2017年 sherman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Color)
+ (UIImage *)imageWithColor:(UIColor *)color Size:(CGSize)size;

+ (UIImage *)circleImage:(UIImage *) image borderWidth:(CGFloat) borderWidth borderColor:(UIColor *)borderColor;
@end
