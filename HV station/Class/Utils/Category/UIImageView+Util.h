//
//  UIImageView+Util.h
//  xiaorui
//
//  Created by sswukang on 15/12/22.
//  Copyright © 2015年 huarui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Util)

///翻转动画方式更改highlighted属性，即切换图片
-(void) doFlipAnimChangeHightlighted: (BOOL)highlighted;

///翻转动画方式更改highlighted属性，即切换图片
///
/// - parameter allowMultipleChange: 允许多次改变， 如果为false，那么只要新highlighted原highlighted一致，就不会执行动画，如果该参数为true，则无论如何动画都会执行。
-(void) doFlipAnimChangeHightlighted: (BOOL)highlighted allowMultipleChange:(BOOL)allow;

@end
