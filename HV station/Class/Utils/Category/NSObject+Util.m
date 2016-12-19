//
//  NSObject+Util.m
//  xiaorui
//
//  Created by sswukang on 16/3/12.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "NSObject+Util.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation NSObject (Util)
//拿到根控制器
+ (UIViewController *)activityViewController
{
	UIViewController* activityViewController = nil;
	
	UIWindow *window = [[UIApplication sharedApplication] keyWindow];
	if(window.windowLevel != UIWindowLevelNormal)
	{
		NSArray *windows = [[UIApplication sharedApplication] windows];
		for(UIWindow *tmpWin in windows)
		{
			if(tmpWin.windowLevel == UIWindowLevelNormal)
			{
				window = tmpWin;
				break;
			}
		}
	}
	
	NSArray *viewsArray = [window subviews];
	if([viewsArray count] > 0)
	{
		UIView *frontView = [viewsArray objectAtIndex:0];
		
		id nextResponder = [frontView nextResponder];
		
		if([nextResponder isKindOfClass:[UIViewController class]])
		{
			activityViewController = nextResponder;
		}
		else
		{
			activityViewController = window.rootViewController;
		}
	}
	return activityViewController;
}

-(NSDictionary *)objectDictionary {
	NSMutableDictionary *objectDict = [@{} mutableCopy];
	for (NSString *key in [[self propertyDictionary] allKeys]) {
		[objectDict setValue:[self valueForKey:key] forKey:key];
	}
	return objectDict;
}

-(NSDictionary *)propertyDictionary {
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];

	unsigned count;
	objc_property_t *properties = class_copyPropertyList([self class], &count);
	
	for (int i = 0; i < count; i++) {
		NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
		[dict setObject:key forKey:key];
	}
	
	free(properties);
	
	// Add all superclass properties as well, until it hits NSObject
	NSString *superClassName = [[self superclass] nameOfClass];
	if (![superClassName isEqualToString:@"NSObject"]) {
		for (NSString *property in [[[self superclass] propertyDictionary] allKeys]) {
			[dict setObject:property forKey:property];
		}
	}
	
	return dict;
}

-(NSString *)nameOfClass {
	return [NSString stringWithUTF8String:class_getName([self class])];
}

@end
