//
//  UIColor+Util.m
//  iosapp
//
//  Created by chenhaoxiang on 14-10-18.
//  Copyright (c) 2014年 oschina. All rights reserved.
//

#import "UIColor+Util.h"
#import "AppDelegate.h"

@implementation UIColor (Util)

+ (UIColor *)colorWithString:(NSString *)str
{
	if (!str || [str isEqualToString:@""]) {
		return nil;
	}
	unsigned red,green,blue;
	NSRange range;
	range.length = 2;
	range.location = 1;
	[[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&red];
	range.location = 3;
	[[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&green];
	range.location = 5;
	[[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&blue];
	UIColor *color= [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1];
	return color;
}

#pragma mark - Hex

+ (UIColor *)colorWithHex:(int)hexValue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0
                           alpha:alpha];
}

+ (UIColor *)colorWithR:(int)R G:(int)G B:(int)B alpha:(CGFloat)alpha {
	return [UIColor colorWithRed:((float)R)/255.f
						   green:((float)G)/255.f
							blue:((float)B)/255.f
						   alpha:alpha];
	
}

+ (UIColor *)colorWithHex:(int)hexValue
{
    return [UIColor colorWithHex:hexValue alpha:1.0];
}

+(UIColor *)themeColor {
	return [UIColor colorWithHex:0x03A9F5];
}

+(UIColor *)defaultTextColor {
	return [UIColor colorWithHex:0x353C47];
}

+(UIColor *)styleColorPM25 {
	return [UIColor colorWithHex:0x19CE8B];
}

+(UIColor *)styleColorVOC {
	return [UIColor colorWithHex:0x4492F7];
}

+(UIColor *)styleColorInfrared {
	return [UIColor colorWithHex:0xF26665];
}

+(UIColor *)styleColorTemp {
	return [UIColor colorWithHex:0x6F67E0];
}

+(UIColor *)styleColorText {
	return [UIColor colorWithHex:0xFE9600];
}

+(UIColor *)styleColorUpdate {
	return [UIColor colorWithHex:0x1AA9B9];
}

+(UIColor *)tableViewBackgroundColor {
	return [UIColor colorWithHex:0xF4F7FA];
}

@end
