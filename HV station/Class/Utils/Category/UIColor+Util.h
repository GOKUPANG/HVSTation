//
//  UIColor+Util.h
//  iosapp
//
//  Created by chenhaoxiang on 14-10-18.
//  Copyright (c) 2014年 oschina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Util)

+ (UIColor *)colorWithHex:(int)hexValue alpha:(CGFloat)alpha;
+ (UIColor *)colorWithHex:(int)hexValue;
+ (UIColor *)colorWithR:(int)R G:(int)G B:(int)B alpha:(CGFloat)alpha;
+ (UIColor *)colorWithString:(NSString *)str;


+ (UIColor *)themeColor;
///默认的字体颜色，一般为黑灰色
+(UIColor *)defaultTextColor;

+(UIColor *)styleColorPM25;

+(UIColor *)styleColorVOC;

+(UIColor *)styleColorInfrared;

+(UIColor *)styleColorTemp;

+(UIColor *)styleColorText;

+(UIColor *)styleColorUpdate;
///tableView背景颜色
+(UIColor *)tableViewBackgroundColor;
@end
