//
//  RegisterController.m
//  床垫页面
//
//  Created by PongBan on 16/10/19.
//  Copyright © 2016年 聂飞. All rights reserved.
//
#define HRTextColor [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51/255.0 alpha:1]
#define HRUIScreenW [UIScreen mainScreen].bounds.size.width
#define HRUIScreenH [UIScreen mainScreen].bounds.size.height
//#define HRCommonScreenH (HRUIScreenH / 667.0)
//#define HRCommonScreenW (HRUIScreenW / 375.0)


#import "RegisterController.h"
#import "UIView+SDAutoLayout.h"
#import "RegisterLabel.h"
#import "PickerView.h"
#import "SettingController.h"

@interface RegisterController ()

/** 背景图片 */
@property(nonatomic, weak) UIImageView * backgroundImageView;
/** 导航条 */
@property(nonatomic, weak) UIView * navBar;
/** logo图片 */
@property(nonatomic, weak) UIImageView * logoImageView;
/** 用户名label */
@property(nonatomic, weak) UILabel * nameLabel;
/** 导航条下的自定义线 */
@property(nonatomic, weak) UIView * lineView;
/** 名字输入框 */
@property(nonatomic,strong)UITextField * nameTF;




@end

@implementation RegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //  self.view.backgroundColor =[UIColor colorWithRed:231.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1];
    //self.title = @"注册";
    [self SetUPUI];
    
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
        //make.height.mas_equalTo(55);
    }];
    //logo图片
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navBar);
        make.left.equalTo(self.view).offset(10);
        make.height.mas_equalTo(HRCommonScreenH * 37);
    //    make.height.mas_equalTo( 37);

        make.width.mas_equalTo(HRCommonScreenH * 37);
      //  make.width.mas_equalTo( 37);

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
    
//    
//    self.view.backgroundColor = [UIColor blackColor];
//    //背景图片
//    UIImageView *backgroundImageView = [[UIImageView alloc] init];
//    backgroundImageView.image = [UIImage imageNamed:@""];
//    backgroundImageView.backgroundColor = [UIColor colorWithRed:231.0/ 255.0 green:231.0/ 255.0 blue:231.0/ 255.0 alpha:1.0];
//    [self.view addSubview:backgroundImageView];
//    self.backgroundImageView = backgroundImageView;
    
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

    
    
    
    /**欢迎 */
    RegisterLabel * welcomeLB  = [[RegisterLabel alloc]init];
    /** 位置*/
    UIImageView * positonImgView = [[UIImageView alloc]init];
    RegisterLabel * positionLB = [[RegisterLabel alloc]init];
    UIButton * leftBtn   = [[UIButton alloc]init];
    UIButton * rightBtn  = [[UIButton alloc]init];
    /** 名称*/
    UIImageView * nameImgView = [[UIImageView alloc]init];
    RegisterLabel * nameLB     = [[RegisterLabel alloc]init];
    UITextField * nameTF = [[UITextField alloc]init];
    /** 年龄*/
    UIImageView *ageImgView  = [[UIImageView alloc]init];
    RegisterLabel * ageLB      = [[RegisterLabel alloc]init];
    UIButton * ageBtn  = [[UIButton alloc]init];
    /** 性别*/
    UIImageView * sexImgView = [[UIImageView alloc]init];
    RegisterLabel  * sexLB     = [[RegisterLabel alloc]init];
    UIButton * manBtn    = [[UIButton alloc]init];
    UIButton * womenBtn  = [[UIButton alloc]init];
    /** 身高*/
    UIImageView * heightImgView = [[UIImageView alloc]init];
    RegisterLabel  * heightLB  = [[RegisterLabel alloc]init];
    UIButton  *heightBtn= [[UIButton alloc]init];
    
    /** 体重*/
    UIImageView * weightImgView = [[UIImageView alloc]init];
    RegisterLabel * weightLB   = [[RegisterLabel alloc]init];
    UIButton * weightBtn = [[UIButton alloc]init];
    
    
    /** 温感*/
    UIImageView * temImgView = [[UIImageView alloc]init];
    RegisterLabel *   temLB    = [[RegisterLabel alloc]init];
    UIButton * coldBtn   = [[UIButton alloc]init];
    UIButton * hotBtn    = [[UIButton alloc]init];
    
    
    /** 下一步*/

    UIButton * nextBtn = [[UIButton alloc]init];
    
    [self.view addSubview:welcomeLB];
    [self.view addSubview:positonImgView];
    [self.view addSubview:positionLB];
    [self.view addSubview:nameImgView];
    [self.view addSubview:nameLB];
    [self.view addSubview:nameTF];
    [self.view addSubview:ageImgView];
    [self.view addSubview:ageLB];
    [self.view addSubview:ageBtn];
    [self.view addSubview:sexImgView];
    [self.view addSubview:sexLB];
    [self.view addSubview:manBtn];
    [self.view addSubview:womenBtn];
    [self.view addSubview:weightImgView];
    [self.view addSubview:weightLB];
    [self.view addSubview:weightBtn];
    [self.view addSubview:heightImgView];
    [self.view addSubview:heightLB];
    [self.view addSubview:heightBtn];
    [self.view addSubview:temImgView];
    [self.view addSubview:temLB];
    [self.view addSubview:coldBtn];
    [self.view addSubview:hotBtn];
    [self.view addSubview:leftBtn];
    [self.view addSubview:rightBtn];
    [self.view addSubview:nextBtn];
    #pragma mark - tag 值
    leftBtn.tag  = 101 ;
    rightBtn.tag = 102 ;
    manBtn.tag   = 103 ;
    womenBtn.tag = 104 ;
    coldBtn.tag  = 105 ;
    hotBtn.tag   = 106 ;
    ageBtn.tag   = 107 ;
    heightBtn.tag= 108 ;
    weightBtn.tag= 109 ;
    nameTF.tag   = 110 ;





    
    
    welcomeLB.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(self.view,15 + HRCommonScreenH * 55 +20)
    .heightIs(20)
    .widthIs(300);
   
    welcomeLB.textAlignment = NSTextAlignmentCenter ;
    welcomeLB.text = @"Welcome to  HV Station";

    
    positonImgView.sd_layout
    .leftSpaceToView(self.view,20)
    .heightIs(16)
    .widthIs(16)
    .topSpaceToView(welcomeLB,28 * HRCommonScreenH );
    positonImgView.image = [UIImage imageNamed:@"位置"];
    
    
    nameImgView.sd_layout
    .leftSpaceToView(self.view,20)
    .heightIs(16)
    .widthIs(16)
    .topSpaceToView(positonImgView,28 * HRCommonScreenH );
    nameImgView.image = [UIImage imageNamed:@"名称"];
    
    ageImgView.sd_layout
    .leftSpaceToView(self.view,20)
    .heightIs(16)
    .widthIs(16)
    .topSpaceToView(nameImgView,28 * HRCommonScreenH );
    ageImgView.image = [UIImage imageNamed:@"年龄"];
    
    
    sexImgView.sd_layout
    .leftSpaceToView(self.view,20)
    .heightIs(16)
    .widthIs(16)
    .topSpaceToView(ageImgView,28 * HRCommonScreenH );
    sexImgView.image = [UIImage imageNamed:@"性别"];
    
    heightImgView.sd_layout
    .leftSpaceToView(self.view,20)
    .heightIs(16)
    .widthIs(16)
    .topSpaceToView(sexImgView,28 * HRCommonScreenH );
    heightImgView.image = [UIImage imageNamed:@"身高"];
    
    weightImgView.sd_layout
    .leftSpaceToView(self.view,20)
    .heightIs(16)
    .widthIs(16)
    .topSpaceToView(heightImgView,28 * HRCommonScreenH );
    weightImgView.image = [UIImage imageNamed:@"体重"];
    
    temImgView.sd_layout
    .leftSpaceToView(self.view,20)
    .heightIs(16)
    .widthIs(16)
    .topSpaceToView(weightImgView,28 * HRCommonScreenH );
    temImgView.image = [UIImage imageNamed:@"温感"];
    
    
    
    if (HRUIScreenW < 375) {
        positionLB.sd_layout
        .leftSpaceToView(self.view,40)
        .heightIs(16)
        .topEqualToView(positonImgView)
        .widthIs(130);
        //  positionLB.text = @"你使用机器的位置:";
        positionLB.text = @"Machine Position:";
    }
    
    
    else{
    positionLB.sd_layout
    .leftSpaceToView(self.view,40)
    .heightIs(16)
    .topEqualToView(positonImgView)
    .widthIs(180);
  //  positionLB.text = @"你使用机器的位置:";
    positionLB.text = @"Select Machine Position:";
    }
    
    nameLB.sd_layout
    .leftSpaceToView(self.view,40)
    .heightIs(16)
    .topEqualToView(nameImgView)
    .widthIs(90);
//    nameLB.text = @"你的名称:";
    nameLB.text = @"User Name:";

    
    ageLB.sd_layout
    .leftSpaceToView(self.view,40)
    .heightIs(20)
    .topEqualToView(ageImgView)
    .widthIs(90);
   // ageLB.text = @"你的年龄:";
    ageLB.text = @"User Age:";


    sexLB.sd_layout
    .leftSpaceToView(self.view,40)
    .heightIs(20)
    .topEqualToView(sexImgView)
    .widthIs(90);
 //   sexLB.text = @"你的性别:";
    sexLB.text = @"User Sex:";


    heightLB.sd_layout
    .leftSpaceToView(self.view,40)
    .heightIs(20)
    .topEqualToView(heightImgView)
    .widthIs(90);
  //  heightLB.text = @"你的身高:";
    heightLB.text = @"User Height:";


    weightLB.sd_layout
    .leftSpaceToView(self.view,40)
    .heightIs(20)
    .topEqualToView(weightImgView)
    .widthIs(90);
  //  weightLB.text = @"你的体重:";
    weightLB.text = @"User Weight";
    
    temLB.sd_layout
    .leftSpaceToView(self.view,40)
    .heightIs(20)
    .topEqualToView(temImgView)
    .widthIs(95);
    temLB.text = @"Temp Prefer:";
    
    
    leftBtn.sd_layout
    .leftSpaceToView(positionLB,10)
    .centerYEqualToView(positionLB)
    .heightIs(50)
    .widthIs(50);
    
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"life"] forState:UIControlStateNormal];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"life-right选中"] forState:UIControlStateSelected];
    [leftBtn setTitle:@"left" forState:UIControlStateNormal];
    
    leftBtn.selected = NO ;
    
    

    [leftBtn addTarget:self action:@selector(leftBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    leftBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Thin" size:16];
    
    [leftBtn setTitleColor:HRTextColor forState:UIControlStateNormal];
    
    
    
    
    rightBtn.sd_layout
    .leftSpaceToView(leftBtn,14)
    .centerYEqualToView(positionLB)
    .heightIs(50)
    .widthIs(50);
    
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"life"] forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"life-right选中"] forState:UIControlStateSelected];
    rightBtn.selected = NO ;

    [rightBtn setTitle:@"right" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Thin" size:16];
    [rightBtn addTarget:self action:@selector(rightBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [rightBtn setTitleColor:HRTextColor forState:UIControlStateNormal];
    
    if ([[kUserDefault objectForKey:kDefaultsUserModel] isEqualToString:@"left"]) {
        leftBtn.selected = YES;
        
    }


    else if ([[kUserDefault objectForKey:kDefaultsUserModel] isEqualToString:@"right"] ) {
        rightBtn.selected = YES;
        
    }
    
    else{
        
    }
    
    
    nameTF.sd_layout
    .leftSpaceToView(nameLB,5)
    .centerYEqualToView(nameLB)
    .heightIs(20)
    .widthIs(170);
    
    
    nameTF.font = [UIFont fontWithName:@"PingFangSC-Thin" size:16];
    nameTF.textColor = HRTextColor ;
    nameTF.layer.borderWidth = 0.5;
    nameTF.layer.borderColor = [HRTextColor CGColor];
    nameTF.placeholder = @"Your Name";
    
    nameTF.text = [kUserDefault objectForKey:kDefaultsUserName];
    
    
    
    
    
    ageBtn.sd_layout
    .leftEqualToView(nameTF)
    .centerYEqualToView(ageLB)
    .heightIs(20)
    .widthIs(130);
    
    
    ageBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Thin" size:16];
    ageBtn.titleLabel.textColor = HRTextColor ;
    ageBtn.layer.borderWidth = 0.5;
    ageBtn.layer.borderColor = [HRTextColor CGColor];
    
    
     NSString * ageStr =   [kUserDefault objectForKey:@"age"];
    
    [ageBtn setTitle:ageStr forState:UIControlStateNormal];
    
    [ageBtn setTitleColor:HRTextColor forState:UIControlStateNormal];
    
    ageBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 20);
    
    [ageBtn setImage:[UIImage imageNamed:@"下拉"] forState:UIControlStateNormal];
    
    ageBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 110, 0, 0);
    
    
    [ageBtn addTarget:self action:@selector(ageBtn:) forControlEvents:UIControlEventTouchUpInside];
    

    
    manBtn.sd_layout
    .leftEqualToView(nameTF)
    .heightIs(50)
    .widthIs(50)
    .centerYEqualToView(sexLB);
    
    
    [manBtn setBackgroundImage:[UIImage imageNamed:@"男-女"] forState:UIControlStateNormal];
    [manBtn setBackgroundImage:[UIImage imageNamed:@"男-女选中"] forState:UIControlStateSelected];
    
    [manBtn setTitle:@"M" forState:UIControlStateNormal];
    manBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Thin" size:16];
    
     [manBtn addTarget:self action:@selector(manBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [manBtn setTitleColor:HRTextColor forState:UIControlStateNormal];
    
    
    
    
    womenBtn.sd_layout
    .leftSpaceToView(manBtn,10)
    .heightIs(50)
    .widthIs(50)
    .centerYEqualToView(sexLB);
    
    
    [womenBtn setBackgroundImage:[UIImage imageNamed:@"男-女"] forState:UIControlStateNormal];
    [womenBtn setBackgroundImage:[UIImage imageNamed:@"男-女选中"] forState:UIControlStateSelected];
    
    [womenBtn setTitle:@"F" forState:UIControlStateNormal];
    
    womenBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Thin" size:16];
    
    [womenBtn setTitleColor:HRTextColor forState:UIControlStateNormal];
    
     [womenBtn addTarget:self action:@selector(womenBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    if ([[kUserDefault objectForKey:kDefaultsUserSex] isEqualToString:@"man"]) {
        manBtn.selected = YES;
        
    }
    
    
    else if ([[kUserDefault objectForKey:kDefaultsUserSex] isEqualToString:@"women"] ) {
        
        
        womenBtn.selected = YES;
        
    }
    

    
    
    heightBtn.sd_layout
    .leftEqualToView(nameTF)
    .centerYEqualToView(heightLB)
    .heightIs(20)
    .widthIs(80);
    
    
    heightBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Thin" size:16];
    heightBtn.layer.borderWidth = 0.5;
    heightBtn.layer.borderColor = [HRTextColor CGColor];
    
    NSString * heigtStr = [kUserDefault objectForKey:kDefaultsUserHeight];
    
    
    
    [heightBtn setTitle:heigtStr forState:UIControlStateNormal];
    
    [heightBtn setTitleColor:HRTextColor forState:UIControlStateNormal];
    
    heightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 10);
    
    [heightBtn setImage:[UIImage imageNamed:@"下拉"] forState:UIControlStateNormal];
    
    heightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 67, 0, 0);
    
    
    [heightBtn addTarget:self action:@selector(heightBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
    
    weightBtn.sd_layout
    .leftEqualToView(nameTF)
    .centerYEqualToView(weightLB)
    .heightIs(20)
    .widthIs(80);
    
    
    weightBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Thin" size:16];
    weightBtn.layer.borderWidth = 0.5;
    weightBtn.layer.borderColor = [HRTextColor CGColor];
    
    NSString * weightStr = [kUserDefault objectForKey:@"weight"];
    
    [weightBtn setTitle:weightStr forState:UIControlStateNormal];
    
    [weightBtn setTitleColor:HRTextColor forState:UIControlStateNormal];
    
    weightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 10);
    
    [weightBtn setImage:[UIImage imageNamed:@"下拉"] forState:UIControlStateNormal];
    
    weightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 67, 0, 0);
    
    
    [weightBtn addTarget:self action:@selector(weightBtn:) forControlEvents:UIControlEventTouchUpInside];

    
    
    coldBtn.sd_layout
    .leftEqualToView(nameTF)
    .heightIs(50)
    .widthIs(50)
    .centerYEqualToView(temLB);
    
    
    [coldBtn setBackgroundImage:[UIImage imageNamed:@"冷-热"] forState:UIControlStateNormal];
    [coldBtn setBackgroundImage:[UIImage imageNamed:@"喜冷选中"] forState:UIControlStateSelected];

    
    [coldBtn setTitle:@"Cooler" forState:UIControlStateNormal];
    coldBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Thin" size:14];
    
    [coldBtn setTitleColor:HRTextColor forState:UIControlStateNormal];
    
    [coldBtn addTarget:self action:@selector(coldBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    hotBtn.sd_layout
    .leftSpaceToView(coldBtn,10)
    .heightIs(50)
    .widthIs(50)
    .centerYEqualToView(temLB);
    
    
    [hotBtn setBackgroundImage:[UIImage imageNamed:@"冷-热"] forState:UIControlStateNormal];
    [hotBtn setBackgroundImage:[UIImage imageNamed:@"喜热选中"] forState:UIControlStateSelected];
    [hotBtn setTitle:@"Warmer" forState:UIControlStateNormal];
    hotBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Thin" size:14];
    
    [hotBtn setTitleColor:HRTextColor forState:UIControlStateNormal];
    
    [hotBtn addTarget:self action:@selector(hotBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    

    if ([[kUserDefault objectForKey:kDefaultsUserTemper] isEqualToString:@"cold"]) {
        coldBtn.selected = YES;
        
    }
    
    
    else if ([[kUserDefault objectForKey:kDefaultsUserTemper] isEqualToString:@"warm"] ) {
        hotBtn.selected = YES;
        
    }
    

    
    nextBtn.sd_layout
    .rightSpaceToView(self.view,38)
    .leftSpaceToView(self.view,38)
    .heightIs(40)
    .topSpaceToView(temLB,50);
    
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"下一步"] forState:UIControlStateNormal];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"下一步选中"] forState:UIControlStateHighlighted];
    
    
    [nextBtn setTitle:@"Next" forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Thin" size:16];
    
    [nextBtn setTitleColor:HRTextColor forState:UIControlStateNormal];
    
    [nextBtn addTarget:self action:@selector(nextBtn) forControlEvents:UIControlEventTouchUpInside];
    
    

}



#pragma mark - 年龄按钮下拉方法
-(void)ageBtn:(UIButton *)btn
{
    
    
    UITextField * nameTF = [self.view viewWithTag:110];
    
    [nameTF resignFirstResponder];
    
    PickerView * picker = [PickerView showPickerViewInVCTop:self withType:(PickerViewTypeDate_Date)];
    
    [picker setSelectBlock:^(NSObject *data, BOOL isSureBtn) {
        //NSLog(@"%@ -- %d",data,isSureBtn);
        
        if (isSureBtn) {
            
            NSString * btntitle = [NSString stringWithFormat:@"%@",data];
            
            NSString * subStr = [btntitle substringToIndex:10];
            
            [btn setTitle:subStr forState:UIControlStateNormal];
            
          //  NSLog(@"截取的字符串%@",subStr);
            
        }
        
    }];
    

    
}


#pragma mark - 身高按钮下拉方法

-(void)heightBtn:(UIButton *)btn
{
    PickerView * picker = [PickerView showPickerViewInVCTop:self withType:(PickerViewTypeData)];
    
    NSMutableArray * mtbArray  = [NSMutableArray array];
    
    for (int i =  0; i<300; i++) {
        
        NSString * str = [NSString stringWithFormat:@"%dcm",i];
        
        [mtbArray addObject:str];
        
    }
    NSMutableArray * dataArr = [NSMutableArray array];
    
    [dataArr addObject:mtbArray];
    
    picker.dataSources = dataArr;
    
    
    [picker setSelectBlock:^(NSObject *data, BOOL isSureBtn) {

        if (isSureBtn) {
            NSString * btntitle = [NSString stringWithFormat:@"%@",data];
            
            NSString *strUrl = [btntitle stringByReplacingOccurrencesOfString:@" " withString:@""];
           NSString *strUrl1 = [strUrl stringByReplacingOccurrencesOfString:@"(" withString:@""];
            NSString *strUrl2 = [strUrl1 stringByReplacingOccurrencesOfString:@")" withString:@""];
            NSString *strUrl3 = [strUrl2 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
        
            
           [btn setTitle:strUrl3 forState:UIControlStateNormal];
        }
        


    }];
    
}

#pragma mark - 体重下拉按钮实现方法
-(void)weightBtn:(UIButton *)btn
{
    PickerView * picker = [PickerView showPickerViewInVCTop:self withType:(PickerViewTypeData)];
    
    NSMutableArray * mtbArray  = [NSMutableArray array];
    
    for (int i =  0; i<200; i++) {
        
        NSString * str = [NSString stringWithFormat:@"%dkg",i];
        
        [mtbArray addObject:str];
        
    }
    NSMutableArray * dataArr = [NSMutableArray array];
    
    [dataArr addObject:mtbArray];
    
    picker.dataSources = dataArr;
    
    [picker setSelectBlock:^(NSObject *data, BOOL isSureBtn) {
        
        if (isSureBtn) {
            NSString * btntitle = [NSString stringWithFormat:@"%@",data];
            
            NSString *strUrl = [btntitle stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSString *strUrl1 = [strUrl stringByReplacingOccurrencesOfString:@"(" withString:@""];
            NSString *strUrl2 = [strUrl1 stringByReplacingOccurrencesOfString:@")" withString:@""];
            NSString *strUrl3 = [strUrl2 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
            
            
            [btn setTitle:strUrl3 forState:UIControlStateNormal];
        }
        
        
        
    }];


}



#pragma mark - 下一步按钮实现方法

-(void)nextBtn
{
   /*
    leftBtn.tag  = 101 ;
    rightBtn.tag = 102 ;
    manBtn.tag   = 103 ;
    womenBtn.tag = 104 ;
    coldBtn.tag  = 105 ;
    hotBtn.tag   = 106 ;
    ageBtn.tag   = 107 ;
    heightBtn.tag= 108 ;
    weightBtn.tag= 109 ;
*/
    
    UIButton * leftBtn   = [self.view viewWithTag:101];
    UIButton * rightBtn  = [self.view viewWithTag:102];
    UIButton * manBtn    = [self.view viewWithTag:103];
    UIButton * womenBtn  = [self.view viewWithTag:104];
    
    //UIButton * manBtn = [self.view viewWithTag:103];
    UIButton * coldBtn   = [self.view viewWithTag:105];
    UIButton * warmBtn   = [self.view viewWithTag:106];
    
    UIButton * ageBtn    = [self.view viewWithTag:107];
    UIButton * heightBtn = [self.view viewWithTag:108];
    UIButton * weightBtn = [self.view viewWithTag:109];
    UITextField * nameTF = [self.view viewWithTag:110];
    
    
    SettingController * setVC = [[SettingController alloc]init];
    
    if (manBtn.isSelected) {
        [[NSUserDefaults standardUserDefaults] setValue:@"man"forKey:kDefaultsUserSex];
    }
    
    else  if (womenBtn.isSelected)
    {
        
        
        [[NSUserDefaults standardUserDefaults] setValue:@"women"forKey:kDefaultsUserSex];
        
    }

    
    
    if (leftBtn.isSelected) {
        [[NSUserDefaults standardUserDefaults] setValue:@"left"forKey:kDefaultsUserModel];
    }
    
    else if(rightBtn.isSelected)
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"right"forKey:kDefaultsUserModel];

    }
    
    
    if (coldBtn.isSelected) {
        [[NSUserDefaults standardUserDefaults] setValue:@"cold"forKey:kDefaultsUserTemper];

    }
    
    else if(warmBtn.isSelected){
        [[NSUserDefaults standardUserDefaults] setValue:@"warm" forKey:kDefaultsUserTemper];
        
    }
    
    
    //默认名字
    [[NSUserDefaults standardUserDefaults] setValue:nameTF.text forKey:kDefaultsUserName];
    //年龄
    [[NSUserDefaults standardUserDefaults] setValue:ageBtn.titleLabel.text forKey:kDefaultsUserAge];
    //身高
    [[NSUserDefaults standardUserDefaults] setValue:heightBtn.titleLabel.text forKey:kDefaultsUserHeight];
    //体重
    [[NSUserDefaults standardUserDefaults] setValue:weightBtn.titleLabel.text forKey:kDefaultsUserWeight];
    
    
    
    if (nameTF.text == nil || nameTF.text.length == 0|| ageBtn.titleLabel.text.length==0 || heightBtn.titleLabel.text.length == 0||weightBtn.titleLabel.text.length == 0)
    {
        NSLog(@"空一");
        
        
        
        [SVProgressHUD showErrorWithStatus:@"信息不完整"];
        
        
        return;
        
        
    }
    
    //使用模式
    NSString * useModel = [kUserDefault objectForKey:kDefaultsUserModel];
    //性别
    NSString * sex = [kUserDefault objectForKey:kDefaultsUserSex];
    //温感
    NSString * temper = [kUserDefault objectForKey:kDefaultsUserTemper];
    
    
    if (!useModel||!sex ||!temper) {
        NSLog(@"空二");
        [SVProgressHUD showErrorWithStatus:@"信息不完整"];

        return;
        
    }
    
    //判断是否有某一项没填
    
    
  /*
    NSMutableArray * mtArray = [NSMutableArray array];
    //名称
    [mtArray addObject:[kUserDefault objectForKey:kDefaultsUserName]];
    //年龄
    [mtArray addObject:[kUserDefault objectForKey:kDefaultsUserAge]];
    //左右模式
    [mtArray addObject:[kUserDefault objectForKey:kDefaultsUserModel]];
    //身高
    [mtArray addObject:[kUserDefault objectForKey:kDefaultsUserHeight]];
    //体重
    [mtArray addObject:[kUserDefault objectForKey:kDefaultsUserWeight]];
    //性别
    [mtArray addObject:[kUserDefault objectForKey:kDefaultsUserSex]];
    //用户温感
    [mtArray addObject:[kUserDefault objectForKey:kDefaultsUserTemper]];
    
    
    for (NSString * sle  in mtArray) {
        
        if (sle.length == 0 || sle==nil) {
            NSLog(@"有一个为空");
            
        }
        
        
    }
    
   
   */
    
    
    
    [self.navigationController pushViewController:setVC animated:YES];
    

    NSLog(@"%@ %@ %@",[kUserDefault objectForKey:@"age"],heightBtn.titleLabel.text,weightBtn.titleLabel.text);
    

}


-(void)leftBtn:(UIButton *)btn
{
    
    
    UIButton * rightBtn = [self.view viewWithTag:102];
    
    
    if ( !btn.selected) {
        btn.selected = YES;
        
        rightBtn.selected = NO;
        
    }
    
    else
    {
        btn.selected = NO;

    }
    
}


-(void)rightBtn:(UIButton *)btn
{
    
    UIButton * leftBtn = [self.view viewWithTag:101];

    if ( !btn.selected) {
        btn.selected = YES;
        leftBtn.selected = NO;
        
        
    }
    
    else
    {
        btn.selected = NO;
        
    }

}


-(void)manBtn:(UIButton *)btn
{
    
    
    UIButton * womenBtn = [self.view viewWithTag:104];
    
    
    if ( !btn.selected) {
        btn.selected = YES;
        
        womenBtn.selected = NO;
        
    }
    
    else
    {
        btn.selected = NO;
        
    }
    
}


-(void)womenBtn:(UIButton *)btn
{
    
    
    UIButton * manBtn = [self.view viewWithTag:103];
    
    
    if ( !btn.selected) {
        btn.selected = YES;
        
        manBtn.selected = NO;
        
    }
    
    else
    {
        btn.selected = NO;
        
    }
    
}

-(void)coldBtn:(UIButton *)btn
{
    
    
    UIButton * hotBtn = [self.view viewWithTag:106];
    
    
    if ( !btn.selected) {
        btn.selected = YES;
        
        hotBtn.selected = NO;
        
    }
    
    else
    {
        btn.selected = NO;
        
    }
    
}

-(void)hotBtn:(UIButton *)btn
{
    
    
    UIButton * coldBtn = [self.view viewWithTag:105];
    
    
    if ( !btn.selected) {
        btn.selected = YES;
        
        coldBtn.selected = NO;
        
    }
    
    else
    {
        btn.selected = NO;
        
    }
    
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
