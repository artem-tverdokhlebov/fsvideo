//
//  UIView+Enumeration.h
//  FSVideo
//
//  Created by Alexey Bodnya on 7/5/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Enumeration)

- (void)enumerateSubviewsWithBlock:(void (^)(UIView *view))performBlock;

@end
