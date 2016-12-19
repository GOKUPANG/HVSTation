//
//  HomeController.h
//  HV station
//
//  Created by sswukang on 2016/10/19.
//  Copyright © 2016年 sswukang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BabyBluetooth.h"
#import <CoreBluetooth/CoreBluetooth.h>



@interface HomeController : UIViewController

//用来展示蓝牙的状态
@property(nonatomic,strong)UILabel * titleLabel;

//babybluetooth 单例

@property(nonatomic,strong)BabyBluetooth * baby ;

//已连接的外设
@property (nonatomic,strong) CBPeripheral * connectedPeripheral;
//监听的特征
@property(nonatomic,strong) CBCharacteristic * notifyCharacteristic;

//写入的特征

@property(nonatomic,strong) CBCharacteristic * writeCharacteristic ;









@end
