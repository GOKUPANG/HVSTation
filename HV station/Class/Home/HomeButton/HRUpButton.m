//
//  HRUpButton.m
//  HV station
//
//  Created by sswukang on 2016/10/20.
//  Copyright © 2016年 sswukang. All rights reserved.
//

#import "HRUpButton.h"

@implementation HRUpButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setBackgroundImage:[UIImage imageNamed:@"上"] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Thin" size:18.f];
        [self setTitle:@"T." forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithRed:51 / 255.0 green:51 / 255.0  blue:51 / 255.0  alpha:1.0] forState:UIControlStateNormal];
        
        [self setImage:[UIImage imageNamed:@"首页上"] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithRed:0.0 green:193/ 255.0 blue:254 / 255.0 alpha:1.0] forState:UIControlStateNormal];
        
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    CGRect rect = self.imageView.frame;
//    rect.origin.y = CGRectGetMaxY(self.frame) - 20 * HRCommonScreenH;
//    self.imageView.frame = rect;
//    self.imageView.hr_y = CGRectGetMaxY(self.frame) - 20 * HRCommonScreenH;;
//    self.imageView.hr_centerX = self.hr_centerX;
//    self.titleLabel.hr_y = 10;
//    self.titleLabel.hr_x = 10;
//    self.titleLabel.hr_centerX = self.hr_centerX;
    
//    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self);
//        make.bottom.equalTo(self).offset(-10*HRCommonScreenH);
//        make.height.mas_equalTo(18*HRCommonScreenH);
//        make.width.mas_equalTo(20*HRCommonScreenW);
//    }];
//    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.centerX.equalTo(self.imageView.mas_centerX);
//        make.left.equalTo(self).offset(20);
//        make.top.equalTo(self).offset(22*HRCommonScreenH);
//        make.height.mas_equalTo(30*HRCommonScreenH);
//        make.width.mas_equalTo(30*HRCommonScreenW);
//    }];
    
//    
//    self.imageView.hr_height = 9*HRCommonScreenH;
//    self.imageView.hr_width = 10*HRCommonScreenH;
//    self.imageView.hr_centerX = (63 -4)*HRCommonScreenH *0.5;
//    self.imageView.hr_y =  63 * HRCommonScreenH - 15 -9 ;
//    self.titleLabel.hr_centerX = self.imageView.hr_centerX;
//    self.titleLabel.hr_y -= 0.5;
    self.imageView.hr_centerX = 63 *0.5;
    self.imageView.hr_y = CGRectGetMaxY(self.titleLabel.frame)- 2;
    self.titleLabel.hr_centerX = self.imageView.hr_centerX;
//    self.imageView.hr_y = 63 - 9 - 10 -1;
    
//    CGRect titleRect = self.titleLabel.frame;
//    titleRect
//    self.titleLabel.hr_centerX = self.hr_centerX;
    
}
@end
