//
//  UIView+HRExtension.h
//  xiaorui
//
//  Created by sswukang on 16/4/6.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (HRExtension)
@property (nonatomic, assign) CGSize hr_size;
@property (nonatomic, assign) CGFloat hr_width;
@property (nonatomic, assign) CGFloat hr_height;
@property (nonatomic, assign) CGFloat hr_x;
@property (nonatomic, assign) CGFloat hr_y;
@property (nonatomic, assign) CGFloat hr_centerX;
@property (nonatomic, assign) CGFloat hr_centerY;

/** 获取当前View的控制器对象 */
-(UIViewController *)getCurrentViewController;
@end
