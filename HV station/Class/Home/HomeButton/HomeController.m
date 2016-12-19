//
//  HomeController.m
//  HV station
//
//  Created by sswukang on 2016/10/19.
//  Copyright © 2016年 sswukang. All rights reserved.
//

#import "HomeController.h"
#import "HRUpButton.h"
#import "ErrorController.h"
#import "RegisterController.h"
#import <SVProgressHUD.h>
#import "FunctionController.h"
#import "PickerView.h"

@interface HomeController ()<UIGestureRecognizerDelegate, UIAlertViewDelegate>

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
/** life按钮 */
@property(nonatomic, weak) UIButton *lifeButton;
/** 中间的logo图片 */
@property(nonatomic, weak) UIImageView *middleImageView;
/** right按钮 */
@property(nonatomic, weak) UIButton *rightButton;

/** 上按钮 */
//@property(nonatomic, weak) HRUpButton *upButton;
/** 上按钮 */
@property(nonatomic, weak) UIButton *upButton;
/** 下按钮 */
@property(nonatomic, weak) UIButton *downButton;
/** 左按钮 */
@property(nonatomic, weak) UIButton *lifeFsButton;
/** 右按钮 */
@property(nonatomic, weak) UIButton *rightFsButton;
/** warn按钮 */
@property(nonatomic, weak) UIButton *warnButton;
/** cool按钮 */
@property(nonatomic, weak) UIButton *coolButton;
/** auto按钮 */
@property(nonatomic, weak) UIButton *autoButton;
/** c/f刷新按钮 */
@property(nonatomic, weak) UIButton *updateButton;
/** 日期时间按钮 */
@property(nonatomic, weak) UIButton *dateButton;
/** 温度按钮 */
@property(nonatomic, weak)  UIButton *tempButton;
/** 湿度按钮 */
@property(nonatomic, weak) UIButton *humidityButton;
/** 闹钟按钮 */
@property(nonatomic, weak) UIButton *clockButton;
/** my Date按钮 */
@property(nonatomic, weak) UIButton *myDateButton;
/** about HV Station按钮 */
@property(nonatomic, weak) UIButton *hvStationButton;
/** 记录当前点击的按钮 */
@property(nonatomic, weak) UIButton *currentButton;

/** 记录当前点击的是左边按钮还是右边按钮 */

@property(nonatomic, weak) UIButton *leftRightButton;
/** 色块横框 */
@property(nonatomic, strong) UIView *popView;
/** 色块竖框 */
@property(nonatomic, strong) UIView *popVView;
/** 色块黄色横框 */
@property(nonatomic, strong) UIView *popWView;

/** 导航条上的蓝牙连接label */
@property (nonatomic, strong) UILabel * blueLabel;


/** 定时的小时 */
@property (nonatomic, copy) NSString * setedHour;

/** 定时的分钟 */

@property (nonatomic, copy) NSString * setedMinute;

@end

@implementation HomeController
//150
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化BabyBluetooth 蓝牙库
   self.baby = [BabyBluetooth shareBabyBluetooth];
    //设置蓝牙委托
    [self babySetDelegate];
}



-(void)viewWillAppear:(BOOL)animated
{
      [self setUpViews];
}


#pragma mark -重点 发送数据给蓝牙


-(void)sendDataToBlueToothWithcommand:(Byte )command
                               temper:(Byte )temper
                                model:(Byte )model
                                 hour:(Byte )hour
                              miniute:(Byte )minute
{
    Byte byte[14] ;
    byte[0] = 0xaa;
    //帧长度为2
    byte[1] = 0x00;
    byte[2] = 0x09;
    //0x02表示APP发起
    byte[3] = 0x02;
    //控制码
    byte[4] = command;
    //传输结果 APP主动发起永远是0x01
    byte[5] = 0x01;
    //控制域 6个字节长度
    /*
     模式(1)：0x01 暖风 0x02 冷风 0x03 自动
     温度(2):
     温度格式(1)
     温度数值(1)
     湿度(1)
     定时(2):
     小时(1)
     分钟(1)
     */
    byte[6]  = model;
    byte[7]  = 0x01;
    //温度
    byte[8]  = temper;
    byte[9]  = 0x01;
    byte[10] = hour;
    byte[11] = minute;
    //校验码
    
    Byte checkMark = 0;

    for (int i = 3; i<=11; i++) {
        checkMark = checkMark + byte[i];
        
    }
    
    byte[12] = checkMark;
    
    //帧结束符
    byte[13] =0x55;
    
    
    
    NSData * myData = [NSData dataWithBytes:byte length:14];
    
    NSLog(@"%@",myData);
    
    
    if (!(self.connectedPeripheral == nil || self.writeCharacteristic ==nil)) {
        [self.connectedPeripheral writeValue:myData forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithResponse];
        
    }
    
    else{
        NSLog(@"外设没有连接或者写入特征不存在");
        
    }

}



-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"viewDidAppear");
    //停止之前的连接
    
    //断开连接蓝牙
    [_baby cancelAllPeripheralsConnection];
    
    //设置委托后直接可以使用，无需等待CBCentralManagerStatePoweredOn状态。
    //扫描十秒后停止
    
    _baby.scanForPeripherals().begin().stop(60);
    
}


#pragma mark -蓝牙配置和操作

//蓝牙网关初始化和委托方法设置

-(void)babySetDelegate
{
    __weak typeof (self) weakSelf = self;
    
    
    //这个block 是检查蓝牙是否打开的
    [_baby setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        
        
        if (central.state == CBManagerStatePoweredOn) {
            [SVProgressHUD showInfoWithStatus:@"设备打开成功，开始扫描设备" ];
            
        }
    
        else if(central.state == CBManagerStatePoweredOff ){
            
           // [SVProgressHUD showInfoWithStatus:@"尚未打开蓝牙" ];

            NSLog(@"蓝牙还没打开");
            
        }
        
        
    } ];
    
    
    //设置扫描到设备/外设的委托
    //要实现了  _baby.scanForPeripherals().begin(); 这个方法才会进入这个回调
  [_baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
      
     // NSLog(@"发现了外设的名字%@ 外设的uuid%@",peripheral.name,peripheral.identifier.UUIDString);
      
 
      
      
      if (peripheral.state == CBPeripheralStateConnected) {
          
          
          NSLog(@"已经连接上的蓝牙%@",peripheral.name);
          
      }
      
      
      NSLog(@"外设的名字%@",peripheral.name);
      
      
      //if ([peripheral.name hasPrefix:@"H"]) {
      
      
      
      //获取蓝牙模式
      NSString * usermodel = [kUserDefault objectForKey:kDefaultsUserModel];
      
      
      NSLog(@"现在的蓝牙模式%@",usermodel);
      
      
      
      
      if ([usermodel isEqualToString:@"left"]) {
          
      
          NSLog(@"%@",peripheral.name);
          
          
      
          if ([peripheral.name isEqualToString:@"HV LEFT "]) {
          
          NSLog(@"发现并且开始连接 HV LEFT");
          
             
          weakSelf.connectedPeripheral = peripheral;
          
          weakSelf.baby.having(weakSelf.connectedPeripheral).connectToPeripherals().discoverServices().discoverCharacteristics().begin(5);
          
          NSLog(@"发现了左蓝牙");
         // weakSelf.blueLabel.text =@"发现设备";

          weakSelf.blueLabel.text = @"Connecting...";
              
              weakSelf.baby.stop(0);

          
          return ;
              
              
              
          

      }
      
      }
      
      
      else if ([usermodel isEqualToString:@"right"])
      {
          
          if ([peripheral.name isEqualToString:@"LM07"]) {
              
                NSLog(@"发现并且开始连接 LM07");
              weakSelf.connectedPeripheral = peripheral;
              
              weakSelf.baby.having(weakSelf.connectedPeripheral).connectToPeripherals().discoverServices().discoverCharacteristics().begin(5);
              
              NSLog(@"发现了右蓝牙");
              // weakSelf.blueLabel.text =@"发现设备";
              
              weakSelf.blueLabel.text = @"Connecting...";
              
              NSLog(@"2333232323");
              
              
              
              weakSelf.baby.stop(0);

              return ;
              
              
          }

          
      }
      
      
      
    else
    {
        NSLog(@"左右蓝牙都没发现");
        
    }
      
  }
   
      ];
    
    //连接蓝牙成功的回调
    [_baby setBlockOnConnected:^(CBCentralManager *central, CBPeripheral *peripheral) {
        
        NSLog(@"连接%@成功 状态为%ld",peripheral.name,(long)peripheral.state);
        
        
        
        if ([peripheral.name hasPrefix:@"H"]) {
            weakSelf.blueLabel.text = @"ConnectedL";
            
         
        }
        
        
    else    if ([peripheral.name hasPrefix:@"L"]) {
            weakSelf.blueLabel.text = @"ConnectedR";
            
            
        }
        

        
        
    }];
    
    
    //连接蓝牙失败的回调
    
    [_baby setBlockOnFailToConnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        if ([peripheral.name hasPrefix:@"H"]) {
            weakSelf.blueLabel.text = @"Fail to connect";

        }
        
        
    }];
    
    
    
    //连接蓝牙断开的回调
    [_baby setBlockOnDisconnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"连接断开%@",peripheral.name);
        
        if ([peripheral.name hasPrefix:@"H"]) {
            weakSelf.blueLabel.text = @"Disconnected";

        }
        
        
        
    }];
    
    
    //设置发现service的委托
    
    [_baby setBlockOnDiscoverServices:^(CBPeripheral *peripheral, NSError *error) {
        
        NSLog(@"发现service%@",peripheral.name);
        
        
    }];
    
    
    #pragma mark - 这里很重要 发现监听和写入特征
    [_baby setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        
 //用for in 循环寻找 收发数据的两个Characteristics
        for (CBCharacteristic * charact in service.characteristics) {
            
            //获得监听特征
            if ([charact.UUID.UUIDString isEqualToString:@"FFE1"]) {
                
                [weakSelf.baby notify:peripheral characteristic:charact block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
                    
                  
                    weakSelf.notifyCharacteristic = charact;
                    
                    NSLog(@"监听到得值%@",charact.value);
                    
                    
                    [weakSelf notifyDataManageWithCharacteristic:charact AndPeripheral:peripheral];
                    
                    
                    
                }];
                
            }
            //获得写入特征
            if ([charact.UUID.UUIDString isEqualToString:@"FFE1"]) {
                
                weakSelf.writeCharacteristic = charact;
                
                
                
                NSLog(@"获得了写入特征");
                
                
                
            }
        }
        
    }];
    
    
    
    [_baby setBlockOnDidWriteValueForCharacteristic:^(CBCharacteristic *characteristic, NSError *error) {
        
        if (error == nil)
        {
            NSLog(@"写命令 操作成功!");
            
        }
        else
        {
            NSLog(@"写命令 操作失败!%@",error.localizedDescription);
        }

        
        
    }];
    
    
    
    
}



#pragma mark - 监听回调  数据处理

-(void)notifyDataManageWithCharacteristic:(CBCharacteristic*)Characteristic AndPeripheral:(CBPeripheral*)peripheral
{

    NSData * recieveData = Characteristic.value ;
    
    //把nsdata数据转化为 byte数组
    
    Byte * byte = (Byte * )[recieveData bytes];
    
    
    NSLog(@"byteeeeeeee%s",byte);
    
    for(int i=0;i<[recieveData length];i++)
        
        printf("testByte = %d\n",byte[i]);
    
    
    //判断这个帧是否是蓝牙帧
    
   // 1 判断帧头是否符合
   // 2 判断帧长度
   // 3 判断帧结束符
    
    
    
    
    //写一个根据检查返回模式改变按钮状态的方法
    [ self  changeBtnStateWithRecieveByte:byte];
    
    
    
    
    NSLog(@"蓝牙发过来的数据%@",Characteristic.value);
    
    
}




/// 获取当前时间
- (NSString *)loadCurrentDate
{
    
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
    
    // 设置日期格式
    [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    
    
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    //	DDLogDebug(@"currentDate------------%@", [NSDate date]);
    NSLog(@"currentDate------------%@", [NSDate date]);
    NSLog(@"%@",dateString);

    return dateString;
    
    
}




#pragma mark - 根据检查返回模式改变按钮状态的方法

-(void)changeBtnStateWithRecieveByte:(Byte *)Recievebyte
{
    
    // 这个是判断模式的字节 下标为 6
    Byte model = Recievebyte[6];
    
    
    //暖风
    if (model == 0x01)
    {
        NSLog(@"暖风状态");
        
        
        
        
        
        [kUserDefault setValue:@"warm" forKey:SelectedModel];
        
        
        
        
        
        
        
        self.warnButton.selected = YES;
        
        
        //如果是暖风，就让 四个上下左右四个按钮都可以点
        
        self.upButton.enabled      = YES;
        
        self.downButton.enabled    = YES;
        
        self.lifeFsButton.enabled  = YES;
        
        self.rightFsButton.enabled = YES ;
        
        //然后 冷风按钮  自动按钮不可点
        
        
        
        
        self.coolButton.enabled = NO;
        self.autoButton.enabled = NO;
        
    }
    //冷风
    else if (model == 0x02)
    {
        
        NSLog(@"冷风状态1231231231312123123设置冷按钮选中");
        
        
        [kUserDefault setValue:@"cool" forKey:SelectedModel];

        self.coolButton.selected = YES;

        //冷风状态下 左右按钮可点 上下按钮不可点
        self.upButton.enabled      = NO;
        
        self.downButton.enabled    = NO;
        
        self.lifeFsButton.enabled  = YES;
        
        self.rightFsButton.enabled = YES ;
        
        //然后 暖风按钮 自动按钮不可点
        
        self. warnButton.enabled = NO;
        
        self.autoButton.enabled = NO;
        
        
        
    }
    //自动
    else if (model == 0x03)
     
    {
        
        
        NSLog(@"自动状态");
        
        [kUserDefault setValue:@"auto" forKey:SelectedModel];

        
        self.autoButton.selected = YES;
        
        
        //自动模式 上下按钮可以点 左右按钮不可点
        self.upButton.enabled      =YES ;
        
        self.downButton.enabled    =YES ;
        
        self.lifeFsButton.enabled  = NO ;
        
        self.rightFsButton.enabled = NO ;
        
        //然后 暖风 冷风按钮不可点
        
        self.warnButton.enabled = NO ;
        
        self.coolButton.enabled = NO ;
        

    }
    //状态关
    else
    {
        
        
        //判断选中的状态
        [kUserDefault setValue:@"close" forKey:SelectedModel];
        
        //三个模式按钮 都弄成不选中状态
        
        self.warnButton.selected = NO ;
        
        self.coolButton.selected = NO ;
        
        self.autoButton.selected = NO ;
        
        //关闭状态 四个按钮都不可点
        
        self.upButton.enabled      = NO;
        self.downButton.enabled    = NO;
        self.lifeFsButton.enabled  = NO;
        self.rightFsButton.enabled = NO;
        
        //然后 暖风 冷风 自动 按钮都可以点
        
        self.warnButton.enabled = YES;
        
        self.coolButton.enabled = YES ;
        
        self.autoButton.enabled = YES ;
        
        
        
        
    }
    // 这个是获取温度的字节 下标为8
    
    Byte temper = Recievebyte[8];
    [self.tempButton  setTitle:[NSString stringWithFormat:@"%d℉",temper] forState:UIControlStateNormal];
    

    
    //这个是获取湿度的字节  下标为9
    
    Byte humidity = Recievebyte[9];
    
    [self.humidityButton  setTitle:[NSString stringWithFormat:@"%dRH",humidity] forState:UIControlStateNormal];
    

    
    //这个是获取定时小时的字节  下标为 10
    Byte  hour  = Recievebyte[10];
    

    //这个是获取分钟的字节 下标为 11
    
    Byte  minute = Recievebyte[11];
    
    [self.clockButton setTitle:[NSString stringWithFormat:@"%d:%d",hour,minute] forState:UIControlStateNormal];
    
    
}
#pragma mark - 内部方法
//初始化
- (void)setUpViews
{
    self.view.backgroundColor = [UIColor blackColor];
    //背景图片
    UIImageView *backgroundImageView = [[UIImageView alloc] init];
    backgroundImageView.image = [UIImage imageNamed:@"图层-2"];
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
   // nameLabel.backgroundColor = [UIColor redColor];
    
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
    
    //斌添加 蓝牙标题label
    
    UILabel * middleLabel = [[UILabel alloc]init];
    
    //middleLabel.backgroundColor = [UIColor greenColor];
    
    
    middleLabel.font = [UIFont fontWithName:@"PingFangSC-Thin" size:15.f];
    
    middleLabel.text = @"Searching...";
    
    
    middleLabel.textAlignment = NSTextAlignmentCenter;
    
    
    [self.navBar addSubview:middleLabel];
    
    self.blueLabel = middleLabel;
    
    
    
    
    
    
    //导航条下的自定义线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:lineView];
    self.lineView = lineView;
    
    //life按钮
    UIButton *lifeButton = [self setupButtonWithBackgroundImage:@"life" title:@"left" tag:10];
    
    [lifeButton setBackgroundImage:[UIImage imageNamed:@"life-right交互"] forState:UIControlStateSelected];
    self.lifeButton = lifeButton;
    
    //中间的logo图片
    UIImageView *middleImageView = [[UIImageView alloc] init];
    middleImageView.image = [UIImage imageNamed:@"logo"];
    [self.navBar addSubview:middleImageView];
    self.middleImageView = middleImageView;
    
    //right按钮
    UIButton *rightButton = [self setupButtonWithBackgroundImage:@"right" title:@"right" tag:11];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"life-right交互"] forState:UIControlStateSelected];
    self.rightButton = rightButton;
    
    
    //斌  根据本地存储的左右模式 设定选中状态
    
    
    NSString * modelStr = [kUserDefault objectForKey:kDefaultsUserModel];
    
    if ([modelStr isEqualToString:@"left"]) {
        self.lifeButton.selected = YES;
        
    }
    
    else {
        
        self.rightButton.selected = YES;
        
    }
    
    
    
    
    
    //上按钮
    //    HRUpButton *upButton = [ buttonWithType:UIButtonTypeCustom];
    //    upButton.tag = 12;
    //    [upButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [self addSubview:upButton];
    //    self.upButton = upButton;
    
    UIButton *upButton = [self setupButtonWithBackgroundImage:@"上" title:@"T." tag:12];
    [upButton setImage:[UIImage imageNamed:@"首页上"] forState:UIControlStateNormal];
    [upButton setTitleColor:[UIColor colorWithRed:0.0 green:193/ 255.0 blue:254 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    upButton.imageEdgeInsets = UIEdgeInsetsMake(0, 20*HRCommonScreenW, (-68+35) *HRCommonScreenH, 0);
    self.upButton = upButton;
    //斌添加 一开始还没选择模式的时候这个按钮不让点
    self.upButton.enabled = NO;
    
    
    
    //下按钮
    UIButton *downButton = [self setupButtonWithBackgroundImage:@"下" title:@"T." tag:13];
    [downButton setImage:[UIImage imageNamed:@"首页下"] forState:UIControlStateNormal];
    [downButton setTitleColor:[UIColor colorWithRed:0.0 green:193/ 255.0 blue:254 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    downButton.imageEdgeInsets = UIEdgeInsetsMake((-68+35) *HRCommonScreenH, 20*HRCommonScreenW, 0, 0);
    //    downButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    self.downButton = downButton;
    //斌添加 一开始还没选择模式的时候这个按钮不让点

    self.downButton.enabled = NO;

    
    //左按钮
    UIButton *lifeFsButton = [self setupButtonWithBackgroundImage:@"左" title:@"Fs." tag:14];
    [lifeFsButton setImage:[UIImage imageNamed:@"首页左"] forState:UIControlStateNormal];
    [lifeFsButton setTitleColor:[UIColor colorWithRed:0.0 green:193/ 255.0 blue:254 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    
    lifeFsButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, (-68+10) *HRCommonScreenH);
    lifeFsButton.titleEdgeInsets = UIEdgeInsetsMake(0, - 20*HRCommonScreenW, 0, 0);
    self.lifeFsButton = lifeFsButton;
    
    //斌添加 一开始还没选择模式的时候这个按钮不让点
    self.lifeFsButton.enabled = NO;
    
    
    //右按钮
    UIButton *rightFsButton = [self setupButtonWithBackgroundImage:@"右" title:@"Fs." tag:15];
    [rightFsButton setImage:[UIImage imageNamed:@"首页右"] forState:UIControlStateNormal];
    [rightFsButton setTitleColor:[UIColor colorWithRed:0.0 green:193/ 255.0 blue:254 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    
    rightFsButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10*HRCommonScreenW, 0, 0);
    rightFsButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5*HRCommonScreenW, 0, 0);
    self.rightFsButton = rightFsButton;
    
    
    //斌添加 一开始还没选择模式的时候这个按钮不让点
    self.rightFsButton.enabled = NO;
    
    
    //warn按钮
    UIButton *warnButton = [self setupButtonWithBackgroundImage:@"wam" title:@"warn" tag:16];
    [warnButton setBackgroundImage:[UIImage imageNamed:@"warm交互"] forState:UIControlStateSelected];
    self.warnButton = warnButton;
    
    //cool按钮
    UIButton *coolButton = [self setupButtonWithBackgroundImage:@"cool" title:@"cool" tag:17];
    [coolButton setBackgroundImage:[UIImage imageNamed:@"cool交互"] forState:UIControlStateSelected];
    self.coolButton = coolButton;
    //auto按钮
    UIButton *autoButton = [self setupButtonWithBackgroundImage:@"auto" title:@"auto" tag:18];
    [autoButton setBackgroundImage:[UIImage imageNamed:@"auto交互"] forState:UIControlStateSelected];
    self.autoButton = autoButton;
    
    //c/f刷新按钮
    UIButton *updateButton = [self setupButtonWithBackgroundImage:@"℃-℉" title:@"℃/℉" tag:19];
    
    updateButton.imageEdgeInsets = UIEdgeInsetsMake(-14, (83 * 0.5 - 30), 0, 0);
    updateButton.titleEdgeInsets = UIEdgeInsetsMake(24, (-83 *0.5 + 20), 0, 0);
    [updateButton setImage:[UIImage imageNamed:@"温度℃"] forState:UIControlStateNormal];
    self.updateButton = updateButton;
    self.updateButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Thin" size:15];
    
    
    //日期时间按钮
    
    NSString * currentTime = [self loadCurrentDate];
    
    NSString * currentMoment = [currentTime substringWithRange:NSMakeRange(11, 5)];
    

    UIButton *dateButton = [self setupButtonWithBackgroundImage:@"时间块" title:currentMoment tag:20];
    [dateButton setImage:[UIImage imageNamed:@"钟"] forState:UIControlStateNormal];
    dateButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Thin" size:12.f];
    dateButton.imageEdgeInsets = UIEdgeInsetsMake(-23.0, 12 + 1.5, 0, 0);
    dateButton.titleEdgeInsets = UIEdgeInsetsMake(24 - 17, (-90 *0.5 + 20) +11, 0, 0);
    dateButton.userInteractionEnabled = NO;
    UILabel *timeLabel = [[UILabel alloc] init];
    
    timeLabel.font = [UIFont fontWithName:@"PingFangSC-Thin" size:9.f];
    
    
    
    NSString * currentDay = [currentTime substringToIndex:10];
    
    currentDay = [currentDay stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    

    timeLabel.text = currentDay;
    
    
    NSLog(@"currentDay%@",currentDay);
    
    
    
  //  NSString *titleText = @"2016.10.06";
    NSString * titleText = currentDay;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = [UIFont fontWithName:@"PingFangSC-Thin" size:9.f];
    CGSize size = [titleText sizeWithAttributes:dict];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.frame = CGRectMake(0, 90 *0.5 - 14 , size.width, size.height);
    timeLabel.textColor = [UIColor colorWithRed:51 / 255.0 green:51 / 255.0  blue:51 / 255.0  alpha:1.0];
    [dateButton addSubview:timeLabel];
    self.dateButton = dateButton;
    
    //温度按钮
    UIButton *tempButton = [self setupButtonWithBackgroundImage:@"温度块" title:@"131℉" tag:21];
    tempButton.imageEdgeInsets = UIEdgeInsetsMake(-2, -2, 0, 0);
    tempButton.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0);
    [tempButton setImage:[UIImage imageNamed:@"温度"] forState:UIControlStateNormal];
    tempButton.userInteractionEnabled = NO;
    
    self.tempButton = tempButton;
    //湿度按钮
    UIButton *humidityButton = [self setupButtonWithBackgroundImage:@"湿度快" title:@"75RH" tag:22];
    humidityButton.imageEdgeInsets = UIEdgeInsetsMake(-2, -2, 0, 0);
    humidityButton.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0);
    [humidityButton setImage:[UIImage imageNamed:@"湿度"] forState:UIControlStateNormal];
    humidityButton.userInteractionEnabled = NO;
    self.humidityButton = humidityButton;
    
    //闹钟按钮
    UIButton *clockButton = [self setupButtonWithBackgroundImage:@"计时快" title:@"88:88" tag:23];
    clockButton.imageEdgeInsets = UIEdgeInsetsMake(-2, -2, 0, 0);
    clockButton.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0);
    [clockButton setImage:[UIImage imageNamed:@"计时"] forState:UIControlStateNormal];
    clockButton.userInteractionEnabled = YES;
    self.clockButton = clockButton;
    //my Date按钮
    UIButton *myDateButton = [self setupButtonWithBackgroundImage:@"HV-Station" title:@"My Date" tag:24];
    self.myDateButton = myDateButton;
    
    //about HV Station按钮
    UIButton *hvStationButton = [self setupButtonWithBackgroundImage:@"HV-Station" title:@"About HV Station" tag:25];
    self.hvStationButton = hvStationButton;
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
    
    [self.view addSubview:btn];
    return btn;
}

- (void)viewDidLayoutSubviews
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
        
    //斌添加 导航条正在连接label
    [self.blueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.navBar);
        make.centerY.equalTo(self.navBar);
        make.height.mas_equalTo(HRCommonScreenH * 55);
        make.width.mas_equalTo(HRUIScreenW * 0.3);

        
    }];
        
        
        
    }];
    //背景图
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-43 *HRCommonScreenH);
        make.top.equalTo(self.lineView.mas_bottom);
    }];
    
    //中间的logo图片
    [self.middleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(HRCommonScreenH * 95);
        make.height.mas_equalTo(30 *HRCommonScreenH);
        make.width.mas_equalTo(36 *HRCommonScreenW);
    }];
    
    //life按钮
    [self.lifeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.middleImageView);
        make.left.equalTo(self.view).offset(65);
        make.top.equalTo(self.view).offset(HRCommonScreenH *86);
        make.height.mas_equalTo(48 *HRCommonScreenH);
        make.width.mas_equalTo(74 *HRCommonScreenW);
    }];
    
    //right按钮
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.middleImageView);
        make.right.equalTo(self.view).offset(-65);
        make.top.equalTo(self.view).offset(HRCommonScreenH *86);
        make.height.mas_equalTo(48 *HRCommonScreenH);
        make.width.mas_equalTo(74 *HRCommonScreenW);
    }];
    
    //上按钮
    [self.upButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(HRCommonScreenH *157);
        make.height.mas_equalTo(63 *HRCommonScreenH);
        make.width.mas_equalTo(63 *HRCommonScreenW);
    }];
    
    //下按钮
    [self.downButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.upButton);
        make.top.equalTo(self.upButton.mas_bottom).offset(HRCommonScreenH *45);
        make.height.mas_equalTo(63 *HRCommonScreenH);
        make.width.mas_equalTo(63 *HRCommonScreenW);
    }];
    
    //左按钮
    [self.lifeFsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lifeButton);
        make.top.equalTo(self.view).offset(HRCommonScreenH *210);
        make.height.mas_equalTo(52 *HRCommonScreenH);
        make.width.mas_equalTo(68 *HRCommonScreenW);
    }];
    
    //右按钮
    [self.rightFsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightButton);
        make.top.equalTo(self.view).offset(HRCommonScreenH *210);
        make.height.mas_equalTo(52 *HRCommonScreenH);
        make.width.mas_equalTo(68 *HRCommonScreenW);
    }];
    
    //wam按钮
    [self.warnButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(72 *HRCommonScreenW);
        make.top.equalTo(self.view).offset(HRCommonScreenH *347);
        make.height.mas_equalTo(47 *HRCommonScreenH);
        make.width.mas_equalTo(84 *HRCommonScreenW);
    }];
    
    //wam按钮
    [self.warnButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(72 *HRCommonScreenW);
        make.top.equalTo(self.view).offset(HRCommonScreenH *347);
        make.height.mas_equalTo(47 *HRCommonScreenH);
        make.width.mas_equalTo(84 *HRCommonScreenW);
    }];
    
    //cool按钮
    [self.coolButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(218 *HRCommonScreenW);
        make.top.equalTo(self.view).offset(HRCommonScreenH *347);
        make.height.mas_equalTo(47 *HRCommonScreenH);
        make.width.mas_equalTo(84 *HRCommonScreenW);
    }];
    
    //auto按钮
    [self.autoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(HRCommonScreenH *418);
        make.height.mas_equalTo(47 *HRCommonScreenH);
        make.width.mas_equalTo(84 *HRCommonScreenW);
    }];
    //c/f刷新按钮
    [self.updateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(97 *HRCommonScreenW);
        make.top.equalTo(self.view).offset(HRCommonScreenH *488);
        make.height.mas_equalTo(45 );
        make.width.mas_equalTo(45 );
    }];
    
    //日期时间按钮
    [self.dateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(237 *HRCommonScreenW);
        make.top.equalTo(self.view).offset(HRCommonScreenH *488);
        make.height.mas_equalTo(45 );
        make.width.mas_equalTo(45 );
    }];
    //温度按钮
    [self.tempButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(62 *HRCommonScreenW);
        make.top.equalTo(self.view).offset(HRCommonScreenH *539 +3 );
        make.height.mas_equalTo(49 *HRCommonScreenH);
        make.width.mas_equalTo(76 *HRCommonScreenW);
    }];
    //湿度按钮
    [self.humidityButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(150 *HRCommonScreenW);
        make.top.equalTo(self.view).offset(HRCommonScreenH *539+3);
        make.height.mas_equalTo(49 *HRCommonScreenH);
        make.width.mas_equalTo(76 *HRCommonScreenW);
    }];
    //闹钟按钮
    [self.clockButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(237 *HRCommonScreenW);
        make.top.equalTo(self.view).offset(HRCommonScreenH *539+3);
        make.height.mas_equalTo(49 *HRCommonScreenH);
        make.width.mas_equalTo(76 *HRCommonScreenW);
    }];
    
    //my Date按钮
    [self.myDateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view).offset(HRCommonScreenH *619);
        make.height.mas_equalTo(49 *HRCommonScreenH);
        make.width.mas_equalTo(188 *HRCommonScreenW);
    }];
    
    //about HV Station按钮
    [self.hvStationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(188 *HRCommonScreenW);
        make.top.equalTo(self.view).offset(HRCommonScreenH *619);
        make.height.mas_equalTo(49 *HRCommonScreenH);
        make.width.mas_equalTo(188 *HRCommonScreenW);
    }];
}

#pragma mark - UI事件 点击按钮发送控制帧
- (void)buttonClick:(UIButton *)button
{
    //    self.currentButton.selected = NO;
    //     button.selected = !button.selected;
    //    self.currentButton = button;
    NSLog(@"%stag:%ld", __func__, (long)button.tag);
    
    
#pragma  mark - 切换到左蓝牙的方法
      if (button.tag == 10) {
        
        //斌 左蓝牙模式

        //left
          
           [kUserDefault setValue:@"left" forKey:kDefaultsUserModel];

          
          
          //先判断这个按钮是不是选中状态，如果是选中状态 点击这个按钮不处理任何事件
          
          
          if (self.lifeButton.selected ) {
              
              
              NSLog(@"DoNothing");
              
          }
          
          
          else
          {
              NSLog(@"first selected");
              
              //只有第一次切换的时候才执行更换蓝牙的方法
              
              
              
              //断开连接 蓝牙 然后 重新扫描 连接右边的蓝牙
              
              
              
              NSString * userModel = [kUserDefault objectForKey:kDefaultsUserModel];
              
              
              NSLog(@"%@",userModel);
              
              
              //断开连接蓝牙
              [_baby cancelAllPeripheralsConnection];
              
             // [_baby cancelPeripheralConnection:self.connectedPeripheral];
              
              
              //设置委托后直接可以使用，无需等待CBCentralManagerStatePoweredOn状态。
              //扫描十秒后停止
              
              
              
              _baby.scanForPeripherals().begin().stop(60);
              
              
              
              
              
              
              
              
          }
          

        
        
         //先把左按钮设为选中状态  取消右按钮选中状态 然后改变选中蓝牙 把选中状态本地化
        
        
        self.rightButton.selected = NO;
        
        self.lifeButton.selected = YES ;
        
        
          

          
    }
#pragma  mark - 切换到右蓝牙的方法

    
      else if (button.tag == 11) {
          //right
         //斌 右蓝牙模式
        
        //先把右按钮设为选中状态  取消左按钮选中状态 然后改变选中蓝牙

        [kUserDefault setValue:@"right" forKey:kDefaultsUserModel];
          
         
          
          
          
          //先判断这个按钮是不是选中状态，如果是选中状态 点击这个按钮不处理任何事件
          
          
          if (self.rightButton.selected ) {
              
              
              NSLog(@"DoNothing");
              
          }
          
          
          else
          {
              NSLog(@"first selected");
              
              //只有第一次切换的时候才执行更换蓝牙的方法
              
              
              
              //断开连接 蓝牙 然后 重新扫描 连接右边的蓝牙
              
              
              
              NSString * userModel = [kUserDefault objectForKey:kDefaultsUserModel];
              
              
              NSLog(@"%@",userModel);
              
              
              //断开连接蓝牙
              [_baby cancelAllPeripheralsConnection];
              
           //   [_baby cancelPeripheralConnection:self.connectedPeripheral];

              
              //设置委托后直接可以使用，无需等待CBCentralManagerStatePoweredOn状态。
              //扫描十秒后停止
              
              
              
              _baby.scanForPeripherals().begin().stop(60);
              
              
              
              
              
              
              
              
          }
          

          

        self.rightButton.selected = YES;
        
        self.lifeButton.selected = NO ;
        
        

    }
    else if (button.tag == 12) {
        //上
        
        
        NSString * modelString = [kUserDefault objectForKey:SelectedModel];
        
        if ([modelString isEqualToString:@"warm"])
        {
             //暖风模式 的加温度
            
            // command 0xa2 温度增加   model 0x01 暖风模式
            
            [self sendDataToBlueToothWithcommand:0xa2 temper:0x00 model:0x01 hour:0x00 miniute:0x00];
            
        }
        
        else if ([modelString isEqualToString:@"auto"])
        {
            //自动模式的加温度
            
            
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:nil
                                  message:@"是否重新设定睡眠温度?"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  otherButtonTitles:@"确定", nil];
            
            [alert show];

            
            // command 0xa2 温度增加   model 0x03 自动模式
            
            //加个弹窗  是否改变默认温度
            
            
          //  [self sendDataToBlueToothWithcommand:0xa2 temper:0x00 model:0x03 hour:0x00 miniute:0x00];
            
        }
        
        
       // [self setUpBtnClick:button];
        
        
    }else if (button.tag == 13) {
        //下
        
        NSString * modelString = [kUserDefault objectForKey:SelectedModel];
        
        if ([modelString isEqualToString:@"warm"])
        {
            //暖风模式 的减温度
            
            // command 0xa3 温度减少   model 0x01 暖风模式
            
            
            
            [self sendDataToBlueToothWithcommand:0xa2 temper:0x00 model:0x01 hour:0x00 miniute:0x00];
            
            
            
            
            
        }
        
        else if ([modelString isEqualToString:@"auto"])
        {
            //自动模式的减温度
            
            
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:nil
                                  message:@"是否重新设定睡眠温度?"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  otherButtonTitles:@"确定", nil];
            
            [alert show];
            
            // command 0xa2 温度减少  model 0x03 自动模式
          
            
           // [self sendDataToBlueToothWithcommand:0xa2 temper:0x00 model:0x03 hour:0x00 miniute:0x00];
            
        }

        
        
       // [self setUpBtnClick:button];
    }else if (button.tag == 14) {
        //FS左
        
        
        NSString * modelString = [kUserDefault objectForKey:SelectedModel];
        
        if ([modelString isEqualToString:@"warm"])
        {
            //暖风模式 的减风速
            
            // command 0xa5 风速减少   model 0x01 暖风模式
            
            
            
            [self sendDataToBlueToothWithcommand:0xa5 temper:0x00 model:0x01 hour:0x00 miniute:0x00];
            
            
            
            
            
        }
        
        else if ([modelString isEqualToString:@"cool"])
        {
            //自动模式的减风速
            
            // command 0xa5 风速减少  model 0x03 自动模式
            
            
            [self sendDataToBlueToothWithcommand:0xa5 temper:0x00 model:0x02 hour:0x00 miniute:0x00];
            
        }

        
        
        //[self setUpBtnClick:button];
    }else if (button.tag == 15) {
        
        //FS右
        
        NSString * modelString = [kUserDefault objectForKey:SelectedModel];
        
        if ([modelString isEqualToString:@"warm"])
        {
            //暖风模式 的加风速
            
            // command 0xa4 风速增加   model 0x01 暖风模式
            
            
            
            [self sendDataToBlueToothWithcommand:0xa4 temper:0x00 model:0x01 hour:0x00 miniute:0x00];
            
            
            
            
            
        }
        
        else if ([modelString isEqualToString:@"cool"])
        {
            //自动模式的加风速
            
            // command 0xa4 风速增加  model 0x02 冷风模式
            
            
            [self sendDataToBlueToothWithcommand:0xa4 temper:0x00 model:0x02 hour:0x00 miniute:0x00];
            
        }
        

      //  [self setUpBtnClick:button];
    }else if (button.tag == 16) {
        
        
        //warn 都可以点击
        
        
        //如果是按钮没选中状态下  点击这个按钮让按钮成为选中状态  然后发送 暖风控制帧
        
        
        if (!button.isSelected) {
            
            button.selected = YES;
            
            
            if (self.setedHour.length==0&&self.setedMinute.length==0) {
                
                //没设置过
                
                // command 0xa6 功能选择  model 0x01 暖风模式 暖风默认定时7小时
                [self sendDataToBlueToothWithcommand:0xa6 temper:0x22 model:0x01 hour:0x07 miniute:0x00];
                
            }
            
            else{
                //设置过定时 按照定时来
                
                // command 0xa6 功能选择  model 0x01 暖风模式 暖风默认定时7小时
                [self sendDataToBlueToothWithcommand:0xa6 temper:0x22 model:0x01 hour:[self.setedHour intValue] miniute:[self.setedMinute intValue]];
            }

            
           
            
            
            
        }
        
        //选中状态下 点击按钮发送 关闭状态 帧 关闭按钮选中状态
        else
        {
            
            
            button.selected = NO;
            
            [self sendDataToBlueToothWithcommand:0xa7 temper:0x22 model:0x01 hour:0x10 miniute:0x33];
            
            
        }
        
        
        
      //  [self setupEnabelStatusButton:button upYes:YES lifeFsYes:YES];
        //斌添加 这里加一个第二次
        
    }else if (button.tag == 17) {
        
        //cool 上下可以点击 左右不可以点击
        
        
        //冷风状态
        //如果是按钮没选中状态下  点击这个按钮让按钮成为选中状态  然后发送 冷风控制帧 冷风定时默认8小时

        if (!button.isSelected) {
            
            button.selected = YES;
            
            if (self.setedHour.length==0&&self.setedMinute.length==0) {
                
                //没设置过
                
                // command 0xa6 功能选择  model 0x02 冷风模式 冷风默认定时8小时
                [self sendDataToBlueToothWithcommand:0xa6 temper:0x22 model:0x02 hour:0x08 miniute:0x00];
                
            }
            
            else{
                //设置过定时 按照定时来
                
                // command 0xa6 功能选择  model 0x02 冷风模式 按照定时来
                [self sendDataToBlueToothWithcommand:0xa6 temper:0x22 model:0x02 hour:[self.setedHour intValue] miniute:[self.setedMinute intValue]];
            }
            

            
            
            

        }
        
        //选中状态下 点击按钮发送 关闭状态 帧 关闭按钮选中状态

        else{
             // command 0xa7 功能退出  model 0x02 退出冷风模式
            NSLog(@"关闭冷风模式");

            button.selected = NO;
            
            [self sendDataToBlueToothWithcommand:0xa7 temper:0x22 model:0x02 hour:0x10 miniute:0x33];
            

        }
        
       // [self setupEnabelStatusButton:button upYes:NO lifeFsYes:YES];
        
    }else if (button.tag == 18) {
        
        //auto 上下可以点击 左右不可以点击
        
        //冷风状态
        //如果是按钮没选中状态下  点击这个按钮让按钮成为选中状态  然后发送 冷风控制帧
        
        if (!button.isSelected) {
            
           
            
            button.selected = YES;
            
            if (self.setedHour.length==0&&self.setedMinute.length==0) {
                
                //没设置过
                
               // command 0xa6 功能选择  model 0x03 自动模式 自动默认定时12小时
                [self sendDataToBlueToothWithcommand:0xa6 temper:0x22 model:0x03 hour:12 miniute:0x00];
                
            }
            
            else{
                //设置过定时 按照定时来
                
                // command 0xa6 功能选择  model 0x03 自动模式 根据系统设置的自动时分上传
                [self sendDataToBlueToothWithcommand:0xa6 temper:0x22 model:0x03 hour:[self.setedHour intValue] miniute:[self.setedMinute intValue]];
            }
            

            
            
            
            
        }
        
        //选中状态下 点击按钮发送 关闭状态 帧 关闭按钮选中状态
        
        else{
            // command 0xa7 功能退出  model 0x03 退出自动模式
            NSLog(@"关闭自动模式");
            
            button.selected = NO;
            
            [self sendDataToBlueToothWithcommand:0xa7 temper:0x22 model:0x03 hour:0x10 miniute:0x33];
            
            
        }

        
        
        
       // [self setupEnabelStatusButton:button upYes:YES lifeFsYes:NO];
        
    }
    
    else if (button.tag == 19)
    {
        NSLog(@"cf");
        
    }
    
 #pragma mark - 定时设置
    else if (button.tag == 23)
    {
        
        PickerView * picker = [PickerView showPickerViewInVCTop:self withType:PickerViewTypeData];
        
        NSMutableArray * hourArray  = [NSMutableArray array];
        
        for (int i =  0; i<12; i++) {
            
            if (i<10) {
                NSString * str = [NSString stringWithFormat:@"0%d",i];
                 [hourArray addObject:str];
            }
            
            else{
            NSString * str = [NSString stringWithFormat:@"%d",i];
                 [hourArray addObject:str];
            }
           
            
        }
        
        NSString * hourStr = @"hour";
        
        NSArray * hourArr = [NSArray arrayWithObject:hourStr];
        
        
        
        NSMutableArray * minuteArray = [NSMutableArray array];
        
        for (int i = 0; i<60; i++) {
            if (i<10) {
                NSString * str = [NSString stringWithFormat:@"0%d",i];
                [minuteArray addObject:str];
            }
            
            else{
                NSString * str = [NSString stringWithFormat:@"%d",i];
                [minuteArray addObject:str];
            }
            
        }
        
        NSString * minuteStr= @"minute";
        
        NSArray *minuteArr = [NSArray arrayWithObject:minuteStr];
        
        
        NSMutableArray * dataArr = [NSMutableArray array];
        
        [dataArr addObject:hourArray];
        [dataArr addObject:hourArr];
        
        [dataArr addObject:minuteArray];
        [dataArr addObject:minuteArr];
        
        
        
        picker.dataSources = dataArr;
        
        
        [picker setSelectBlock:^(NSObject *data, BOOL isSureBtn) {
            
            
            if (isSureBtn) {
                
                NSString * btntitle = [NSString stringWithFormat:@"%@",data];
                
                btntitle = [btntitle stringByReplacingOccurrencesOfString:@" " withString:@""];
                btntitle = [btntitle stringByReplacingOccurrencesOfString:@"(" withString:@""];
                btntitle = [btntitle stringByReplacingOccurrencesOfString:@")" withString:@""];
                btntitle = [btntitle stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                btntitle = [btntitle stringByReplacingOccurrencesOfString:@"," withString:@""];
                btntitle = [btntitle stringByReplacingOccurrencesOfString:@"hour" withString:@""];
                btntitle = [btntitle stringByReplacingOccurrencesOfString:@"minute" withString:@""];
                
                
                
                NSLog(@"str %@",btntitle);
                
                    self.setedHour = [btntitle substringToIndex:2];
                    self.setedMinute = [btntitle substringFromIndex:2];
                    
                    NSLog(@"长度为4");
                    
                    NSLog(@"hour%@",self.setedHour);
                    NSLog(@"minute%@",self.setedMinute);

            //    NSString * model = [kUserDefault objectForKey:SelectedModel];
                
                [self sendDataToBlueToothWithcommand:0xa8 temper:0x00 model:0x00 hour:[self.setedHour intValue] miniute:[self.setedMinute intValue]];
                
                
                
            }
          
            
        }];
        

        
        
        
        [self loadCurrentDate];
        
    }
    else if (button.tag == 24)//my date
    {
        
        RegisterController *RVC = [[RegisterController alloc] init];
        
        //ErrorController *errorVC = [[ErrorController alloc] init];
        [self.navigationController pushViewController:RVC animated:YES];
    }
    
    else if (button.tag == 25)
    {
        
        
        FunctionController *funVC = [[FunctionController alloc]init];
        
        
        [self.navigationController pushViewController:funVC animated:YES];
        
    }
    
    
   
    
    
    
}
- (void)setUpBtnClick:(UIButton *)button
{
    
    //如果warm按钮选中状态下
    if (self.warnButton.isSelected) {
        
        //让上下 左右按钮都可以点
        [self setupleftRightEnabelStatusButton:button upYes:YES lifeFsYes:YES];
        if (button.tag == 12 || button.tag == 13) {
         //   [self showPopMuneV];
        }
        if (button.tag == 14 || button.tag == 15) {
            
           // [self showPopWMune];
        }
        
    }else if (self.coolButton.isSelected)
    {
        if (button.tag == 12 || button.tag == 13) {
          //  [self showPopMuneV];
        }
        if (button.tag == 14 || button.tag == 15) {
            
          //  [self showPopMune];
        }
        
        [self setupleftRightEnabelStatusButton:button upYes:NO lifeFsYes:YES];
    }else if (self.autoButton.isSelected)
    {
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:nil
                              message:@"是否重新设定睡眠温度?"
                              delegate:self
                              cancelButtonTitle:@"取消"
                              otherButtonTitles:@"确定", nil];
        
        [alert show];
        
        [self setupleftRightEnabelStatusButton:button upYes:YES lifeFsYes:NO];
    }else
    {
        
        [self setupleftRightEnabelStatusButton:button upYes:YES lifeFsYes:YES];
    }
    
}

/*
 upYes上下方向键是否可以点击 YES可以点击 NO不可以点击
 lifeFs左右方向键是否可以点击 YES可以点击 NO不可以点击
 */
- (void)setupEnabelStatusButton:(UIButton *)button upYes:(BOOL)upYes lifeFsYes:(BOOL)lifeFs
{
    
    
    self.currentButton.selected = NO;
    button.selected = !button.selected;
    self.currentButton = button;
    if (upYes) {
        self.upButton.enabled = YES;
        self.downButton.enabled = YES;
        
    }else
    {
        self.upButton.enabled = NO;
        self.downButton.enabled = NO;
    }
    
    if (lifeFs) {
        self.lifeFsButton.enabled = YES;
        self.rightFsButton.enabled = YES;
        
    }else
    {
        self.lifeFsButton.enabled = NO;
        self.rightFsButton.enabled = NO;
    }
}

/*
 upYes上下方向键是否可以点击 YES可以点击 NO不可以点击
 lifeFs左右方向键是否可以点击 YES可以点击 NO不可以点击
 */
- (void)setupleftRightEnabelStatusButton:(UIButton *)button upYes:(BOOL)upYes lifeFsYes:(BOOL)lifeFs
{
    
    self.leftRightButton.selected = NO;
    button.selected = !button.selected;
    self.leftRightButton = button;
    if (upYes) {
        self.upButton.enabled = YES;
        self.downButton.enabled = YES;
        
    }else
    {
        self.upButton.enabled = NO;
        self.downButton.enabled = NO;
    }
    
    if (lifeFs) {
        self.lifeFsButton.enabled = YES;
        self.rightFsButton.enabled = YES;
        
    }else
    {
        self.lifeFsButton.enabled = NO;
        self.rightFsButton.enabled = NO;
    }
}


#pragma mark - 自动状态下弹出的黄条
///弹出竖框tag 31- 37
- (void)showPopMuneV
{
    
    self.popVView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    self.popVView .backgroundColor = [UIColor clearColor];
    //    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(HRUIScreenW * 0.5- 21, HRUIScreenH *0.25 , 40, HRUIScreenH * 0.5)];
    
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(HRUIScreenW, HRUIScreenH *0.25 , 40, HRUIScreenH * 0.5)];
    buttonView.backgroundColor = [UIColor whiteColor];
    
    [self.popVView addSubview:buttonView];
    
    CGFloat btnH = HRUIScreenH * 0.5 / 5;
    for (int i = 0; i < 5; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor blueColor];
        button.tag = i + 68;
        button.frame = CGRectMake(0, btnH * i, 40, btnH);
        button.titleLabel.font = [UIFont fontWithName:HRFontStyle size:18];
        [button setTitleColor:[UIColor colorWithRed:51 / 255.0 green:51 / 255.0  blue:51 / 255.0  alpha:1.0] forState:UIControlStateNormal];
        
        if (i == 0) {
            [button setTitle:@"68℉" forState:UIControlStateNormal];
            button.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:250 / 255.0 blue:228 / 255.0 alpha:1.0];
        }else if (i == 1)
        {
            [button setTitle:@"69℉" forState:UIControlStateNormal];
            button.backgroundColor = [UIColor colorWithRed:254 / 255.0 green:242 / 255.0 blue:183 / 255.0 alpha:1.0];
        }else if (i == 2)
        {
            
            [button setTitle:@"70℉" forState:UIControlStateNormal];
            button.backgroundColor = [UIColor colorWithRed:251 / 255.0 green:228 / 255.0 blue:122 / 255.0 alpha:1.0];
        }else if (i == 3)
        {
            
            [button setTitle:@"71℉" forState:UIControlStateNormal];
            button.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:210 / 255.0 blue:46 / 255.0 alpha:1.0];
        }else if (i == 4)
        {
            
            [button setTitle:@"72℉" forState:UIControlStateNormal];
            button.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:168 / 255.0 blue:46 / 255.0 alpha:1.0];
        }
        
        [button addTarget:self action:@selector(colorButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [buttonView addSubview:button];
    }
    
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.0 initialSpringVelocity:0.0 options:0 animations:^{
        CGRect rect = buttonView.frame;
        rect.origin.x = HRUIScreenW * 0.5- 21;
        buttonView.frame = rect;
    } completion:nil];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPopViewClick:)];
    tap.delegate = self;
    [self.popVView addGestureRecognizer:tap];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.popVView];
}

///弹出黄色横框 tag 41- 47
- (void)showPopWMune
{
    self.popWView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    self.popWView .backgroundColor = [UIColor clearColor];
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(HRUIScreenW, HRUIScreenH *0.5, HRUIScreenW * 0.8, 40)];
    buttonView.backgroundColor = [UIColor whiteColor];
    
    [self.popWView addSubview:buttonView];
    
    CGFloat btnW = HRUIScreenW * 0.8 / 7;
    for (int i = 0; i < 7; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor blueColor];
        button.tag = i + 1;
        button.frame = CGRectMake(btnW * i, 0, btnW, 40);
        button.titleLabel.font = [UIFont fontWithName:HRFontStyle size:18];
        [button setTitleColor:[UIColor colorWithRed:51 / 255.0 green:51 / 255.0  blue:51 / 255.0  alpha:1.0] forState:UIControlStateNormal];
        
        if (i == 0) {
            [button setTitle:@"30%" forState:UIControlStateNormal];
            button.backgroundColor = [UIColor colorWithRed:254 / 255.0 green:250 / 255.0 blue:233 / 255.0 alpha:1.0];
        }else if (i == 1)
        {
            [button setTitle:@"40%" forState:UIControlStateNormal];
            button.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:247 / 255.0 blue:205 / 255.0 alpha:1.0];
        }else if (i == 2)
        {
            
            [button setTitle:@"50%" forState:UIControlStateNormal];
            button.backgroundColor = [UIColor colorWithRed:253 / 255.0 green:236 / 255.0 blue:159 / 255.0 alpha:1.0];
        }else if (i == 3)
        {
            
            [button setTitle:@"60%" forState:UIControlStateNormal];
            button.backgroundColor = [UIColor colorWithRed:254 / 255.0 green:224 / 255.0 blue:83 / 255.0 alpha:1.0];
        }else if (i == 4)
        {
            
            [button setTitle:@"70%" forState:UIControlStateNormal];
            button.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:204 / 255.0 blue:25 / 255.0 alpha:1.0];
        }else if (i == 5)
        {
            
            [button setTitle:@"80%" forState:UIControlStateNormal];
            button.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:174 / 255.0 blue:49 / 255.0 alpha:1.0];
        }else if (i == 6)
        {
            
            [button setTitle:@"90%" forState:UIControlStateNormal];
            button.backgroundColor = [UIColor colorWithRed:251 / 255.0 green:161 / 255.0 blue:3 / 255.0 alpha:1.0];
        }
        [button addTarget:self action:@selector(colorButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [buttonView addSubview:button];
    }
    
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.0 initialSpringVelocity:0.0 options:0 animations:^{
        CGRect rect = buttonView.frame;
        rect.origin.x = HRUIScreenW * 0.1;
        buttonView.frame = rect;
    } completion:nil];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPopViewClick:)];
    tap.delegate = self;
    [self.popWView addGestureRecognizer:tap];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.popWView];
}

///弹出绿色横框 tag 1- 7
- (void)showPopMune
{
    
    self.popView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    self.popView .backgroundColor = [UIColor clearColor];
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(HRUIScreenW , HRUIScreenH *0.5, HRUIScreenW * 0.8, 40)];
    buttonView.backgroundColor = [UIColor whiteColor];
    
    [self.popView addSubview:buttonView];
    
    CGFloat btnW = HRUIScreenW * 0.8 / 7;
    for (int i = 0; i < 7; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor blueColor];
        button.tag = i + 1;
        button.frame = CGRectMake(btnW * i, 0, btnW, 40);
        button.titleLabel.font = [UIFont fontWithName:HRFontStyle size:18];
        [button setTitleColor:[UIColor colorWithRed:51 / 255.0 green:51 / 255.0  blue:51 / 255.0  alpha:1.0] forState:UIControlStateNormal];
        
        if (i == 0) {
            [button setTitle:@"30%" forState:UIControlStateNormal];
            button.backgroundColor = [UIColor colorWithRed:216 / 255.0 green:244 / 255.0 blue:227 / 255.0 alpha:1.0];
        }else if (i == 1)
        {
            [button setTitle:@"40%" forState:UIControlStateNormal];
            button.backgroundColor = [UIColor colorWithRed:183 / 255.0 green:241 / 255.0 blue:205 / 255.0 alpha:1.0];
        }else if (i == 2)
        {
            
            [button setTitle:@"50%" forState:UIControlStateNormal];
            button.backgroundColor = [UIColor colorWithRed:136 / 255.0 green:243 / 255.0 blue:177 / 255.0 alpha:1.0];
        }else if (i == 3)
        {
            
            [button setTitle:@"60%" forState:UIControlStateNormal];
            button.backgroundColor = [UIColor colorWithRed:74 / 255.0 green:239 / 255.0 blue:137 / 255.0 alpha:1.0];
        }else if (i == 4)
        {
            
            [button setTitle:@"70%" forState:UIControlStateNormal];
            button.backgroundColor = [UIColor colorWithRed:50 / 255.0 green:225 / 255.0 blue:116 / 255.0 alpha:1.0];
        }else if (i == 5)
        {
            
            [button setTitle:@"80%" forState:UIControlStateNormal];
            button.backgroundColor = [UIColor colorWithRed:2 / 255.0 green:195 / 255.0 blue:75 / 255.0 alpha:1.0];
        }else if (i == 6)
        {
            
            [button setTitle:@"90%" forState:UIControlStateNormal];
            button.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:164 / 255.0 blue:62 / 255.0 alpha:1.0];
        }
        [button addTarget:self action:@selector(colorButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [buttonView addSubview:button];
    }
    
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.0 initialSpringVelocity:0.0 options:0 animations:^{
        CGRect rect = buttonView.frame;
        rect.origin.x = HRUIScreenW * 0.1;
        buttonView.frame = rect;
        
    } completion:nil];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPopViewClick:)];
    tap.delegate = self;
    [self.popView addGestureRecognizer:tap];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.popView];
}




#pragma mark - 点击黄色框条按钮实现方法
- (void)colorButtonClick:(UIButton *)btn
{
    NSLog(@"btn.tag%ld",(long)btn.tag);
    
    // command 0xa9 自动模式改变默认温度   model 0x03 自动模式
    
    //加个弹窗  是否改变默认温度
    
   // 68 == 44
    
   // 72 == 48
    
      [self sendDataToBlueToothWithcommand:0xa9 temper:btn.tag model:0x03 hour:0x00 miniute:0x00];
    
    [self performSelector:@selector(tapPopViewClick:)];
    
    

}
- (void)tapPopViewClick:(UITapGestureRecognizer *)tap
{
    for (UIView *allView in [UIApplication sharedApplication].keyWindow.subviews) {
        if ([allView isEqual:self.popView] || [allView isEqual:self.popVView] || [allView isEqual:self.popWView]) {
            [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                NSLog(@"allView-NSStringFromClass%@", NSStringFromCGRect(allView.frame));
                allView.alpha = 0.0;
            } completion:^(BOOL finished) {
                
                [allView removeFromSuperview];
                [self.view.layer removeAllAnimations];
            }];
        }
    }
}
#pragma mark - UIGestureRecognizerDelegate手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    NSLog(@"%@", touch.view);
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableView"]) {
        return NO;
    }
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCell"]) {
        return NO;
    }
    return YES;
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
    }else if (buttonIndex == 1)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self showPopMuneV];
        });
    }
}





@end
