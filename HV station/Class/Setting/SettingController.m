//
//  SettingController.m
//  床垫页面
//
//  Created by PongBan on 16/10/19.
//  Copyright © 2016年 聂飞. All rights reserved.
//
#define HRUIScreenW [UIScreen mainScreen].bounds.size.width
#define HRUIScreenH [UIScreen mainScreen].bounds.size.height
//#define HRCommonScreenH (HRUIScreenH / 667.0)
//#define HRCommonScreenW (HRUIScreenW / 375.0)

#define HRTextColor [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51/255.0 alpha:1];

#import "SettingController.h"
#import "UIView+SDAutoLayout.h"

@interface SettingController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView * tableView ;

@property(nonatomic,strong)UIButton * OKBtn ;


/** 背景图片 */
@property(nonatomic, weak) UIImageView *backgroundImageView;


/** 导航条 */
@property(nonatomic, weak) UIView *navBar;
/** logo图片 */
@property(nonatomic, weak) UIImageView * logoImageView;
/** 用户名label */
@property(nonatomic, weak) UILabel * nameLabel;
/** 导航条下的自定义线 */
@property(nonatomic, weak) UIView * lineView;



@end

@implementation SettingController

static NSInteger row = 2;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   // self.view.backgroundColor =[UIColor colorWithRed:231.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1];
   // self.title = @"设置";
    
    
    row = arc4random()%4;
    [self SetUPUI];
    
  
    
    
    NSString * temperDefalut = [kUserDefault objectForKey:defaultTemper];
    
    
   // NSLog(@"本地化有了%@",temperDefalut);
    
    NSInteger rrr = [temperDefalut integerValue];
    
   rrr = rrr-68;
    
    
    
    if (!temperDefalut||temperDefalut.length == 0) {
        
        
              [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];

    }
    
    else{
        
        
        
        row =rrr;
        
        
        
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:rrr inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        

    }
        
    

}


-(void)viewDidLayoutSubviews
{
    
    [super viewDidLayoutSubviews];
    
    //导航条
    [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(20);
        make.height.mas_equalTo(HRCommonScreenH * 55);
    }];
    //logo图片
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navBar);
        make.left.equalTo(self.view).offset(10);
        make.height.mas_equalTo(HRCommonScreenH * 37);
        make.width.mas_equalTo(HRCommonScreenH * 37);
    }];
    
    //用户名label
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navBar);
        make.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(HRCommonScreenH * 55);
        make.width.mas_equalTo(HRUIScreenW * 0.5);
    }];
    
    //导航条下的自定义线
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(1);
    }];
    
    //背景图
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        // make.bottom.equalTo(self.view).offset(-43 *HRCommonScreenH);
        make.bottom.equalTo(self.view);
        
        make.top.equalTo(self.lineView.mas_bottom);
        
    }];
    
    
    
    
    
}


-(void)SetUPUI
{
    
    self.view.backgroundColor = [UIColor blackColor];
    //背景图片
    UIImageView *backgroundImageView = [[UIImageView alloc] init];
    
    backgroundImageView.image = [UIImage imageNamed:@""];
    backgroundImageView.backgroundColor = [UIColor colorWithRed:231.0/ 255.0 green:231.0/ 255.0 blue:231.0/ 255.0 alpha:1.0];
    
    
    [self.view addSubview:backgroundImageView];
    self.backgroundImageView = backgroundImageView;
    
    
    //导航条
    UIView *navBar = [[UIView alloc] init];
    navBar.backgroundColor = [UIColor colorWithRed:191/ 255.0 green:191/ 255.0 blue:191/ 255.0 alpha:1.0];
    [self.view addSubview:navBar];
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
    [self.view addSubview:lineView];
    self.lineView = lineView;
    

    
    
    UILabel * TemLabel = [[UILabel alloc]init];
    UILabel * SleepLabel = [[UILabel alloc]init];
    UILabel * BigLabel = [[UILabel alloc]init];
    
    [self.view addSubview:TemLabel];
    [self.view addSubview:SleepLabel];
    [self.view addSubview:BigLabel];
    
    
    
    TemLabel.sd_layout
    .topSpaceToView(self.view,20+ HRCommonScreenH *55 + 22)
    
    .leftSpaceToView(self.view,21)
    .rightSpaceToView(self.view,HRCommonScreenW * 70 )
    .heightIs(50 * HRCommonScreenH);
    
   // TemLabel.text = @"根据你的身体条件，推荐你睡眠温度\n如不同意，可以修改";
    TemLabel.text = @"Reserve Sleep Temp\nCan Be Change By User";

    TemLabel.font = [UIFont fontWithName:@"PingFangSC-Thin" size:16];
    
    TemLabel.textColor = HRTextColor ;
    
    TemLabel.numberOfLines = 0 ;

    
    
    if (HRUIScreenW <373) {
        
        TemLabel.font = [UIFont fontWithName:@"PingFangSC-Thin" size:14];

    }
    
    
    
    SleepLabel.sd_layout
    .topSpaceToView (TemLabel,20 * HRCommonScreenH)
    .leftSpaceToView(self.view,86)
    .heightIs(20 * HRCommonScreenH)
    .rightSpaceToView(self.view,20);
    
    
    
    
    
    SleepLabel.textColor = HRTextColor ;
    
    SleepLabel.font = [UIFont fontWithName:@"PingFangSC-Thin" size:16];
    
    SleepLabel.text = @"Sleep Temperature";
    
    BigLabel.sd_layout
    .topSpaceToView(SleepLabel,20 * HRCommonScreenH)
    .leftSpaceToView(self.view,80 * HRCommonScreenW)
    .rightSpaceToView(self.view,80 * HRCommonScreenW)
    .heightIs(90 * HRCommonScreenW);
    
    
    BigLabel.textColor = [UIColor colorWithRed:0 green:207.0/255.0 blue:78.0/255.0 alpha:1];
    
    BigLabel.font = [UIFont fontWithName:@"PingFangSC-Thin" size:91 * HRCommonScreenW];
    
    
   
    
    NSString * temper = [kUserDefault objectForKey:defaultTemper ];
    
    
    if (temper.length == 0||!temper) {
        BigLabel.text = [NSString stringWithFormat:@"%ld℉",row+68];

    }
    
    else{
    BigLabel.text = [NSString stringWithFormat:@"%@℉",temper];
    }
    
    
    
    #pragma mark - tableView 
    
    
    
    UITableView * tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(BigLabel.frame)+20, HRUIScreenW,200 ) style:UITableViewStylePlain];
    
    
    tableView.dataSource =self ;
    
    tableView.delegate = self ;
    
    self.automaticallyAdjustsScrollViewInsets = NO ;
    
    tableView.backgroundColor = [UIColor clearColor];
    

    self.tableView = tableView;
    tableView.rowHeight = 40 * HRCommonScreenH;
    

    [self.view addSubview:self.tableView];
    
    tableView.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(BigLabel,20 * HRCommonScreenH)
    .heightIs(200 * HRCommonScreenH);
    
    
    _OKBtn = [[UIButton alloc]init];
    [self.view addSubview:_OKBtn];
    
    _OKBtn.sd_layout
    .topSpaceToView(self.tableView,15 * HRCommonScreenH)
    .centerXEqualToView(self.view)
    . widthIs(91 *HRCommonScreenW)
    .heightIs(40 *HRCommonScreenW);
    [_OKBtn setBackgroundImage:[UIImage imageNamed:@"ok块"] forState:UIControlStateNormal];
    [_OKBtn setBackgroundImage:[UIImage imageNamed:@"OK选中"] forState:UIControlStateHighlighted];

    
    [_OKBtn setTitle:@"OK" forState:UIControlStateNormal];
    
    [_OKBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal ];
    
    _OKBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Thin" size:15];
    
    [_OKBtn addTarget:self action:@selector(oktap) forControlEvents:UIControlEventTouchUpInside];
    
    
}




#pragma mark - OK按钮点击方法

-(void)oktap
{
    
    
//    NSLog(@"OKKK");
//    
//    if ([kUserDefault boolForKey:@"everLaunched"]) {
//        
//        
//        NSLog(@"第一次启动啊啊啊草草哦从奥次哦啊哦哦");
//        
//        
//        
//        [self.navigationController pushViewController:[HomeController new] animated:YES];
//        
//    }
//    
//    else{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    //}
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
    
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
        
        
    }
    
        UIImageView * rightView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"选择"]];
        
        cell.accessoryView = rightView ;
        
        cell.accessoryView.hidden = YES ;
    
    
    if (indexPath.row == row) {
        cell.accessoryView.hidden = NO;
        
    }
    
    else{
        cell.accessoryView.hidden = YES ;
        
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld℉",indexPath.row+68];
    
    cell.textLabel.font = [UIFont fontWithName:@"PingFangSC-Thin" size:16];
    
    cell.backgroundColor = [UIColor clearColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    
    return cell;
    
    

}





-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    row = indexPath.row;
    
    NSString * defaltTem = [NSString stringWithFormat:@"%ld",row+68];
    
    NSLog(@"一开始就来到了这里");
    
    [kUserDefault setValue:defaltTem forKey:defaultTemper];
    
    
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    
    [tableView reloadData];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
