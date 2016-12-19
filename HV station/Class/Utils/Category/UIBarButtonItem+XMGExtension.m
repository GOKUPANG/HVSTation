//
//  UIBarButtonItem+XMGExtension.m
//  6期-百思不得姐
//
//  Created by xiaomage on 15/12/4.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "UIBarButtonItem+XMGExtension.h"

@implementation UIBarButtonItem (XMGExtension)
+ (instancetype)xmg_itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
	[button setTitle:@"返回" forState:UIControlStateNormal];
    [button sizeToFit];
//	button.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:button];
}
+ (instancetype)hr_itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action title:(NSString *)title
{
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
	[button setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
	[button setTitle:title forState:UIControlStateNormal];
	[button sizeToFit];
	//	button.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
	[button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
	return [[self alloc] initWithCustomView:button];

}
@end
