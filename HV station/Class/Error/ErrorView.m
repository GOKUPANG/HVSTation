//
//  ErrorView.m
//  HV station
//
//  Created by sswukang on 2016/10/25.
//  Copyright © 2016年 sswukang. All rights reserved.
//

#import "ErrorView.h"

@interface ErrorView ()<UITableViewDelegate, UITableViewDataSource>

/** 背景图片 */
@property(nonatomic, weak) UIImageView *backgroundImageView;
/** 导航条 */
@property(nonatomic, weak) UIView *navBar;
/** logo图片 */
@property(nonatomic, weak) UIImageView *logoImageView;
/** 用户名label */
@property(nonatomic, weak) UILabel *nameLabel;
/** 导航条下的自定义线 */
@property(nonatomic, weak) UIView *lineView;
/** 抱歉文本label */
@property(nonatomic, weak) UILabel *errorLabel;
/** 表格 */
@property(nonatomic, weak) UITableView *tableView;
/** my Date按钮 */
@property(nonatomic, weak) UIButton *myDateButton;
/** about HV Station按钮 */
@property(nonatomic, weak) UIButton *hvStationButton;

@end
@implementation ErrorView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        
        //初始化
        [self setUpViews];
    }
    return self;
    
}

static NSString *const cellID = @"cellID";
#pragma mark - 内部方法
//初始化
- (void)setUpViews
{
    self.backgroundColor = [UIColor blackColor];
    //背景图片
    UIImageView *backgroundImageView = [[UIImageView alloc] init];
    backgroundImageView.image = [UIImage imageNamed:@""];
    backgroundImageView.backgroundColor = [UIColor colorWithRed:191/ 255.0 green:191/ 255.0 blue:191/ 255.0 alpha:1.0];
    [self addSubview:backgroundImageView];
    self.backgroundImageView = backgroundImageView;
    //导航条
    UIView *navBar = [[UIView alloc] init];
    navBar.backgroundColor = [UIColor colorWithRed:191/ 255.0 green:191/ 255.0 blue:191/ 255.0 alpha:1.0];
    [self addSubview:navBar];
    self.navBar = navBar;
    //logo图片
    UIImageView *logoImageView = [[UIImageView alloc] init];
    logoImageView.image = [UIImage imageNamed:@"主logo"];
    [self.navBar addSubview:logoImageView];
    self.logoImageView = logoImageView;
    
    
       //用户名label
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont fontWithName:@"PingFangSC-Thin" size:24.f];
    
    NSString * userName = [kUserDefault objectForKey:kDefaultsUserName];
    if (!userName||userName.length==0) {
        nameLabel.text = @"UserName";

    }
    else{
        nameLabel.text = userName;
        
    }
    nameLabel.textAlignment = NSTextAlignmentRight;
    [self.navBar addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    //导航条下的自定义线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor blackColor];
    [self addSubview:lineView];
    self.lineView = lineView;
    
    //抱歉文本label
    UILabel *errorLabel = [[UILabel alloc] init];
    errorLabel.font = [UIFont fontWithName:@"PingFangSC-Thin" size:16.f];
    errorLabel.textColor = [UIColor colorWithRed:51 / 255.0 green:51 / 255.0  blue:51 / 255.0  alpha:1.0];
    errorLabel.numberOfLines = 0;
    errorLabel.text = @"抱歉, 可能下列事项导致机器未能正常\n运行";
    errorLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:errorLabel];
    self.errorLabel = errorLabel;
    
    
    
    
    //my Date按钮
    UIButton *myDateButton = [self setupButtonWithBackgroundImage:@"HV-Station" title:@"My Date" tag:24];
    self.myDateButton = myDateButton;
    
    //about HV Station按钮
    UIButton *hvStationButton = [self setupButtonWithBackgroundImage:@"HV-Station" title:@"About HV Station" tag:25];
    self.hvStationButton = hvStationButton;
    
    //表格
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    tableView.rowHeight = 44;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorColor = [UIColor blackColor];
    
    [self addSubview:tableView];
    self.tableView = tableView;

    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }

}
//设置按钮
- (UIButton *)setupButtonWithBackgroundImage:(NSString *)image title:(NSString *)title  tag:(NSInteger)tag
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Thin" size:18.f];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.tag = tag;
    [btn setTitleColor:[UIColor colorWithRed:51 / 255.0 green:51 / 255.0  blue:51 / 255.0  alpha:1.0] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:btn];
    return btn;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //导航条
    [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self).offset(20);
        make.height.mas_equalTo(HRCommonScreenH * 55);
    }];
    //logo图片
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navBar);
        make.left.equalTo(self).offset(10);
        make.height.mas_equalTo(HRCommonScreenH * 37);
        make.width.mas_equalTo(HRCommonScreenH * 37);
    }];
    
    //用户名label
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navBar);
        make.right.equalTo(self).offset(-10);
        make.height.mas_equalTo(HRCommonScreenH * 55);
        make.width.mas_equalTo(HRUIScreenW * 0.5);
    }];
    
    //导航条下的自定义线
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    //背景图
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-43 *HRCommonScreenH);
        make.top.equalTo(self.lineView.mas_bottom);
    }];
    
    
    
    [self.errorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(21 *HRCommonScreenW);
        make.right.equalTo(self).offset(-84 *HRCommonScreenW);
        make.top.equalTo(self).offset(HRCommonScreenH *107);
        make.height.mas_equalTo(45);
    }];
    
    
    //my Date按钮
    [self.myDateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self).offset(HRCommonScreenH *619);
        make.height.mas_equalTo(49 *HRCommonScreenH);
        make.width.mas_equalTo(188 *HRCommonScreenW);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(186* HRCommonScreenH);
        make.left.equalTo(self).offset(20 *HRCommonScreenH);
        make.right.equalTo(self).offset(-20 *HRCommonScreenH);
        make.bottom.equalTo(self).offset(- 69);
    }];
    
    //about HV Station按钮
    [self.hvStationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(188 *HRCommonScreenW);
        make.top.equalTo(self).offset(HRCommonScreenH *619);
        make.height.mas_equalTo(49 *HRCommonScreenH);
        make.width.mas_equalTo(188 *HRCommonScreenW);
    }];
}
#pragma mark - tableView delegate and dataSoure
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:cellID];
    }
    cell.imageView.image = [UIImage imageNamed:@"faill"];
    cell.textLabel.text = @"Faill";
    cell.textLabel.font = [UIFont fontWithName:@"PingFangSC-Thin" size:16];
    cell.textLabel.textColor = [UIColor colorWithRed:51 / 255.0 green:51 / 255.0  blue:51 / 255.0  alpha:1.0];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
    
}
#pragma mark - UI事件
- (void)buttonClick:(UIButton *)button
{
    
}
@end
