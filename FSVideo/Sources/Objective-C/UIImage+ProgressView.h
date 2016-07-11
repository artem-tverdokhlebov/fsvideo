//
//  UIImage+ProgressView.h
//  FSVideo
//
//  Created by Alexey Bodnya on 4/17/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ProgressView)

+ (UIImage *)imageOfSize:(CGSize)size progress:(double)progress paused:(BOOL)paused color:(UIColor *)color;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
- (UIImage *)scaledToSize:(CGSize)newSize;

@end
