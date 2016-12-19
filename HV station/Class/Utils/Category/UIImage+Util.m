//
//  UIImage+Util.m
//  HuaruiAI
//
//  Created by sswukang on 15/11/16.
//  Copyright © 2015年 huarui. All rights reserved.
//

#import "UIImage+Util.h"

@implementation UIImage (Util)

- (instancetype)xmg_circleImage
{
	// self -> 圆形图片
	
	// 开启图形上下文
	UIGraphicsBeginImageContext(self.size);
	
	// 上下文
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	// 添加一个圆
	CGRect rect = CGRectMake(0, 0, self.size.width - 20, self.size.height -20);
	CGContextAddEllipseInRect(context, rect);
	
	// 裁剪
	CGContextClip(context);
	
	// 绘制图片到圆上面
	[self drawInRect:rect];
	
	// 获得图片
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	
	// 结束图形上下文
	UIGraphicsEndImageContext();
	
	return image;
}

+ (instancetype)xmg_circleImageNamed:(NSString *)name
{
	return [[self imageNamed:name] xmg_circleImage];
}
+ (UIImage*)imageWithColor: (UIColor*)color size:(CGSize)size {
	
	UIGraphicsBeginImageContext(size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(context, color.CGColor);
	CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image; 
}

@end
