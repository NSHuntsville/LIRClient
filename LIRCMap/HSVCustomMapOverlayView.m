//
//  HSVCustomMapOverlay.m
//  LIRCMap
//
//  Created by Matt Blackmon on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "HSVCustomMapOverlayView.h"

@implementation HSVCustomMapOverlayView


- (BOOL)canDrawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale {
    return YES;
}


- (void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)context {
    CGRect drawSpace = [self rectForMapRect:mapRect];
    CGRect exclusionSpace = [self rectForMapRect:self.overlay.boundingMapRect];


    if (!CGRectIntersectsRect(drawSpace, exclusionSpace)) {
        CGContextSetFillColorWithColor(context, [[UIColor blueColor] colorWithAlphaComponent:0.4].CGColor);
        CGContextFillRect(context, drawSpace);
    } else {
        NSLog(@"got intersection");
        CGContextSetFillColorWithColor(context, [[UIColor blueColor] colorWithAlphaComponent:0.4].CGColor);
        CGContextFillRect(context, drawSpace);

        UIBezierPath *exclusionPath = [UIBezierPath bezierPathWithOvalInRect:exclusionSpace];
        [exclusionPath closePath];
        CGContextAddPath(context, exclusionPath.CGPath);
        CGContextClip(context);
        CGContextClearRect(context, exclusionSpace);

    }

}


@end
