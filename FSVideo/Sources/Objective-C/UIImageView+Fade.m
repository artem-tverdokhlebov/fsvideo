//
//  UIImageView+Fade.m
//  FSVideo
//
//  Created by Alexey Bodnya on 4/16/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

#import "UIImageView+Fade.h"

@implementation UIImageView (Fade)

- (void)appyFadeFrom:(CGPoint)from to:(CGPoint)to {
    CALayer *imageViewLayer = self.layer;
    CAGradientLayer *maskLayer = [CAGradientLayer layer];
    maskLayer.colors = @[ (id)([UIColor blackColor].CGColor), (id)([UIColor clearColor].CGColor) ]; // gradient from 100% opacity to 0% opacity (non-alpha components of the color are ignored)
    // startPoint and endPoint (used to position/size the gradient) are in a coordinate space from the top left to bottom right of the layer: (0,0)–(1,1)
    maskLayer.startPoint = from; // middle bottom at 70%
    maskLayer.endPoint = to; // bottom at 100%
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGRect maskFrame = imageViewLayer.bounds;
    maskFrame.size.width = MAX(screenSize.width, screenSize.height);
    maskLayer.frame = maskFrame; // line it up with the layer it’s masking
    imageViewLayer.mask = maskLayer;
}

@end
