//
//  KMTableViewCellColoredAccessory.h
//  KMUtils
//
//  Created by Alexey Bodnya on 2/6/15.
//  Copyright (c) 2015 Alexey Bodnya. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface KMTableViewCellColoredAccessory : UIControl

@property (nonatomic, strong) IBInspectable UIColor *accessoryColor;
@property (nonatomic, strong) IBInspectable UIColor *highlightedColor;

+ (KMTableViewCellColoredAccessory *)accessoryWithColor:(UIColor *)color;

@end