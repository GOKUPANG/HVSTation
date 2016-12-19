//
//  FunctionController.m
//  床垫页面
//
//  Created by PongBan on 16/10/19.
//  Copyright © 2016年 聂飞. All rights reserved.
//
#define HRUIScreenW [UIScreen mainScreen].bounds.size.width
#define HRUIScreenH [UIScreen mainScreen].bounds.size.height
//#define HRCommonScreenH (HRUIScreenH / 667.0)
//#define HRCommonScreenW (HRUIScreenW / 375.0)


#import "FunctionController.h"
#import "UIView+SDAutoLayout.h"
#import "FunctionCell.h"

@interface FunctionController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView * tableView ;

@property(nonatomic,strong)NSMutableArray * dataArray ;

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

@implementation FunctionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.view.backgroundColor =[UIColor colorWithRed:231.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1];
    
   // self.title = @"功能";
    
    [self setUPUI];
    
    
    [self setTableView];
    
    

    

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




-(void)setTableView
{
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 75+20+20, HRUIScreenW, HRUIScreenH - 95-48) style:UITableViewStylePlain];
    
    tableView.delegate = self;
    tableView.dataSource =self ;
    
    self.automaticallyAdjustsScrollViewInsets = NO ;
    
    tableView.rowHeight = 40 ;
    
    tableView.backgroundColor = [UIColor clearColor];
    
    
    
    UIView *footView = [UIView new];
    
    tableView.tableFooterView = footView;
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    self.tableView = tableView;
    
    
    [self.view addSubview:self.tableView];
    
}

-(void)setUPUI
{
//    self.view.backgroundColor = [UIColor blackColor];
//    //背景图片
//    UIImageView *backgroundImageView = [[UIImageView alloc] init];
//    
//    backgroundImageView.image = [UIImage imageNamed:@""];
//    backgroundImageView.backgroundColor = [UIColor colorWithRed:231.0/ 255.0 green:231.0/ 255.0 blue:231.0/ 255.0 alpha:1.0];
//    
//    self.backgroundImageView = backgroundImageView;
//
//    [self.view addSubview:self.backgroundImageView];
//    
    
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
    

    
//    NSArray *fontArray = [UIFont familyNames];
//    
//    NSLog(@"%@",fontArray);
//    NSArray *famliyArray = [UIFont fontNamesForFamilyName:@"PingFang SC"];
//    
//    NSLog(@"平方字体%@",famliyArray);
}


#pragma mark - tableView 代理方法

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7 ;
    
}


-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
      FunctionCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    
    
    if (cell == nil) {
        cell = [[FunctionCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
        
        
    }
    
    
    switch (indexPath.row) {
        case 0:
        {
             //cell.nameLabel.text = @"产品说明书";
            cell.nameLabel.text = @"Illustration";
            
             cell.headImg.image = [UIImage imageNamed:@"产品"];
        }
            
            break;
            
       case 1:
        {
            //cell.nameLabel.text = @"安全事项";
            cell.nameLabel.text = @"Safety Standard";

            cell.headImg.image = [UIImage imageNamed:@"安全"];
        }
            
            break;
            
            
        case 2:
        {
          //  cell.nameLabel.text = @"产品功能";
            cell.nameLabel.text = @"Function";

            cell.headImg.image = [UIImage imageNamed:@"功能"];
        }
            break;

            
        case 3:
        {
            //产品安装
            cell.nameLabel.text = @"Assembly";
            cell.headImg.image = [UIImage imageNamed:@"安装"];
        }
            
            break;

            
        case 4:
        {
           // cell.nameLabel.text = @"产品操作";
            cell.nameLabel.text = @"Usage";

            cell.headImg.image = [UIImage imageNamed:@"操作"];
        }
            
            break;

            
        case 5:
        {
//            cell.nameLabel.text = @"常见疑问";
             cell.nameLabel.text = @"General Problem";

            cell.headImg.image = [UIImage imageNamed:@"疑问"];
        }
            break;

            
        case 6:
        {
           // cell.nameLabel.text = @"意见反馈";
            cell.nameLabel.text = @"Customer Suggestion";

            cell.headImg.image = [UIImage imageNamed:@"意见"];
        }
            
            break;

            
       
            
            
        default:
            break;
    }
    

    
   
    cell.backgroundColor = [UIColor clearColor];
    
   
    //cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.nameLabel.font = [UIFont fontWithName:@"PingFangSC-Thin" size:16];

    
    cell.nameLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51/255.0 alpha:1];
    
    
    
    
    
    
    
    return cell ;
    
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
