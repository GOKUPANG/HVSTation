//
//  UIImage+Util.h
//  HuaruiAI
//
//  Created by sswukang on 15/11/16.
//  Copyright © 2015年 huarui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Util)

+ (UIImage*)imageWithColor: (UIColor*)color size:(CGSize)size;

- (instancetype)xmg_circleImage;

+ (instancetype)xmg_circleImageNamed:(NSString *)name;

@end
