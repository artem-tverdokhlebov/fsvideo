//
//  UIView+Enumeration.m
//  FSVideo
//
//  Created by Alexey Bodnya on 7/5/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

#import "UIView+Enumeration.h"

@implementation UIView (Enumeration)

- (void)enumerateSubviewsWithBlock:(void (^)(UIView *view))performBlock {
    void (^thePerformBlock)(UIView *view) = [performBlock copy];
    for (UIView *subView in self.subviews) {
        if (thePerformBlock) {
            thePerformBlock(subView);
        }
        [subView enumerateSubviewsWithBlock:thePerformBlock];
    }
}

@end
