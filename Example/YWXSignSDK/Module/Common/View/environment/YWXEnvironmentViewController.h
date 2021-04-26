//
//  YWXEnvironmentViewController.h
//  YWXSignSDKDemo
//
//  Created by szyx on 2021/4/13.
//  Copyright © 2021 Beijing Digital Yixin Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWXBaseViewController.h"


/// SDK 开发环境。
typedef NS_ENUM(NSUInteger, YWXDemoEnvironment) {
    /// 生产环境
    YWXDemoEnvironmentProduction,
    /// 集成环境
    YWXDemoEnvironmentAcceptance,
    /// 测试环境
    YWXDemoEnvironmentTesting,
    /// 开发环境
    YWXDemoEnvironmentDevelopment,
};

typedef void(^EnvironmentChangeClick)(YWXDemoEnvironment currentEnvironment);
NS_ASSUME_NONNULL_BEGIN

@interface YWXEnvironmentViewController : YWXBaseViewController

@property(nonatomic, copy) NSString *environmentKeyName;

@property(nonatomic, copy) EnvironmentChangeClick environmentChangeBlack;

+(void)getCurrentEnviromentWithEnvironmentKeyName:(NSString *)environmentKeyName environmentChangeBlack:(EnvironmentChangeClick)environmentChangeBlack;

@end

NS_ASSUME_NONNULL_END
