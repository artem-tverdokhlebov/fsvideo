//
//  UIImage+ProgressView.m
//  FSVideo
//
//  Created by Alexey Bodnya on 4/17/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

#import "UIImage+ProgressView.h"

@implementation UIImage (ProgressView)

+ (UIImage *)imageOfSize:(CGSize)size progress:(double)progress paused:(BOOL)paused color:(UIColor *)color {
    UIImage *result = nil;
    
    CGFloat radius = size.width / 2.0;
    CGPoint center = CGPointMake(radius, radius);
    CGFloat lineWidth = size.width / 15.0;
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, 1.0);
    CGContextAddEllipseInRect(context, CGRectMake(lineWidth / 2.0, lineWidth / 2.0, size.width - lineWidth, size.height - lineWidth));
    CGContextStrokePath(context);
    
    if (paused) {
        CGFloat width = 1.0;
        CGFloat height = size.height / 3.0 + 4;
        CGFloat sideWidth = size.height / 3.0 * (4.0 / 5.0) - 2.0;
        CGContextSetLineWidth(context, width);
        CGContextMoveToPoint(context, center.x, center.y - height / 2.0);
        CGContextAddLineToPoint(context, center.x, center.y + height / 2.0);
        
        CGContextMoveToPoint(context, center.x, center.y + height / 2.0);
        CGContextAddLineToPoint(context, center.x - sideWidth, center.y + 1);
        CGContextMoveToPoint(context, center.x, center.y + height / 2.0);
        CGContextAddLineToPoint(context, center.x + sideWidth, center.y + 1);
        CGContextStrokePath(context);
    } else {
        CGFloat width = size.width / 9.0;
        CGContextSetLineWidth(context, width);
        CGContextMoveToPoint(context, center.x - width, size.height / 3.0);
        CGContextAddLineToPoint(context, center.x - width, size.height * 2.0 / 3.0);
        CGContextMoveToPoint(context, center.x + width, size.height / 3.0);
        CGContextAddLineToPoint(context, center.x + width, size.height * 2.0 / 3.0);
        CGContextStrokePath(context);
    }
    
    CGContextSetLineWidth(context, lineWidth * 2);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextAddArc(context, center.x, center.y, radius - lineWidth - 0.5, -M_PI_2, -M_PI_2 + progress * 2 * M_PI, 0);
    CGContextStrokePath(context);
    
    result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)scaledToSize:(CGSize)newSize {
    return [UIImage imageWithImage:self scaledToSize:newSize];
}

@end
