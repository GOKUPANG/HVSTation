//
//  UIView+HRExtension.m
//  xiaorui
//
//  Created by sswukang on 16/4/6.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "UIView+HRExtension.h"

@implementation UIView (HRExtension)

- (CGSize)hr_size
{
	return self.frame.size;
}

- (void)setHr_size:(CGSize)hr_size
{
	CGRect frame = self.frame;
	frame.size = hr_size;
	self.frame = frame;
}

- (CGFloat)hr_width
{
	return self.frame.size.width;
}

- (CGFloat)hr_height
{
	return self.frame.size.height;
}

- (void)setHr_width:(CGFloat)hr_width
{
	CGRect frame = self.frame;
	frame.size.width = hr_width;
	self.frame = frame;
}

- (void)setHr_height:(CGFloat)hr_height
{
	CGRect frame = self.frame;
	frame.size.height = hr_height;
	self.frame = frame;
}

- (CGFloat)hr_x
{
	return self.frame.origin.x;
}

- (void)setHr_x:(CGFloat)hr_x
{
	CGRect frame = self.frame;
	frame.origin.x = hr_x;
	self.frame = frame;
}

- (CGFloat)hr_y
{
	return self.frame.origin.y;
}

- (void)setHr_y:(CGFloat)hr_y
{
	CGRect frame = self.frame;
	frame.origin.y = hr_y;
	self.frame = frame;
}

- (CGFloat)hr_centerX
{
	return self.center.x;
}

- (void)setHr_centerX:(CGFloat)hr_centerX
{
	CGPoint center = self.center;
	center.x = hr_centerX;
	self.center = center;
}


- (CGFloat)hr_centerY
{
	return self.center.y;
}

- (void)setHr_centerY:(CGFloat)hr_centerY
{
	CGPoint center = self.center;
	center.y = hr_centerY;
	self.center = center;
}
/** 获取当前View的控制器对象 */
-(UIViewController *)getCurrentViewController{
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}

@end
