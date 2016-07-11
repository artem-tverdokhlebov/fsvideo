//
//  UIBarButtonItem+Appearance.m
//  FSVideo
//
//  Created by Alexey Bodnya on 4/16/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

#import "UIBarButtonItem+Appearance.h"

@implementation UIBarButtonItem (Appearance)

+ (UIBarButtonItem *)appearanceWhenContainedInClass:(Class)objectClass {
    return [self appearanceWhenContainedIn:objectClass, nil];
}

@end
