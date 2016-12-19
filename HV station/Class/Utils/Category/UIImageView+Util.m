//
//  UIImageView+Util.m
//  xiaorui
//
//  Created by sswukang on 15/12/22.
//  Copyright © 2015年 huarui. All rights reserved.
//

#import "UIImageView+Util.h"

@implementation UIImageView (Util)


-(void) doFlipAnimChangeHightlighted: (BOOL)highlighted {
	[self doFlipAnimChangeHightlighted:highlighted allowMultipleChange:NO];
}

-(void) doFlipAnimChangeHightlighted: (BOOL)highlighted allowMultipleChange:(BOOL)allow {
	//如果状态一致，则返回
	if (self.highlighted == highlighted && !allow) return;
	
	self.highlighted = highlighted;
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.5f];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
	[UIView commitAnimations];
}

//右上角标记的文字
-(void) setBadgeText: (NSString*) text {
	CAShapeLayer * badgeLayer = [[CAShapeLayer alloc] init];

}

@end
