#import <UIKit/UIKit.h>

#ifndef Constant_h
#define Constant_h

#define HRFontStyle @"PingFangSC-Thin"
/** 导航栏高度 */
UIKIT_EXTERN CGFloat const HRNavH;


#define HRUIScreenW [UIScreen mainScreen].bounds.size.width
#define HRUIScreenH [UIScreen mainScreen].bounds.size.height
#define HRCommonScreenH (HRUIScreenH / 667)
#define HRCommonScreenW (HRUIScreenW / 375)

/** 弱引用 */
#define HRWeakSelf __weak typeof(self) weakSelf = self;

#define HRNSSearchPathForDirectoriesInDomains(fileName) [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", fileName]]
/** 将服务器返回的数据写成plist */
#define HRAFNWriteToPlist(fileName) [responseObject writeToFile:[NSString stringWithFormat:@"/Users/sswukang/Desktop/%@.plist", fileName] atomically:YES];
/// 创建数据库文件路径
#define HRSqliteFileName(fileName) [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", fileName]];

/****************************** 存储的key ********************/
#define kNSUserDefaults [NSUserDefaults standardUserDefaults]


/********************************************** 通知 key *******************/
/// 发送通知
#define kNotification [NSNotificationCenter defaultCenter]

/// -----------------创建通知----------------------------------
#define kUserDefault [NSUserDefaults standardUserDefaults]

/** 判断是否第一次登陆 */
#define firstLaunch @"firstLaunch"
/** 设置界面默认温度  */
#define defaultTemper  @"defaultTemper"

/** 保存的用户名Key */
#define kDefaultsUserName   @"UserName"
/** 保存的用户年龄 */
#define kDefaultsUserAge    @"age"
/** 保存的用户身高 */
#define kDefaultsUserHeight @"height"
/** 保存的用户体重 */
#define kDefaultsUserWeight @"weight"
/** 保存的使用模式 */
#define kDefaultsUserModel @"UseModel"
/** 保存的用户性别 */
#define kDefaultsUserSex @"sex"
/** 保存的用户温感爱好 */
#define kDefaultsUserTemper @"temper"

//首页选中的冷风 暖风 或者自动模式

#define SelectedModel @"SelectedModel"











#endif /* Constant_h */

