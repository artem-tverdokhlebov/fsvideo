//
//  KMTableViewCellColoredAccessory.m
//  KMUtils
//
//  Created by Alexey Bodnya on 2/6/15.
//  Copyright (c) 2015 Alexey Bodnya. All rights reserved.
//

#import "KMTableViewCellColoredAccessory.h"

@implementation KMTableViewCellColoredAccessory

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (nil != self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

+ (KMTableViewCellColoredAccessory *)accessoryWithColor:(UIColor *)color {
    KMTableViewCellColoredAccessory *result = [[KMTableViewCellColoredAccessory alloc] initWithFrame:CGRectMake(0, 0, 11.0, 15.0)];
    result.accessoryColor = color;
    result.highlightedColor = color;
    return result;
}

- (void)drawRect:(CGRect)rect {
    // (x,y) is the tip of the arrow
    CGFloat x = CGRectGetMaxX(self.bounds) - 3.0;
    CGFloat y = CGRectGetMidY(self.bounds);
    const CGFloat R = 4.5;
    CGContextRef ctxt = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(ctxt, x - R, y - R);
    CGContextAddLineToPoint(ctxt, x, y);
    CGContextAddLineToPoint(ctxt, x - R, y + R);
    CGContextSetLineCap(ctxt, kCGLineCapSquare);
    CGContextSetLineJoin(ctxt, kCGLineJoinMiter);
    CGContextSetLineWidth(ctxt, 3);

    if (self.highlighted) {
        [self.highlightedColor setStroke];
    } else {
        [self.accessoryColor setStroke];
    }

    CGContextStrokePath(ctxt);
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    [self setNeedsDisplay];
}

- (UIColor *)accessoryColor {
    if (!_accessoryColor) {
        return [UIColor blackColor];
    }

    return _accessoryColor;
}

- (UIColor *)highlightedColor {
    if (!_highlightedColor) {
        return [UIColor whiteColor];
    }

    return _highlightedColor;
}

@end
