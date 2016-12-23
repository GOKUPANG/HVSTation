//
//  PickerView.m
//  TouGuApp
//
//  Created by tianshikechuang on 16/7/18.
//  Copyright © 2016年 tianshikechuang. All rights reserved.
//

#import "PickerView.h"


#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height

@interface PickerView () <UIPickerViewDelegate,UIPickerViewDataSource>
{
    
}

//还是要用到pickerView

@property(nonatomic, strong) UIPickerView * pickerView;

@property(nonatomic, strong) UIDatePicker * datePicker;

@property(nonatomic, strong) NSMutableArray * selectArr;


@end





@implementation PickerView

+ (PickerView *)showPickerViewInkeyWindowTopWithType:(PickerViewType)type{
    
    UIView * view = [UIApplication sharedApplication].keyWindow;
    
    
    return [self showPickerViewInView:view withType:type];
    
    
}


+ (PickerView *)showPickerViewInVCTop:(UIViewController *)VC withType:(PickerViewType)type{
    
    UIView * view;
    if (VC.tabBarController) {
        view = VC.tabBarController.view;
    }else if (VC.navigationController){
        view = VC.navigationController.view;
    }else{
        view = VC.view;
    }
    
    return [self showPickerViewInView:view withType:type];
}


+ (PickerView *)showPickerViewInView:(UIView *)view withType:(PickerViewType)type{
    
    
    PickerView * picker = [[PickerView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    picker.pickerType = type;
    
    [picker showInView:view];
    [picker addSureAndCancelButton];

    return picker;
}




//
- (instancetype)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, screenWidth, screenHeight);
        self.selectArr = [NSMutableArray array];
        self.contentHeight = 230;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeFromSuperview)];
        
        tap.numberOfTapsRequired = 2;
        
        [self addGestureRecognizer:tap];
        
        
    }
    return self;
}




//懒加载 pickView

- (UIPickerView *)pickerView{
    
    
 //如果datePicker 是 存在的 那就把它 从父视图上移除  这里到底是为什么  不懂...
    
    if (_datePicker) {
        [_datePicker removeFromSuperview];
    }
    
    
    //如果pickerView 不存在  就创建一个pickerView
    if (!_pickerView) {
        
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, screenHeight - self.contentHeight, screenWidth, self.contentHeight)];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        
    }
    return _pickerView;
}



//懒加载 datePicker
- (UIDatePicker *)datePicker{
    
    if (_pickerView) {
        [_pickerView removeFromSuperview];
    }
    
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, screenHeight - self.contentHeight, screenWidth, self.contentHeight)];
        _datePicker.backgroundColor = [UIColor whiteColor];
        _datePicker.date = [NSDate date];
        [_datePicker addTarget:self action:@selector(datePickerAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _datePicker;
}



//set方法
- (void)setPickerType:(PickerViewType)pickerType{
    
    _pickerType = pickerType;
    
    switch (pickerType) {
        case PickerViewTypeDate_Time:
            
            self.datePicker.datePickerMode = UIDatePickerModeTime;
            [self addSubview:self.datePicker];
            
            break;
        case PickerViewTypeDate_Date:
            self.datePicker.datePickerMode = UIDatePickerModeDate;
            [self addSubview:self.datePicker];
            
            break;
            
        case PickerViewTypeDate_DateAndTime:
            self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
            [self addSubview:self.datePicker];
            
            break;
        case PickerViewTypeDate_Timer:
            self.datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
            [self addSubview:self.datePicker];
            
            break;
            
        case PickerViewTypeData:
            
            [self addSubview:self.pickerView];
            
            break;
            
        default:
            break;
    }
   
}



// set方法
- (void)setDataSources:(NSArray *)dataSources{
    
    _dataSources = dataSources;
    for (NSArray * arr in dataSources) {
        if (![arr isKindOfClass:[NSArray class]]) {
            _dataSources = @[];
            NSLog(@"\n\n--------- 传入的dataSources格式有误，请传入嵌套数组! (@[@[@\"1 - 1\",@\"1 - 2\"],@[@\"2 - 1\",@\"2 - 2\"]]) --------\n\n");
            return;
        }
        [self.selectArr addObject:[arr firstObject]];
    }
}


//多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{

    if (self.dataSources) {
        
        
        return self.dataSources.count;
        
        
        
    }else{
        return 0;
    }
    
}



//多少行 
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (self.dataSources[component]) {
        NSArray * arr = self.dataSources[component];
        return arr.count;
    }else{
        return 0;
    }
}



// pickerView的component  内容 每行的string

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSArray * arr = self.dataSources[component];
    
    return [arr objectAtIndex:row];
}


// pickerView 选中某一行的时候 实现的方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    NSArray * arr = self.dataSources[component];
    [self.selectArr replaceObjectAtIndex:component withObject:[arr objectAtIndex:row]];
    
    
    if (self.selectBlock) {
        self.selectBlock(self.selectArr,NO);
    }

}


//把sure 和 cancel 的 View加进去灰色选择项

- (void)addSureAndCancelButton{
    
    
    //弹出来的picker 是 230 高  这个选择 sure 或者  no 的是 40高
    
    UIView * buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight - self.contentHeight - 40, screenWidth, 40)];
    buttonView.backgroundColor = [UIColor grayColor];
    
    [self addSubview:buttonView];
    
    
    
    // 长 100  高 40 的取消按钮
    UIButton * cancel = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];

    
    [cancel setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [buttonView addSubview:cancel];
    
    
    // 长 100 高 40 的确定按钮
    UIButton * sure = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth - 100, 0, 100, 40)];
    [sure setTitle:@"Confirm" forState:UIControlStateNormal];
   // [sure setTitle:@"确定" forState:UIControlStateNormal];

    [sure addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [buttonView addSubview:sure];
    
    sure.tag = 101;
    
    
}

//点击sure 和 cancel 按钮的时候 进入这个方法

- (void)buttonAction:(UIButton  *)button{
    
    [self removeFromSuperview];
    
    //tag等于 101 相当于   btn 是  sure btn
    //如果 selectBlock存在  而且点击的按钮是 sure 按钮
    if (self.selectBlock && button.tag == 101) {
        
        // 如果picker的类型是 data  就用 自己输入的数组 来做
        if (self.pickerType == PickerViewTypeData) {
            self.selectBlock(self.selectArr,YES);
        }else{
            
            //如果是 date  就用  picker 的那几种日期的 来做
            self.selectBlock(self.datePicker.date,YES);
        }
    }
}



- (void)datePickerAction:(UIDatePicker *)picker{
    if (self.selectBlock) {
        self.selectBlock(picker.date,NO);
    }
}




- (void)showInView:(UIView *)view{
    
    [view addSubview:self];
    
    //先把他放在 屏幕底部 高度为0
    self.frame = CGRectMake(0, screenHeight, screenWidth, 0);
    
    //然后用UIView 的方法来 让他升起来
    [UIView animateWithDuration:0.8 animations:^{
        
        self.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    }];
}



//从父视图 上 移除
- (void)removeFromSuperview{
    
    
    // 先用UIView动画 移到 下面去 再从父视图上删除
    [UIView animateWithDuration:0.8 animations:^{
        
        self.frame = CGRectMake(0, screenHeight, screenWidth, screenHeight);
        
    } completion:^(BOOL finished) {
        [super removeFromSuperview];
    }];
    
    
    
}

//////////////////////////////////////////////////////////////////////////////////////////
//      PickerViewTypeDate -- 对应的属性 与 方法
//////////////////////////////////////////////////////////////////////////////////////////


- (void)setMinimumDate:(NSDate *)minimumDate{
    
    [self.datePicker setMinimumDate:minimumDate];
}
- (NSDate *)minimumDate{
    return self.datePicker.minimumDate;
}

- (void)setMaximumDate:(NSDate *)maximumDate{
    [self.datePicker setMaximumDate:maximumDate];
}
- (NSDate *)maximumDate{
    return self.datePicker.maximumDate;
}

- (void)setCountDownDuration:(NSTimeInterval)countDownDuration{
    [self.datePicker setCountDownDuration:countDownDuration];
}
- (NSTimeInterval)countDownDuration{
    return self.datePicker.countDownDuration;
}

- (void)setMinuteInterval:(NSInteger)minuteInterval{
    [self.datePicker setMinuteInterval:minuteInterval];
}
- (NSInteger)minuteInterval{
    return self.datePicker.minuteInterval;
}

- (void)setDate:(NSDate *)date animated:(BOOL)animated{
    [self.datePicker setDate:date animated:animated];
}

//////////////////////////////////////////////////////////////////////////////////////////





@end
