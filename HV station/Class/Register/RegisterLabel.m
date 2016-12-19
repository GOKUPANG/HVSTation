//
//  RegisterLabel.m
//  床垫页面
//
//  Created by PongBan on 16/10/21.
//  Copyright © 2016年 聂飞. All rights reserved.
//

#define HRTextColor [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51/255.0 alpha:1];



#import "RegisterLabel.h"

@implementation RegisterLabel



-(instancetype)init
{
    
    if (self = [super init]) {
        self.textColor = HRTextColor ;
        self.font = [UIFont fontWithName:@"PingFangSC-Thin" size:16];
        
    }
    return self;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
