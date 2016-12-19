//
//  HRCommentButton.m
//  HV station
//
//  Created by sswukang on 2016/10/19.
//  Copyright © 2016年 sswukang. All rights reserved.
//

#import "HRCommentButton.h"

@implementation HRCommentButton

- (instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}

- (void)setupButtonWithBackgroundImage:(NSString *)image title:(NSString *)title  tag:(NSInteger)tag 
{
    [self setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Thin" size:18.f];
    [self setTitle:title forState:UIControlStateNormal];
    self.tag = tag;
}
- (void)buttonClick:(UIButton *)btn
{
    NSLog(@"%stag:%ld", __func__, (long)btn.tag);
}
@end
